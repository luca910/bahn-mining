drop database if exists bahn;
create schema bahn;
use bahn;
create table plannedstops
(
    timetableStop_id         varchar(255)  default null,
    station                  varchar(255)  default null,
    filterFlag               varchar(255)  default null,
    tripType                 varchar(255)  default null,
    owner                    varchar(255)  default null,
    trainCategory            varchar(255)  default null,
    trainNumber              varchar(255)  default null,
    plannedArrival           timestamp  default null,
    plannedArrivalPlatform   varchar(255)  default null,
    arrivingLine             varchar(255)  default null,
    plannedDeparture         timestamp  default null,
    plannedDeparturePlatform varchar(255)  default null,
    departingLine            varchar(255)  default null,
    plannedDeparturePath     varchar(1000) default null,
    plannedArrivalPath       varchar(1000) default null,
    sourceFile               varchar(255) not null
);
create table arrivalMessages
(
    timetableStop_id       varchar(255)  default null,
    station                varchar(255)  default null,
    eva                    varchar(255)  default null,

    changedArrivalPath     varchar(1000) default null,
    plannedArrivalPath     varchar(1000) default null,
    plannedArrivalTime     timestamp  default null,
    changedArrivalTime     timestamp default null,
    plannedArrivalPlatform varchar(255)  default null,
    changedArrivalPlatform varchar(255)  default null,
    arrivalLine            varchar(255)  default null,

    cancellationTime       timestamp default null,
    eventStatus            varchar(255)  default null,

    message_id             varchar(255)  default null,
    messageType            varchar(255)  default null,
    messageCode            varchar(255)  default null,
    timeStamp              varchar(255)  default null,
    fileTimestamp          varchar(255)  default null
);

create table departureMessages
(
    timetableStop_id         varchar(255)  default null,
    station                  varchar(255)  default null,
    eva                      varchar(255)  default null,

    changedDeparturePath     varchar(1000) default null,
    plannedDeparturePath     varchar(1000) default null,
    plannedDepartureTime     timestamp  default null,
    changedDepartureTime     timestamp  default null,
    plannedDeparturePlatform varchar(255)  default null,
    changedDeparturePlatform varchar(255)  default null,
    departureLine            varchar(255)  default null,

    cancellationTime         timestamp default null,
    eventStatus              varchar(255)  default null,

    message_id               varchar(255)  default null,
    messageType              varchar(255)  default null,
    messageCode              varchar(255)  default null,
    timeStamp                varchar(255)  default null,
    fileTimestamp            varchar(255)  default null
);

create table messages
(
    timetableStop_id varchar(255) default null,
    eva              varchar(255) default null,
    station          varchar(255) default null,
    validFrom        varchar(255) default null,
    validUntil       varchar(255) default null,
    priority         varchar(255) default null,
    category         varchar(255) default null,
    message_id       varchar(255) default null,
    messageType      varchar(255) default null,
    messageCode      varchar(255) default null,
    timeStamp        varchar(255) default null,
    fileTimestamp    varchar(255) default null
);
create view rmessages as
select distinct *
from messages;
create view rDepartureMessages as
select distinct *
from bahn.departureMessages;
create view rArrivalMessages as
select distinct *
from arrivalMessages;
create view rStops as
select distinct timetableStop_id,
                station,
                filterFlag,
                tripType,
                owner,
                trainCategory,
                trainNumber,
                plannedArrival,
                plannedArrivalPlatform,
                arrivingLine,
                plannedDeparture,
                plannedDeparturePlatform,
                departingLine,
                plannedDeparturePath,
                plannedArrivalPath
from plannedstops;
create view latest_dp_messages as

SELECT timetableStop_id,
       MAX(timeStamp)     AS max_timestamp,
       MAX(fileTimestamp) as max_fileTimestamp
FROM rdeparturemessages
GROUP BY timetableStop_id;

create view latest_ar_messages as
SELECT timetableStop_id,
       MAX(timeStamp)     AS max_timestamp,
       MAX(fileTimestamp) as max_fileTimestamp
FROM rarrivalmessages
GROUP BY timetableStop_id;

/*select distinct `rdeparturemessages`.`timetableStop_id`     AS `timetableStop_id`,
                `rdeparturemessages`.`station`              AS `station`,
                `rdeparturemessages`.`eva`                  AS `eva`,
                `rdeparturemessages`.`changedDepartureTime` AS `changedDepartureTime`,
                `rdeparturemessages`.`cancellationTime`     AS `cancellationTime`,
                `rdeparturemessages`.`timeStamp`            AS `timeStamp`,
                rdeparturemessages.fileTimestamp            as fileTimestamp
from `bahn`.`rdeparturemessages`
where `rdeparturemessages`.`changedDepartureTime` is not null;*/

#
# Departure Superquery
#

create view dp_superquery as
WITH filterd AS (SELECT DISTINCT departureMessages.timetableStop_id,
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
    TIMESTAMPDIFF(
    MINUTE,
    rstops.plannedDeparture,
    cancellationTime
    ) AS cancellation_delay,

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
       WEEK(plannedDeparture)                                           AS week_number
FROM filterd
         JOIN rstops
              ON filterd.timetableStop_id = rstops.timetableStop_id;




#
# Arrival Superquery
#
create view ar_superquery as
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
       TIMESTAMPDIFF(
               MINUTE,
               rstops.plannedDeparture,
               cancellationTime
       ) AS cancellation_delay,

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
       WEEK(plannedArrival)                                           AS week_number
FROM filterd
         JOIN rstops
              ON filterd.timetableStop_id = rstops.timetableStop_id;