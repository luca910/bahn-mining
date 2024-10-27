import xml.etree.ElementTree as ET

import pymysql

# Connect to the MySQL database
connection = pymysql.connect(
    host='localhost',
    user='root',
    password='root',
    database='bahn'
)

# Parse XML file
tree = ET.parse('../out/api_response_Frankfurt_Main_Hbf_20241026_101227_plan10.xml')
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
                   INSERT INTO `event`(`timetableStop_id` ,`cde`, `clt`, `cp`, `cpth`, `cs`, `ct`, `dc`, `hi`, `l`, `m`, `pde`, `pp`, `ppth`, `ps`, `pt`, `tra`, `wings`) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s);
                    """,(timetableStop_id, ar_cde, ar_clt, ar_cp, ar_cpth, ar_cs, ar_ct, ar_dc, ar_hi, ar_l, ar_m, ar_pde, ar_pp, ar_ppth, ar_ps, ar_pt, ar_tra, ar_wings)
                )

    connection.commit()
connection.close()
