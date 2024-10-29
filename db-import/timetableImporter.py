import xml.etree.ElementTree as ET
import os
import pymysql
from dask.config import paths

# Connect to the MySQL database
connection = pymysql.connect(
    host='localhost',
    user='root',
    password='root',
    database='bahn'
)
#import path
path= '../out'

def importXMLs():

    files = os.listdir(path)
    # Iterate over each file
    for file in files:
        # Check if the file is an XML file
        if file.startswith('api_response_') and file.endswith('.xml'):
            print(path+'/'+file)
            # Import the XML file
            importXML(path+'/'+file)
            print(f"Imported {file}")

def importXML(path):
    # Parse XML file
    tree = ET.parse(path)
    root = tree.getroot()

    # Insert into schedule_entries table with correct mapping
    with connection.cursor() as cursor:
        timetable_station = root.get('station')

        for s in root.findall('s'):
            timetableStop_id = s.get('id')
            timetableStop_arrival = s.get('ar')
            timetableStop_departure = s.get('dp')
            timetableStop_conn= s.get('conn')
            timetableStop_eva= s.get('eva')
            timetableStop_hd= s.get('hd')
            timetableStop_hpc= s.get('hpc')
            timetableStop_m= s.get('m')
            timetableStop_ref= s.get('ref')
            timetableStop_rtr= s.get('rtr')



            cursor.execute(
                """
                INSERT INTO `timetableStop`(`ar`, `conn`, `dp`, `eva`, `hd`, `hpc`, `id`, `m`, `ref`, `rtr` ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s);
                """,(timetableStop_arrival, timetableStop_conn, timetableStop_departure, timetableStop_eva, timetableStop_hd, timetableStop_hpc, timetableStop_id, timetableStop_m, timetableStop_ref, timetableStop_rtr)
            )

            cursor.execute(
                """
                INSERT INTO `timetable`(`eva`, `m`, `s`, `station`) VALUES (%s, %s, %s, %s);
                """,(timetableStop_eva, timetableStop_m, timetableStop_id, timetable_station)
            )

            children = s.findall('*')
            for child in children:
                if child.tag == 'tl':
                    tl_f = child.get('f')
                    tl_n = child.get('n')
                    tl_c = child.get('c')
                    tl_t = child.get('t')
                    tl_o = child.get('o')
                    # Insert data into schedule_entries
                    cursor.execute(
                        """
                        INSERT INTO `tripLabel`(`timetableStop_id`,`c`, `f`, `n`, `o`, `t`) VALUES (%s, %s, %s, %s, %s, %s);
                        """,(timetableStop_id,tl_c, tl_f, tl_n, tl_o, tl_t)
                    )
                if child.tag == 'ar' or child.tag == 'dp':
                    ar_cde = child.get('cde')
                    ar_clt = child.get('clt')
                    ar_cp = child.get('cp')
                    ar_cpth = child.get('cpth')
                    ar_cs = child.get('cs')
                    ar_ct = child.get('ct')
                    ar_dc = child.get('dc')
                    ar_hi = child.get('hi')
                    ar_l = child.get('l')
                    ar_m = child.get('m')
                    ar_pde = child.get('pde')
                    ar_pp = child.get('pp')
                    ar_ppth = child.get('ppth')
                    ar_ps = child.get('ps')
                    ar_pt = child.get('pt')
                    ar_tra = child.get('tra')
                    ar_wings = child.get('wings')
                    # Insert data into schedule_entries
                    cursor.execute(
                        """
                       INSERT INTO `event`(`timetableStop_id`, `event_type` ,`cde`, `clt`, `cp`, `cpth`, `cs`, `ct`, `dc`, `hi`, `l`, `m`, `pde`, `pp`, `ppth`, `ps`, `pt`, `tra`, `wings`) VALUES (%s,%s,%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s);
                        """,(timetableStop_id, child.tag, ar_cde, ar_clt, ar_cp, ar_cpth, ar_cs, ar_ct, ar_dc, ar_hi, ar_l, ar_m, ar_pde, ar_pp, ar_ppth, ar_ps, ar_pt, ar_tra, ar_wings)
                    )
                    if len(child.findall("*")) > 0 :
                        subchildren = child.findall('*')
                        # Execute the query
                        cursor.execute("SELECT event_id FROM event ORDER BY event_id DESC LIMIT 1")
                        # Fetch the result
                        result = cursor.fetchone()[0]
                        for subchild in subchildren:
                            if subchild.tag == 'm':
                                m_event_id = result
                                m_c = child.get('c')
                                m_cat = child.get('cat')
                                m_del = child.get('del')
                                m_dm = child.get('dm')
                                m_ec = child.get('ec')
                                m_elnk = child.get('elnk')
                                m_ext = child.get('ext')
                                m_from = child.get('from')
                                m_id = child.get('id')
                                m_int = child.get('int')
                                m_o = child.get('o')
                                m_pr = child.get('pr')
                                m_t = child.get('t')
                                m_tl = child.get('tl')
                                m_to = child.get('to')
                                m_ts = child.get('ts')

                                # Insert data into schedule_entries
                                cursor.execute(
                                    """
                                   INSERT INTO `message`(`timetableStop_id`,`event_id`,`c`, `cat`, `del`, `dm`, `ec`, `elnk`, `ext`, `from`, `id`, `int`, `o`, `pr`, `t`, `tl`, `to`, `ts`) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s,%s);
                                   """,(timetableStop_id, m_event_id, m_c, m_cat, m_del, m_dm, m_ec, m_elnk, m_ext, m_from, m_id, m_int, m_o, m_pr, m_t, m_tl, m_to, m_ts)
                                )

                if child.tag == 'm':
                    m_c = child.get('c')
                    m_cat = child.get('cat')
                    m_del = child.get('del')
                    m_dm = child.get('dm')
                    m_ec = child.get('ec')
                    m_elnk = child.get('elnk')
                    m_ext = child.get('ext')
                    m_from = child.get('from')
                    m_id = child.get('id')
                    m_int = child.get('int')
                    m_o = child.get('o')
                    m_pr = child.get('pr')
                    m_t = child.get('t')
                    m_tl = child.get('tl')
                    m_to = child.get('to')
                    m_ts = child.get('ts')

                    # Insert data into schedule_entries
                    cursor.execute(
                        """
                       INSERT INTO `message`(`timetableStop_id`,`c`, `cat`, `del`, `dm`, `ec`, `elnk`, `ext`, `from`, `id`, `int`, `o`, `pr`, `t`, `tl`, `to`, `ts`) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s,%s);
                       """,(timetableStop_id, m_c, m_cat, m_del, m_dm, m_ec, m_elnk, m_ext, m_from, m_id, m_int, m_o, m_pr, m_t, m_tl, m_to, m_ts)
                    )



        connection.commit()

importXMLs()
connection.close()
