import xml.etree.ElementTree as ET
import os
from enum import Enum
import colorama
from colorama import Fore, Back, Style

# Initialize colorama
colorama.init()

import pymysql
from dill.pointers import children

ids= []

class tags(Enum):
    s = "TimetableStop"
    ar = "Ankunft"
    dp = "Abfahrt"
    tl = "Zug"

class attributes(Enum):
    f = "Filter Flags"
    t = "Trip Type"
    o = "Owner"
    c = "Category"
    n = "Zugumber"
    pt = "Planned Time"
    l = "Line"
    ppth = "Fahrtweg"
    pp = "Geplante Plattform"
    wings = "wings"



# Parse XML file
tree1 = ET.parse("../sample/api_response_Trier_Hbf_20241103_162655_plan16.xml")
tree2 = ET.parse("../sample/api_response_Trier_Hbf_20241103_162655_fchg.xml")
changes = tree2.getroot()
plan = tree1.getroot()

timetableStopElements = plan.findall('s')
timetable_station = plan.get('station')

print("--------------------")
print("Station: ", timetable_station)
for s in  plan.findall("s"):
    print("ID:", s.get('id'))
    ids.append(s.get('id'))
    children = s.findall('*')
    for child in children:
        print(tags[child.tag].value)
        for attribute in child.attrib:
            print(attributes[attribute].value, ":", child.get(attribute))
    print("++++++++++++++++++++")

print ("*******************")
for id in ids:
    for s in changes.findall("s"):
        if s.get('id') == id:
            print("Changes for ID:", id)
