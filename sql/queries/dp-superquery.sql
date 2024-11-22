WITH superq AS (WITH filterd AS (SELECT DISTINCT departureMessages.timetableStop_id,
                                                 eva,
                                                 changedDepartureTime,
                                                 cancellationTime,
                                                 eventStatus
                                 FROM departureMessages
                                          JOIN latest_dp_messages
                                               ON departureMessages.timetableStop_id =
                                                  latest_dp_messages.timetableStop_id
                                                   AND departureMessages.timeStamp = max_timestamp
                                                   AND fileTimestamp = latest_dp_messages.max_fileTimestamp
                                 )
                SELECT filterd.timetableStop_id,
                       station,
                       eva,
                       SUBSTRING_INDEX(plannedDeparturePath, '|', -1)                       AS target,
                       trainCategory,
                       trainNumber,
                       departingLine,
                       rstops.plannedDeparture,
                       changedDepartureTime,
                       cancellationTime,
                       eventStatus,
                       TIMESTAMPDIFF(
                           MINUTE,
                               rstops.plannedDeparture,
                               COALESCE(changedDepartureTime, rstops.plannedDeparture)
                       ) AS departure_delay,

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
                           WHEN departingLine REGEXP '^[A-Z]' THEN departingLine
                           WHEN departingLine is null THEN concat(station, '-',
                                                                  SUBSTRING_INDEX(plannedDeparturePath, '|', -1))
                           ELSE CONCAT(rstops.trainCategory, departingLine)
                           END                                                              AS Verbindung,
                       WEEK(changedDepartureTime)                                           AS week_number
                FROM filterd
                         JOIN rstops
                              ON filterd.timetableStop_id = rstops.timetableStop_id)
select *
from superq
HAVING departure_delay >5