import logging
import sys
import xml.etree.ElementTree as ET
import os
from datetime import datetime

import pymysql


# Connect to the MySQL database
connection = pymysql.connect(
    host=os.environ.get('DB_HOST', 'localhost'),
    user='root',
    password='root',
    database='bahn'
)
# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

logging.info(connection.ping())

def calcSqlTimestamp(string):
    if string is None:
        return None

    dt = datetime.strptime(string, '%y%m%d%H%M')

    return dt.strftime('%Y-%m-%d %H:%M:%S')



def importPlanneds():

    files = os.listdir(path)
    for file in files:

        # Check if the file is an XML file
        if file.startswith('api_response_') and not file.endswith('fchg.xml'):
            logging.info(path+'/'+file)
            # Import the XML file
            importPlanned(path+'/'+file)
            os.rename(path+'/'+file, path+'/imported/'+file)
            logging.info("moved file"+path+'/'+file + " to "+path+'/imported/'+file)
            logging.info(f"Imported {file}")

def importPlanned(path):
    # Parse XML file
    tree = ET.parse(path)
    root = tree.getroot()
    sourceFile = path.split('/')[-1]

    # Insert into schedule_entries table with correct mapping
    with connection.cursor() as cursor:
        timetable_station = root.get('station')

        for s in root.findall('s'):
            timetableStop_id = s.get('id')
            children = s.findall('*')
            filterFlags = tripType = owner = category = trainNumber = None
            plannedArrival = plannedArrivalPlatform = arrivalLine = plannedArrivalPath = None
            plannedDeparture = plannedDeparturePlatform = departureLine = plannedDeparturePath = None
            for child in children:
                if child.tag == "tl":
                    filterFlags = child.get('f')
                    tripType = child.get('t')
                    owner = child.get('o')
                    category = child.get('c')
                    trainNumber = child.get('n')

                if child.tag == "ar":
                    plannedArrival = calcSqlTimestamp(child.get('pt'))
                    plannedArrivalPlatform = child.get('pp')
                    arrivalLine = child.get('l')
                    plannedArrivalPath = child.get('ppth')
                if child.tag == "dp":
                    plannedDeparture = calcSqlTimestamp(child.get('pt'))
                    plannedDeparturePlatform = child.get('pp')
                    departureLine = child.get('l')
                    plannedDeparturePath = child.get('ppth')

            cursor.execute("""
                INSERT INTO plannedStops (timetableStop_id, station, filterFlag, tripType, owner, trainCategory, trainNumber, plannedArrival, plannedArrivalPlatform, arrivingLine, plannedDeparture, plannedDeparturePlatform, departingLine, plannedDeparturePath, plannedArrivalPath, sourceFile)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                """, (timetableStop_id, timetable_station, filterFlags, tripType, owner, category, trainNumber, plannedArrival, plannedArrivalPlatform, arrivalLine, plannedDeparture, plannedDeparturePlatform, departureLine, plannedDeparturePath, plannedArrivalPath, sourceFile))

    connection.commit()

def importChanges():

    files = os.listdir(path)
    # Iterate over each file
    for file in files:
        # Check if the file is an XML file
        if file.startswith('api_response_') and  file.endswith('fchg.xml'):
            logging.info(path+'/'+file)
            # Import the XML file
            importChanged(path+'/'+file)
            os.rename(path+'/'+file, path+'/imported/'+file)
            logging.info("moved file"+path+'/'+file + " to "+path+'/imported/'+file)
            logging.info(f"Imported {file}")

