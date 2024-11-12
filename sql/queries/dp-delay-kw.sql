WITH verspätungen AS (
    SELECT *
    FROM bahn.dp_superquery
    WHERE dp_superquery.departure_delay > 0
),
station_durchschnitte AS (
    SELECT week_number,
           eva,
           AVG(departure_delay) AS station_durchschnitt
    FROM verspätungen
    GROUP BY week_number, eva
),
aggregated_data AS (
    SELECT week_number AS `Woche`,
           AVG(station_durchschnitt) AS `Gesamt`, -- Keep as numeric for final aggregation
           MAX(CASE WHEN eva = '8000134' THEN station_durchschnitt END) AS `Trier Hbf`,
           MAX(CASE WHEN eva = '8000244' THEN station_durchschnitt END) AS `Mannheim Hbf`,
           MAX(CASE WHEN eva = '8000250' THEN station_durchschnitt END) AS `Wiesbaden Hbf`,
           MAX(CASE WHEN eva = '8000240' THEN station_durchschnitt END) AS `Mainz Hbf`,
           MAX(CASE WHEN eva = '8000105' THEN station_durchschnitt END) AS `FrankfurtHbf`
    FROM station_durchschnitte
    GROUP BY week_number
    ORDER BY week_number
)
SELECT
    `Woche`,
    FORMAT(`Gesamt`, 2, 'de_DE') AS `Gesamt`,
    FORMAT(`Trier Hbf`, 2, 'de_DE') AS `Trier Hbf`,
    FORMAT(`Mannheim Hbf`, 2, 'de_DE') AS `Mannheim Hbf`,
    FORMAT(`Wiesbaden Hbf`, 2, 'de_DE') AS `Wiesbaden Hbf`,
    FORMAT(`Mainz Hbf`, 2, 'de_DE') AS `Mainz Hbf`,
    FORMAT(`FrankfurtHbf`, 2, 'de_DE') AS `FrankfurtHbf`
FROM aggregated_data

UNION ALL

SELECT
    'Testzeitraum' AS `Woche`,
    FORMAT(AVG(`Gesamt`), 2, 'de_DE') AS `Gesamt`,
    FORMAT(AVG(`Trier Hbf`), 2, 'de_DE') AS `Trier Hbf`,
    FORMAT(AVG(`Mannheim Hbf`), 2, 'de_DE') AS `Mannheim Hbf`,
    FORMAT(AVG(`Wiesbaden Hbf`), 2, 'de_DE') AS `Wiesbaden Hbf`,
    FORMAT(AVG(`Mainz Hbf`), 2, 'de_DE') AS `Mainz Hbf`,
    FORMAT(AVG(`FrankfurtHbf`), 2, 'de_DE') AS `FrankfurtHbf`
FROM aggregated_data;
