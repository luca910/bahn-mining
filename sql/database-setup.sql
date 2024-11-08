drop
database if exists bahn;
create schema bahn;
use
bahn;
create table plannedstops
(
    timetableStop_id         varchar(255)  default null,
    station                  varchar(255)  default null,
    filterFlag               varchar(255)  default null,
    tripType                 varchar(255)  default null,
    owner                    varchar(255)  default null,
    trainCategory            varchar(255)  default null,
    trainNumber              varchar(255)  default null,
    plannedArrival           varchar(255)  default null,
    plannedArrivalPlatform   varchar(255)  default null,
    arrivingLine             varchar(255)  default null,
    plannedDeparture         varchar(255)  default null,
    plannedDeparturePlatform varchar(255)  default null,
    departingLine            varchar(255)  default null,
    plannedDeparturePath     varchar(1000) default null,
    plannedArrivalPath       varchar(1000) default null,
    sourceFile               varchar(255) not null
);
create table arrivalMessages
(
    timetableStop_id       varchar(255)  default null,
    station                  varchar(255)  default null,
    eva                    varchar(255)  default null,

    changedArrivalPath     varchar(1000) default null,
    plannedArrivalPath     varchar(1000) default null,
    plannedArrivalTime     varchar(255)  default null,
    changedArrivalTime     varchar(255)  default null,
    plannedArrivalPlatform varchar(255)  default null,
    changedArrivalPlatform varchar(255)  default null,
    arrivalLine            varchar(255)  default null,

    cancellationTime       varchar(255)  default null,
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
    plannedDepartureTime     varchar(255)  default null,
    changedDepartureTime     varchar(255)  default null,
    plannedDeparturePlatform varchar(255)  default null,
    changedDeparturePlatform varchar(255)  default null,
    departureLine            varchar(255)  default null,

    cancellationTime       varchar(255)  default null,
    eventStatus            varchar(255)  default null,

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
    station                  varchar(255)  default null,
    validFrom        varchar(255) default null,
    validUntil       varchar(255) default null,
    priority         varchar(255) default null,
    category         varchar(255) default null,
    message_id               varchar(255)  default null,
    messageType              varchar(255)  default null,
    messageCode              varchar(255)  default null,
    timeStamp                varchar(255)  default null,
    fileTimestamp            varchar(255)  default null
);
create view rmessages as
      select distinct * from messages;
create view rDepartureMessages as
      select distinct * from bahn.departureMessages;
create view rArrivalMessages as
select distinct * from arrivalMessages;
create view rStops as
select distinct timetableStop_id, station, filterFlag, tripType, owner, trainCategory, trainNumber, plannedArrival, plannedArrivalPlatform, arrivingLine, plannedDeparture, plannedDeparturePlatform, departingLine, plannedDeparturePath, plannedArrivalPath from plannedstops;
create view latest_dp_messages as

SELECT
            timetableStop_id,
            MAX(timeStamp) AS max_timestamp,
            MAX(fileTimestamp) as max_fileTimestamp
        FROM
            rdeparturemessages
        GROUP BY
            timetableStop_id;
select distinct `rdeparturemessages`.`timetableStop_id`     AS `timetableStop_id`,
                `rdeparturemessages`.`station`              AS `station`,
                `rdeparturemessages`.`eva`                  AS `eva`,
                `rdeparturemessages`.`changedDepartureTime` AS `changedDepartureTime`,
                `rdeparturemessages`.`cancellationTime`     AS `cancellationTime`,
                `rdeparturemessages`.`timeStamp`            AS `timeStamp`,
                rdeparturemessages.fileTimestamp as fileTimestamp
from `bahn`.`rdeparturemessages`
where `rdeparturemessages`.`changedDepartureTime` is not null