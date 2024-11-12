WITH dp_ausfälle AS (
    SELECT *
    FROM bahn.dp_superquery
    WHERE eventStatus = 'c'
),
dp_verspätungen AS (
    SELECT count(*) as dp_aus_station, week_number, eva
    FROM dp_ausfälle
    WHERE eventStatus = 'c'
    GROUP BY eva, week_number
),
aggregated_data AS (
    SELECT
        week_number AS "Woche",
        SUM(dp_aus_station) AS "Gesamt",
        MAX(CASE WHEN eva = '8000134' THEN dp_aus_station END) AS "Trier Hbf",
        MAX(CASE WHEN eva = '8000244' THEN dp_aus_station END) AS "Mannheim Hbf",
        MAX(CASE WHEN eva = '8000250' THEN dp_aus_station END) AS "Wiesbaden Hbf",
        MAX(CASE WHEN eva = '8000240' THEN dp_aus_station END) AS "Mainz Hbf",
        MAX(CASE WHEN eva = '8000105' THEN dp_aus_station END) AS "FrankfurtHbf"
    FROM dp_verspätungen
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
