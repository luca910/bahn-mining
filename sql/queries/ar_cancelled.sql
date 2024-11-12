WITH ar_ausfälle AS (
    SELECT *
    FROM bahn.ar_superquery
    WHERE eventStatus = 'c'
),
ar_verspätungen AS (
    SELECT count(*) as ar_aus_station, week_number, eva
    FROM ar_ausfälle
    WHERE eventStatus = 'c'
    GROUP BY eva, week_number
),
aggregated_data AS (
    SELECT
        week_number AS "Woche",
        SUM(ar_aus_station) AS "Gesamt",
        MAX(CASE WHEN eva = '8000134' THEN ar_aus_station END) AS "Trier Hbf",
        MAX(CASE WHEN eva = '8000244' THEN ar_aus_station END) AS "Mannheim Hbf",
        MAX(CASE WHEN eva = '8000250' THEN ar_aus_station END) AS "Wiesbaden Hbf",
        MAX(CASE WHEN eva = '8000240' THEN ar_aus_station END) AS "Mainz Hbf",
        MAX(CASE WHEN eva = '8000105' THEN ar_aus_station END) AS "FrankfurtHbf"
    FROM ar_verspätungen
    GROUP BY week_number
)
SELECT * FROM aggregated_data

UNION ALL

SELECT
    'Total' AS "Woche",
    SUM(`Gesamt`) AS `Gesamt`,
    SUM(`Trier Hbf`) AS `Trier Hbf`,
    SUM(`Mannheim Hbf`) AS `Mannheim Hbf`,
    SUM(`Wiesbaden Hbf`) AS `Wiesbaden Hbf`,
    SUM(`Mainz Hbf`) AS `Mainz Hbf`,
    SUM(`FrankfurtHbf`) AS `FrankfurtHbf`
FROM aggregated_data;
