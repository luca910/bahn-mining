WITH verspätungen AS (
        SELECT *
        FROM bahn.dp_superquery
        WHERE departure_delay > 0
    ),
    station_durchschnitte AS (
        SELECT
            week_number,
            Verbindung,
            AVG(departure_delay) AS verbindung_durchschnitt
        FROM verspätungen
        GROUP BY week_number, Verbindung
    ),
 aggregated_data AS (   SELECT
        week_number AS `Woche`,
       AVG(verbindung_durchschnitt) AS `Gesamt`,
       MAX(CASE WHEN Verbindung = 'RE1' THEN verbindung_durchschnitt END) AS "RE1",
       MAX(CASE WHEN Verbindung = 'S6' THEN verbindung_durchschnitt END) AS "S6",
       MAX(CASE WHEN Verbindung = 'SE14' THEN verbindung_durchschnitt END) AS "SE14",
    -- terdam Centraal
       MAX(CASE WHEN Verbindung = 'Frankfurt(Main)Hbf-Amsterdam Centraal' THEN verbindung_durchschnitt END) AS "Frankfurt(Main)Hbf-Amsterdam Centraal",
       MAX(CASE WHEN Verbindung like 'Frankfurt(Main)Hbf-Berlin%' THEN verbindung_durchschnitt END) AS "Frankfurt(Main)Hbf-Berlin",
       MAX(CASE WHEN Verbindung like 'Frankfurt(Main)Hbf-Paris%' THEN verbindung_durchschnitt END) AS "Frankfurt(Main)Hbf-Paris",
       MAX(CASE WHEN Verbindung like 'Frankfurt(Main)Hbf-Wien%' THEN verbindung_durchschnitt END) AS "Frankfurt(Main)Hbf-Wien",
       MAX(CASE WHEN Verbindung like 'Mannheim Hbf-München%' THEN verbindung_durchschnitt END) AS "Mannheim Hbf-München",
       MAX(CASE WHEN Verbindung like 'Mannheim Hbf-Hamburg%' THEN verbindung_durchschnitt END) AS "Mannheim Hbf-Hamburg",
       MAX(CASE WHEN Verbindung like 'Wiesbaden Hbf-Basel%' THEN verbindung_durchschnitt END) AS "Wiesbaden Hbf-Basel",
       MAX(CASE WHEN Verbindung like 'Wiesbaden Hbf-Köln%' THEN verbindung_durchschnitt END) AS "Wiesbaden Hbf-Köln"
 FROM station_durchschnitte
    GROUP BY week_number
    ORDER BY week_number)

SELECT
    `Woche`,
    FORMAT(`Gesamt`, 2, 'de_DE') AS `Gesamt`,
    FORMAT(`RE1`, 2, 'de_DE') AS `RE1`,
    FORMAT(`S6`, 2, 'de_DE') AS `S6`,
    FORMAT(`SE14`, 2, 'de_DE') AS `SE14`,
    FORMAT(`Frankfurt(Main)Hbf-Amsterdam Centraal`, 2, 'de_DE') AS `Frankfurt(Main)Hbf-Amsterdam Centraal`,
    FORMAT(`Frankfurt(Main)Hbf-Berlin`, 2, 'de_DE') AS `Frankfurt(Main)Hbf-Berlin`,
    FORMAT(`Frankfurt(Main)Hbf-Paris`, 2, 'de_DE') AS `Frankfurt(Main)Hbf-Paris`,
    FORMAT(`Frankfurt(Main)Hbf-Wien`, 2, 'de_DE') AS `Frankfurt(Main)Hbf-Wien`,
    FORMAT(`Mannheim Hbf-München`, 2, 'de_DE') AS `Mannheim Hbf-München`,
    FORMAT(`Mannheim Hbf-Hamburg`, 2, 'de_DE') AS `Mannheim Hbf-Hamburg`,
    FORMAT(`Wiesbaden Hbf-Basel`, 2, 'de_DE') AS `Wiesbaden Hbf-Basel`,
    FORMAT(`Wiesbaden Hbf-Köln`, 2, 'de_DE') AS `Wiesbaden Hbf-Köln`
FROM aggregated_data
UNION ALL

SELECT
    'Testzeitraum' AS`Woche`,
    FORMAT(AVG(`Gesamt`), 2, 'de_DE') AS `Gesamt`,
    FORMAT(AVG(`RE1`), 2, 'de_DE') AS `RE1`,
    FORMAT(AVG(`S6`), 2, 'de_DE') AS `S6`,
    FORMAT(AVG(`SE14`), 2, 'de_DE') AS `SE14`,
    FORMAT(AVG(`Frankfurt(Main)Hbf-Amsterdam Centraal`), 2, 'de_DE') AS `Frankfurt(Main)Hbf-Amsterdam Centraal`,
    FORMAT(AVG(`Frankfurt(Main)Hbf-Berlin`), 2, 'de_DE') AS `Frankfurt(Main)Hbf-Berlin`,
    FORMAT(AVG(`Frankfurt(Main)Hbf-Paris`), 2, 'de_DE') AS `Frankfurt(Main)Hbf-Paris`,
    FORMAT(AVG(`Frankfurt(Main)Hbf-Wien`), 2, 'de_DE') AS `Frankfurt(Main)Hbf-Wien`,
    FORMAT(AVG(`Mannheim Hbf-München`), 2, 'de_DE') AS `Mannheim Hbf-München`,
    FORMAT(AVG(`Mannheim Hbf-Hamburg`), 2, 'de_DE') AS `Mannheim Hbf-Hamburg`,
    FORMAT(AVG(`Wiesbaden Hbf-Basel`), 2, 'de_DE') AS `Wiesbaden Hbf-Basel`,
    FORMAT(AVG(`Wiesbaden Hbf-Köln`), 2, 'de_DE') AS `Wiesbaden Hbf-Köln`
FROM aggregated_data;