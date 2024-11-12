WITH verspätungen AS (
    SELECT *
    FROM bahn.ar_superquery
   WHERE arrival_delay > 0
),
station_durchschnitte AS (
    SELECT
        week_number,
        eva,
        AVG(arrival_delay) AS station_durchschnitt
    FROM verspätungen
    GROUP BY week_number, eva
)
SELECT
    week_number AS "Woche",
    FORMAT(AVG(station_durchschnitt), 2, 'de_DE') AS "Gesamt", -- Gesamt-Durchschnitt über alle Stationen
    FORMAT(MAX(CASE WHEN eva = '8000134' THEN station_durchschnitt END), 2, 'de_DE') AS "Trier Hbf",
    FORMAT(MAX(CASE WHEN eva = '8000244' THEN station_durchschnitt END), 2, 'de_DE') AS "Mannheim Hbf",
    FORMAT(MAX(CASE WHEN eva = '8000250' THEN station_durchschnitt END), 2, 'de_DE') AS "Wiesbaden Hbf",
    FORMAT(MAX(CASE WHEN eva = '8000240' THEN station_durchschnitt END), 2, 'de_DE') AS "Mainz Hbf",
    FORMAT(MAX(CASE WHEN eva = '8000105' THEN station_durchschnitt END), 2, 'de_DE') AS "FrankfurtHbf"
FROM station_durchschnitte
GROUP BY week_number
ORDER BY week_number;
