import xml.etree.ElementTree as ET
import csv

# Pfade der XML-Dateien
datei1_path = 'test.xml'
datei2_path = 'out/api_response_Mannheim_Hbf_20241025_192313.xml'

# XML-Dateien einlesen und parsen
tree1 = ET.parse(datei1_path)
root1 = tree1.getroot()

tree2 = ET.parse(datei2_path)
root2 = tree2.getroot()

# Datenstruktur zur Speicherung der Einträge aus Datei 1
datei1_data = {}

# Informationen aus Datei 1 extrahieren (ID, tl_c, tl_n, ar_pt, dp_pt)
for s in root1.findall("s"):
    id_ = s.get("id")
    tl = s.find("tl")
    ar = s.find("ar")
    dp = s.find("dp")

    # Werte mit leeren Zeichenketten initialisieren
    tl_c = tl.get("c") if tl is not None else ""
    tl_n = tl.get("n") if tl is not None else ""
    ar_pt = ar.get("pt") if ar is not None else ""
    dp_pt = dp.get("pt") if dp is not None else ""

    # Speichern der Werte in einem Dictionary
    datei1_data[id_] = {
        "id": id_,
        "tl_c": tl_c,
        "tl_n": tl_n,
        "ar_pt": ar_pt,
        "dp_pt": dp_pt
    }

# Datenstruktur zur Speicherung der Einträge aus Datei 2 (ID, ar_ct, dp_ct)
datei2_data = {}

# Informationen aus Datei 2 extrahieren
for s in root2.findall("s"):
    id_ = s.get("id")
    ar = s.find("ar")
    dp = s.find("dp")
    
    # Werte mit leeren Zeichenketten initialisieren
    ar_ct = ar.get("ct") if ar is not None else ""
    dp_ct = dp.get("ct") if dp is not None else ""
    
    # Speichern der Werte in einem Dictionary
    datei2_data[id_] = {
        "ar_ct": ar_ct,
        "dp_ct": dp_ct
    }

# CSV-Datei erstellen und Header definieren
with open("output1.csv", mode="w", newline='', encoding="utf-8") as csv_file:
    writer = csv.writer(csv_file, delimiter=';')
    writer.writerow(["ID", "Zugart", "Zugnummer", "geplante Ankunft", "tatsaechliche Ankunft", "geplante Abfahrt", "tatsaechliche Abfahrt"])
    
    # Durch alle Einträge in Datei 1 iterieren und ggf. fehlende Werte aus Datei 2 ergänzen
    for id_, data1 in datei1_data.items():
        # Hole die zugehörigen Daten aus Datei 2 oder setze leere Zeichenketten
        data2 = datei2_data.get(id_, {"ar_ct": "", "dp_ct": ""})
        
        # Zeile zur CSV-Datei hinzufügen
        writer.writerow([
            data1["id"],
            data1["tl_c"],
            data1["tl_n"],
            data1["ar_pt"],
            data2["ar_ct"],
            data1["dp_pt"],
            data2["dp_ct"]
        ])

print("CSV-Datei 'output1.csv' wurde erfolgreich erstellt.")
