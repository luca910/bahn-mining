#
# Arrival Superquery
#
WITH superq as (
    WITH filterd AS (SELECT DISTINCT arrivalMessages.timetableStop_id,
                                     eva,
                                     changedArrivalTime,
                                     cancellationTime,
                                     eventStatus
                     FROM arrivalMessages
                              JOIN latest_ar_messages
                                   ON arrivalMessages.timetableStop_id =
                                      latest_ar_messages.timetableStop_id
                                       AND arrivalMessages.timeStamp = max_timestamp
                                       AND fileTimestamp = latest_ar_messages.max_fileTimestamp
                     )
    SELECT filterd.timetableStop_id,
           station,
           eva,
           SUBSTRING_INDEX(plannedArrivalPath, '|', 1)                       AS start,
           plannedArrivalPath,
           trainCategory,
           trainNumber,
           arrivingLine,
           rstops.plannedArrival,
           changedArrivalTime,
           cancellationTime,
           eventStatus,
           TIMESTAMPDIFF(
                   MINUTE,
                   rstops.plannedArrival,
                   COALESCE(changedArrivalTime, rstops.plannedArrival)
           ) AS arrival_delay,

           CASE
               WHEN trainCategory = 'HLB' THEN 'Hessische Landesbahn'
               WHEN trainCategory = 'VIA' THEN 'VIAS GmbH'
               WHEN trainCategory IN ('RB', 'RE', 'BUS', 'N', 'S') THEN 'DB Regio AG'
               WHEN trainCategory IN ('ICE', 'IC') THEN 'DB Fernverkehr AG'
               WHEN trainCategory = 'TGV' THEN 'SNCF'
               WHEN trainCategory = 'NJ' THEN 'ÖBB'
               WHEN trainCategory = 'EC' THEN 'ÖBB'
               WHEN trainCategory = 'RJ' THEN 'ÖBB'
               WHEN trainCategory = 'EN' THEN 'ÖBB'
               WHEN trainCategory = 'R' THEN 'ÖBB'
               WHEN trainCategory = 'ALX' THEN 'Arriva'
               WHEN trainCategory = 'FLX' THEN 'Flixtrain'
               ELSE 'Other'
               END                                                              AS operator,
           CASE
               WHEN arrivingLine REGEXP '^[A-Z]' THEN arrivingLine
               WHEN arrivingLine is null THEN concat(SUBSTRING_INDEX(plannedArrivalPath, '|', 1), '-', station)
               ELSE CONCAT(rstops.trainCategory, arrivingLine)
               END                                                              AS Verbindung,
           WEEK(changedArrivalTime)                                           AS week_number
    FROM filterd
             JOIN rstops
                  ON filterd.timetableStop_id = rstops.timetableStop_id)
select *
from superq