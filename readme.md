# Datenanalyse der Verspätungen und Ausfälle im Zugverkehr

Diese Dokumentation beschreibt die verfügbaren Daten und Queries zur Analyse von Verspätungen, Ausfällen und weiteren Kennzahlen im Zugverkehr. Jede Query hat eine entsprechende CSV-Datei mit vordefinierten Spalten für die Datenauswertung.

---

## 1. Verspätungsauswertungen (Abfahrten/Ankünfte)

### 1.1 Verspätung pro Kalenderwoche
- **CSV-Datei:** `verspaetung_pro_kw.csv`
- **Spalten:**
    - `Kalenderwoche`
    - `Typ` (Abfahrt/Ankunft)
    - `Durchschnittliche_Verspätung` (Minuten)

### 1.2 Verspätung pro Kalenderwoche und Betreiber
- **CSV-Datei:** `verspaetung_pro_kw_betreiber.csv`
- **Spalten:**
    - `Kalenderwoche`
    - `Betreiber`
    - `Typ` (Abfahrt/Ankunft)
    - `Durchschnittliche_Verspätung` (Minuten)

### 1.3 Verspätung pro Kalenderwoche und Linie
- **CSV-Datei:** `verspaetung_pro_kw_linie.csv`
- **Spalten:**
    - `Kalenderwoche`
    - `Linie`
    - `Typ` (Abfahrt/Ankunft)
    - `Durchschnittliche_Verspätung` (Minuten)

### 1.4 Verspätung pro Linie
- **CSV-Datei:** `verspaetung_pro_linie.csv`
- **Spalten:**
    - `Linie`
    - `Typ` (Abfahrt/Ankunft)
    - `Durchschnittliche_Verspätung` (Minuten)

### 1.5 Verspätung pro Betreiber
- **CSV-Datei:** `verspaetung_pro_betreiber.csv`
- **Spalten:**
    - `Betreiber`
    - `Typ` (Abfahrt/Ankunft)
    - `Durchschnittliche_Verspätung` (Minuten)

### 1.6 Verspätung pro Bahnhof
- **CSV-Datei:** `verspaetung_pro_bahnhof.csv`
- **Spalten:**
    - `Bahnhof`
    - `Typ` (Abfahrt/Ankunft)
    - `Durchschnittliche_Verspätung` (Minuten)

---

## 2. Ausfallauswertungen (Abfahrten/Ankünfte)

### 2.1 Ausfälle pro Kalenderwoche
- **CSV-Datei:** `ausfaelle_pro_kw.csv`
- **Spalten:**
    - `Kalenderwoche`
    - `Typ` (Abfahrt/Ankunft)
    - `Anzahl_Ausfälle`

### 2.2 Ausfälle pro Kalenderwoche und Betreiber
- **CSV-Datei:** `ausfaelle_pro_kw_betreiber.csv`
- **Spalten:**
    - `Kalenderwoche`
    - `Betreiber`
    - `Typ` (Abfahrt/Ankunft)
    - `Anzahl_Ausfälle`

### 2.3 Ausfälle pro Kalenderwoche und Linie
- **CSV-Datei:** `ausfaelle_pro_kw_linie.csv`
- **Spalten:**
    - `Kalenderwoche`
    - `Linie`
    - `Typ` (Abfahrt/Ankunft)
    - `Anzahl_Ausfälle`

### 2.4 Ausfälle pro Linie
- **CSV-Datei:** `ausfaelle_pro_linie.csv`
- **Spalten:**
    - `Linie`
    - `Typ` (Abfahrt/Ankunft)
    - `Anzahl_Ausfälle`

### 2.5 Ausfälle pro Betreiber
- **CSV-Datei:** `ausfaelle_pro_betreiber.csv`
- **Spalten:**
    - `Betreiber`
    - `Typ` (Abfahrt/Ankunft)
    - `Anzahl_Ausfälle`

### 2.6 Ausfälle pro Bahnhof
- **CSV-Datei:** `ausfaelle_pro_bahnhof.csv`
- **Spalten:**
    - `Bahnhof`
    - `Typ` (Abfahrt/Ankunft)
    - `Anzahl_Ausfälle`

---

## 3. Durchschnittliche Verspätung je Zugart

### 3.1 Durchschnittliche Verspätung je Zugart (Gesamtdaten / Bahnhof X)
- **CSV-Datei:** `durchschnitt_verspaetung_je_zugart.csv`
- **Spalten:**
    - `Zugart`
    - `Typ` (Abfahrt/Ankunft)
    - `Bahnhof` (optional)
    - `Durchschnittliche_Verspätung` (Minuten)

---

## 4. Prozentualer Anteil verspäteter Züge je Zugart

### 4.1 Anteil verspäteter Züge mit mehr als X Minuten Verspätung
- **CSV-Datei:** `prozent_verspaetung_je_zugart.csv`
- **Spalten:**
    - `Zugart`
    - `Typ` (Abfahrt/Ankunft)
    - `Verspätungsschwelle` (Minuten)
    - `Bahnhof` (optional)
    - `Prozent_verspäteter_Züge`

---

## 5. Verspätungsverteilung verspäteter Züge

### 5.1 Verspätungsverteilung je Zugart
- **CSV-Datei:** `verteilung_verspaetung_je_zugart.csv`
- **Spalten:**
    - `Zugart`
    - `Typ` (Abfahrt/Ankunft)
    - `Bahnhof` (optional)
    - `Verspätungskategorie` (z. B. <10 Min, <30 Min, <60 Min, <120 Min, >120 Min)
    - `Prozent`

---

## 6. Tageszeitliche Verspätungsanalysen

### 6.1 Durchschnittliche Verspätung je Linie und Bahnhof pro Wochentag
- **CSV-Datei:** `verspaetung_pro_linien_bahnhof_wochentag.csv`
- **Spalten:**
    - `Linie`
    - `Bahnhof`
    - `Wochentag`
    - `Typ` (Abfahrt/Ankunft)
    - `Durchschnittliche_Verspätung` (Minuten)

---

## 7. Wahrscheinlichkeit Flex-Upgrade

### 7.1 Wahrscheinlichkeit Aufhebung Zugindung
- **CSV-Datei:** `wahrscheinlichkeit_aufhebung_zugbindung.csv`
- **Spalten:**
    - `Bahnhof`
    - `Wahrscheinlichkeit` (%)