def importChanged(path):
    # Parse XML file
    tree = ET.parse(path)
    root = tree.getroot()
    sourceFile = path.split('/')[-1]
    fileTimestamp =  sourceFile.split('_')[-3]+"-"+sourceFile.split('_')[-2]

    # Insert into schedule_entries table with correct mapping
    with connection.cursor() as cursor:
        timetable_station = root.get('station')
        eva= root.get('eva')

        for s in root.findall('s'):
            timetableStop_id = s.get('id')
            children = s.findall('*')
            changedArrival = changedArrivalPlatform = arrivalLine = changedArrivalPath = None
            changedDeparture = changedDeparturePlatform = departureLine = changedDeparturePath = None
            plannedArrival = plannedArrivalPlatform = plannedArrivalPath = None
            plannedDeparture = plannedDeparturePlatform = plannedDeparturePath = None
            cancellationTime = eventStatus = None
            plannedArrival = plannedArrivalPlatform = arrivalLine = plannedArrivalPath = None


            for child in children:
                if child.tag == "m":
                    validFrom = child.get('from')
                    validUntil = child.get('to')
                    priority = child.get('pr')
                    category = child.get('cat')
                    messageId = child.get('id')
                    messageType = child.get('t')
                    messageCode = child.get('c')
                    timestamp = child.get('ts-tts')



                    cursor.execute("""
                    INSERT INTO messages (fileTimestamp,timetableStop_id, eva, station, validFrom, validUntil, priority, category, message_id, messageType, messageCode, timeStamp)
                    VALUES (%s,%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                    """, (fileTimestamp,timetableStop_id, eva, timetable_station, validFrom, validUntil, priority, category, messageId, messageType, messageCode, timestamp))

                if child.tag == "ar":
                    plannedArrival = calcSqlTimestamp(child.get('pt'))
                    plannedArrivalPlatform = child.get('pp')
                    arrivalLine = child.get('l')
                    plannedArrivalPath = child.get('ppth')
                    changedArrival = calcSqlTimestamp(child.get('ct'))
                    changedArrivalPlatform = child.get('cp')
                    changedArrivalPath = child.get('cpth')

                    cancellationTime = child.get('clt')
                    eventStatus = child.get('cs')

                    grandchildren = child.findall('m')

                    for grandchild in grandchildren:
                        messageId = grandchild.get('id')
                        messageType = grandchild.get('t')
                        messageCode = grandchild.get('c')
                        timestamp = grandchild.get('ts-tts')

                        cursor.execute("""
                        INSERT INTO arrivalMessages (fileTimestamp,eventStatus,cancellationTime, timetableStop_id, station, eva, changedArrivalPath, plannedArrivalPath, plannedArrivalTime, changedArrivalTime, plannedArrivalPlatform, changedArrivalPlatform, arrivalLine, message_id, messageType, messageCode, timeStamp)
                        VALUES (%s,%s,%s,%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                        """, (fileTimestamp,eventStatus,cancellationTime,timetableStop_id, timetable_station, eva, changedArrivalPath, plannedArrivalPath, plannedArrival, changedArrival, plannedArrivalPlatform, changedArrivalPlatform, arrivalLine, messageId, messageType, messageCode, timestamp))


                if child.tag == "dp":
                    plannedDeparture = calcSqlTimestamp(child.get('pt'))
                    plannedDeparturePlatform = child.get('pp')
                    departureLine = child.get('l')
                    plannedDeparturePath = child.get('ppth')
                    changedDeparture = calcSqlTimestamp(child.get('ct'))
                    changedDeparturePlatform = child.get('cp')
                    changedDeparturePath = child.get('cpth')

                    cancellationTime = calcSqlTimestamp(child.get('clt'))
                    eventStatus = child.get('cs')

                    grandchildren = child.findall('m')

                    for grandchild in grandchildren:
                        messageId = grandchild.get('id')
                        messageType = grandchild.get('t')
                        messageCode = grandchild.get('c')
                        timestamp = grandchild.get('ts-tts')

                        cursor.execute("""
                        INSERT INTO departureMessages (fileTimestamp,eventStatus,cancellationTime, timetableStop_id, station, eva, changedDeparturePath, plannedDeparturePath, plannedDepartureTime, changedDepartureTime, plannedDeparturePlatform, changedDeparturePlatform, departureLine, message_id, messageType, messageCode, timeStamp)
                        VALUES (%s,%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                        """, (fileTimestamp,eventStatus,cancellationTime, timetableStop_id, timetable_station, eva, changedDeparturePath, plannedDeparturePath, plannedDeparture, changedDeparture, plannedDeparturePlatform, changedDeparturePlatform, departureLine, messageId, messageType, messageCode, timestamp))

    connection.commit()


for arg in sys.argv[1:]:
    path = arg
    # Check if path is a directory
    if not os.path.isdir(path):
        logging.info("Path is not a directory")
        continue
    if path.endswith('imported'):
        logging.info("Path is the imported directory")
        continue
    if not os.path.exists(path + '/imported'):
        os.mkdir(path + '/imported')
    importPlanneds()
    importChanges()


#importXML("db-import/api_response_Trier_Hbf_20241103_162655_plan16.xml")

connection.close()
logging.info("Connection closed")
