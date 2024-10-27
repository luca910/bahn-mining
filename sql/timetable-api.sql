/* SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO"; */
/* SET AUTOCOMMIT = 0; */
/* START TRANSACTION; */
/* SET time_zone = "+00:00"; */

-- --------------------------------------------------------

--
-- Table structure for table `connection` generated from model 'connection'
-- It&#39;s information about a connected train at a particular stop.
--
drop database bahn;
create database bahn;
use bahn;

--
-- Table structure for table `event` generated from model 'event'
-- An event (arrival or departure) that is part of a stop.
--

CREATE TABLE IF NOT EXISTS `event`
(
    `event_id`         INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Eindeutige ID für jedes Ereignis',
    `timetableStop_id` VARCHAR(50) COMMENT 'Eindeutige ID für jedes Ereignis',
    `event_type`       VARCHAR(50) DEFAULT NULL COMMENT 'Event type. Arrival or departure.',
    `cde`    TEXT DEFAULT NULL COMMENT 'Changed distant endpoint.',
    `clt`    TEXT DEFAULT NULL COMMENT 'Cancellation time. Time when the cancellation of this stop was created. The time, in ten digit &#39;YYMMddHHmm&#39; format, e.g. &#39;1404011437&#39; for 14:37 on April the 1st of 2014.',
    `cp`     TEXT DEFAULT NULL COMMENT 'Changed platform.',
    `cpth`   TEXT DEFAULT NULL COMMENT 'Changed path.',
    `cs`     TEXT DEFAULT NULL,
    `ct`     TEXT DEFAULT NULL COMMENT 'Changed time. New estimated or actual departure or arrival time. The time, in ten digit &#39;YYMMddHHmm&#39; format, e.g. &#39;1404011437&#39; for 14:37 on April the 1st of 2014.',
    `dc`     INT  DEFAULT NULL COMMENT 'Distant change.',
    `hi`     INT  DEFAULT NULL COMMENT 'Hidden. 1 if the event should not be shown on WBT because travellers are not supposed to enter or exit the train at this stop.',
    `l`      TEXT DEFAULT NULL COMMENT 'Line. The line indicator (e.g. \&quot;3\&quot; for an S-Bahn or \&quot;45S\&quot; for a bus).',
    `m`      VARCHAR(50) DEFAULT NULL COMMENT 'List of messages.',
    `pde`    TEXT DEFAULT NULL COMMENT 'Planned distant endpoint.',
    `pp`     TEXT DEFAULT NULL COMMENT 'Planned platform.',
    `ppth`   TEXT DEFAULT NULL COMMENT 'Planned Path. A sequence of station names separated by the pipe symbols (&#39;|&#39;). E.g.: &#39;Mainz Hbf|R�sselsheim|Frankfrt(M) Flughafen&#39;. For arrival, the path indicates the stations that come before the current station. The first element then is the trip&#39;s start station. For departure, the path indicates the stations that come after the current station. The last element in the path then is the trip&#39;s destination station. Note that the current station is never included in the path (neither for arrival nor for departure). ',
    `ps`     TEXT DEFAULT NULL,
    `pt`     TEXT DEFAULT NULL COMMENT 'Planned time. Planned departure or arrival time. The time, in ten digit &#39;YYMMddHHmm&#39; format, e.g. &#39;1404011437&#39; for 14:37 on April the 1st of 2014.',
    `tra`    TEXT DEFAULT NULL COMMENT 'Transition. Trip id of the next or previous train of a shared train. At the start stop this references the previous trip, at the last stop it references the next trip. E.g. &#39;2016448009055686515-1403311438-1&#39;',
    `wings`  TEXT DEFAULT NULL COMMENT 'Wing. A sequence of trip id separated by the pipe symbols (&#39;|&#39;). E.g. &#39;-906407760000782942-1403311431&#39;.'
    -- FOREIGN KEY (m) REFERENCES bahn.message (id)
    ) ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_unicode_ci COMMENT ='An event (arrival or departure) that is part of a stop.';

--
-- Table structure for table `timetableStop` generated from model 'timetableStop'
-- A stop is a part of a Timetable.
--

CREATE TABLE IF NOT EXISTS `timetableStop`
(
    `ar`   VARCHAR(50)                DEFAULT NULL COMMENT 'Event ID of the arrival event.',
    `conn` JSON               DEFAULT NULL COMMENT 'Connection element.',
    `dp`   VARCHAR(50)                DEFAULT NULL COMMENT 'Event ID of the departure event.',
    `eva`  BIGINT  COMMENT 'The eva code of the station of this stop. Example &#39;8000105&#39; for Frankfurt(Main)Hbf.',
    `hd`   JSON               DEFAULT NULL COMMENT 'Historic delay element.',
    `hpc`  JSON               DEFAULT NULL COMMENT 'Historic platform change element.',
    `id`   VARCHAR(50) DEFAULT NULL COMMENT 'An id that uniquely identifies the stop. It consists of the following three elements separated by dashes * a &#39;daily trip id&#39; that uniquely identifies a trip within one day. This id is typically reused on subsequent days. This could be negative. * a 6-digit date specifier (YYMMdd) that indicates the planned departure date of the trip from its start station. * an index that indicates the position of the stop within the trip (in rare cases, one trip may arrive multiple times at one station). Added trips get indices above 100. Example &#39;-7874571842864554321-1403311221-11&#39; would be used for a trip with daily trip id &#39;-7874571842864554321&#39; that starts on march the 31th 2014 and where the current station is the 11th stop. ',
    `m`    JSON               DEFAULT NULL COMMENT 'Message element.',
    `ref`  TEXT               DEFAULT NULL,
    `rtr`  JSON               DEFAULT NULL COMMENT 'Reference trip relation element.',
    `tl`   TEXT               DEFAULT NULL
--    PRIMARY KEY (id(50))
    ) ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_unicode_ci COMMENT ='A stop is a part of a Timetable.';

--
-- Table structure for table `distributorMessage` generated from model 'distributorMessage'
-- An additional message to a given station-based disruption by a specific distributor.
--

CREATE TABLE IF NOT EXISTS `distributorMessage`
(
    `distributorMessage_id`    INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Eindeutige ID für jede Nachricht',
    `int` TEXT DEFAULT NULL COMMENT 'Internal text.',
    `n`   TEXT DEFAULT NULL COMMENT 'Distributor name.',
    `t`   TEXT DEFAULT NULL,
    `ts`  TEXT DEFAULT NULL COMMENT 'Timestamp. The time, in ten digit &#39;YYMMddHHmm&#39; format, e.g. &#39;1404011437&#39; for 14:37 on April the 1st of 2014.'
) ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_unicode_ci COMMENT ='An additional message to a given station-based disruption by a specific distributor.';


--
-- Table structure for table `message` generated from model 'message'
-- A message that is associated with an event, a stop or a trip.
--

CREATE TABLE IF NOT EXISTS `message`
(
    `timetableStop_id` VARCHAR(50),
    `event_id`         INT DEFAULT NULL,
    `c`    INT  DEFAULT NULL COMMENT 'Code.',
    `cat`  TEXT DEFAULT NULL COMMENT 'Category.',
    `del`  INT  DEFAULT NULL COMMENT 'Deleted.',
    `dm`   INT DEFAULT NULL COMMENT 'Distributor message.',
    `ec`   TEXT DEFAULT NULL COMMENT 'External category.',
    `elnk` TEXT DEFAULT NULL COMMENT 'External link associated with the message.',
    `ext`  TEXT DEFAULT NULL COMMENT 'External text.',
    `from` TEXT DEFAULT NULL COMMENT 'Valid from. The time, in ten digit &#39;YYMMddHHmm&#39; format, e.g. &#39;1404011437&#39; for 14:37 on April the 1st of 2014.',
    `id`   VARCHAR(50) DEFAULT NULL COMMENT 'Message id.',
    `int`  TEXT DEFAULT NULL COMMENT 'Internal text.',
    `o`    TEXT DEFAULT NULL COMMENT 'Owner.',
    `pr`   TEXT DEFAULT NULL,
    `t`    TEXT               DEFAULT NULL,
    `tl`   VARCHAR(50) DEFAULT NULL COMMENT 'Trip label.',
    `to`   TEXT DEFAULT NULL COMMENT 'Valid to. The time, in ten digit &#39;YYMMddHHmm&#39; format, e.g. &#39;1404011437&#39; for 14:37 on April the 1st of 2014.',
    `ts`   TEXT               DEFAULT NULL COMMENT 'Timestamp. The time, in ten digit &#39;YYMMddHHmm&#39; format, e.g. \&quot;1404011437\&quot; for 14:37 on April the 1st of 2014.'
    -- PRIMARY KEY (id(50))
    -- foreign key (dm) references distributorMessage(distributorMessage_id),
    --  foreign key (tl) references timetableStop(id)
    ) ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_unicode_ci COMMENT ='A message that is associated with an event, a stop or a trip.';


CREATE TABLE IF NOT EXISTS `connection`
(
    `cs`  TEXT NOT NULL,
    `eva` BIGINT DEFAULT NULL COMMENT 'EVA station number.',
    `id`  VARCHAR(50) PRIMARY KEY NOT NULL COMMENT 'Id.',
    `ref` TEXT   DEFAULT NULL,
    `s`   TEXT NOT NULL,
    `ts`  TEXT NOT NULL COMMENT 'Time stamp. The time, in ten digit &#39;YYMMddHHmm&#39; format, e.g. &#39;1404011437&#39; for 14:37 on April the 1st of 2014.'
    ) ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_unicode_ci COMMENT ='It&#39;s information about a connected train at a particular stop.';





--
-- Table structure for table `historicDelay` generated from model 'historicDelay'
-- It&#39;s the history of all delay-messages for a stop. This element extends HistoricChange.
--

CREATE TABLE IF NOT EXISTS `historicDelay`
(
    `ar`  TEXT DEFAULT NULL COMMENT 'The arrival event. The time, in ten digit &#39;YYMMddHHmm&#39; format, e.g. &#39;1404011437&#39; for 14:37 on April the 1st of 2014.',
    `cod` TEXT DEFAULT NULL COMMENT 'Detailed description of delay cause.',
    `dp`  TEXT DEFAULT NULL COMMENT 'The departure event. The time, in ten digit &#39;YYMMddHHmm&#39; format, e.g. &#39;1404011437&#39; for 14:37 on April the 1st of 2014.',
    `src` TEXT DEFAULT NULL,
    `ts`  TEXT DEFAULT NULL COMMENT 'Timestamp. The time, in ten digit &#39;YYMMddHHmm&#39; format, e.g. &#39;1404011437&#39; for 14:37 on April the 1st of 2014.'
) ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_unicode_ci COMMENT ='It&#39;s the history of all delay-messages for a stop. This element extends HistoricChange.';

--
-- Table structure for table `historicPlatformChange` generated from model 'historicPlatformChange'
-- It&#39;s the history of all platform-changes for a stop. This element extends HistoricChange.
--

CREATE TABLE IF NOT EXISTS `historicPlatformChange`
(
    `ar`  TEXT DEFAULT NULL COMMENT 'Arrival platform.',
    `cot` TEXT DEFAULT NULL COMMENT 'Detailed cause of track change.',
    `dp`  TEXT DEFAULT NULL COMMENT 'Departure platform.',
    `ts`  TEXT DEFAULT NULL COMMENT 'Timestamp. The time, in ten digit &#39;YYMMddHHmm&#39; format, e.g. &#39;1404011437&#39; for 14:37 on April the 1st of 2014.'
) ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_unicode_ci COMMENT ='It&#39;s the history of all platform-changes for a stop. This element extends HistoricChange.';



--
-- Table structure for table `multipleStationData` generated from model 'multipleStationData'
-- A wrapper that represents multiple StationData objects.
--

CREATE TABLE IF NOT EXISTS `multipleStationData`
(
    `station` JSON NOT NULL COMMENT 'List of stations with additional data.'
) ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_unicode_ci COMMENT ='A wrapper that represents multiple StationData objects.';

--
-- Table structure for table `referenceTrip` generated from model 'referenceTrip'
-- A reference trip is another real trip, but it doesn&#39;t have its own stops and events. It refers only to its ref-erenced regular trip. The reference trip collects mainly all different attributes of the referenced regular trip.
--

CREATE TABLE IF NOT EXISTS `referenceTrip`
(
    `c`   TINYINT(1) NOT NULL COMMENT 'The cancellation flag. True means, the reference trip is cancelled.',
    `ea`  TEXT       NOT NULL,
    `id`  TEXT       NOT NULL COMMENT 'An id that uniquely identifies the reference trip. It consists of the following two elements separated by dashes:  * A &#39;daily trip id&#39; that uniquely identifies a reference trip within one day. This id is typically reused on subsequent days. This could be negative. * A 10-digit date specifier (YYMMddHHmm) that indicates the planned departure date of the referenced regular trip from its start station.  Example:  &#39;-7874571842864554321-1403311221&#39; would be used for a trip with daily trip id &#39;-7874571842864554321&#39; that starts on march the 31th 2014. ',
    `rtl` TEXT       NOT NULL,
    `sd`  TEXT       NOT NULL
    ) ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_unicode_ci COMMENT ='A reference trip is another real trip, but it doesn&#39;t have its own stops and events. It refers only to its ref-erenced regular trip. The reference trip collects mainly all different attributes of the referenced regular trip.';

--
-- Table structure for table `referenceTripLabel` generated from model 'referenceTripLabel'
-- It&#39;s a compound data type that contains common data items that characterize a reference trip. The con-tents is represented as a compact 3-tuple in XML.
--

CREATE TABLE IF NOT EXISTS `referenceTripLabel`
(
    `c` TEXT NOT NULL COMMENT 'Category. Trip category, e.g. \&quot;ICE\&quot; or \&quot;RE\&quot;.',
    `n` TEXT NOT NULL COMMENT 'Trip/train number, e.g. \&quot;4523\&quot;.'
) ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_unicode_ci COMMENT ='It&#39;s a compound data type that contains common data items that characterize a reference trip. The con-tents is represented as a compact 3-tuple in XML.';

--
-- Table structure for table `referenceTripRelation` generated from model 'referenceTripRelation'
-- A reference trip relation holds how a reference trip is related to a stop, for instance the reference trip starts after the stop. Stop contains a collection of that type, only if reference trips are available.
--

CREATE TABLE IF NOT EXISTS `referenceTripRelation`
(
    `rt`  TEXT NOT NULL,
    `rts` TEXT NOT NULL
) ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_unicode_ci COMMENT ='A reference trip relation holds how a reference trip is related to a stop, for instance the reference trip starts after the stop. Stop contains a collection of that type, only if reference trips are available.';

--
-- Table structure for table `referenceTripStopLabel` generated from model 'referenceTripStopLabel'
-- It&#39;s a compound data type that contains common data items that characterize a reference trip stop. The contents is represented as a compact 4-tuple in XML.
--

CREATE TABLE IF NOT EXISTS `referenceTripStopLabel`
(
    `eva` BIGINT NOT NULL COMMENT 'The eva number of the correspondent stop of the regular trip.',
    `i`   INT    NOT NULL COMMENT 'The index of the correspondent stop of the regu-lar trip.',
    `n`   TEXT   NOT NULL COMMENT 'The (long) name of the correspondent stop of the regular trip.',
    `pt`  TEXT   NOT NULL COMMENT 'The planned time of the correspondent stop of the regular trip.'
) ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_unicode_ci COMMENT ='It&#39;s a compound data type that contains common data items that characterize a reference trip stop. The contents is represented as a compact 4-tuple in XML.';

--
-- Table structure for table `stationData` generated from model 'stationData'
-- A transport object which keep data for a station.
--

CREATE TABLE IF NOT EXISTS `stationData`
(
    `ds100` TEXT   NOT NULL COMMENT 'DS100 station code.',
    `eva`   BIGINT NOT NULL COMMENT 'EVA station number.',
    `meta`  TEXT DEFAULT NULL COMMENT 'List of meta stations. A sequence of station names separated by the pipe symbols (\&quot;|\&quot;).',
    `name`  TEXT   NOT NULL COMMENT 'Station name.',
    `p`     TEXT DEFAULT NULL COMMENT 'List of platforms. A sequence of platforms separated by the pipe symbols (\&quot;|\&quot;).'
) ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_unicode_ci COMMENT ='A transport object which keep data for a station.';



--
-- Table structure for table `timetable` generated from model 'timetable'
-- A timetable is made of a set of TimetableStops and a potential Disruption.
--

CREATE TABLE IF NOT EXISTS `timetable`
(
    `eva`     BIGINT      DEFAULT NULL COMMENT 'EVA station number.',
    `m`       VARCHAR(50) DEFAULT NULL COMMENT 'List of Message.',
    `s`       VARCHAR(50) DEFAULT NULL COMMENT 'List of TimetableStop.',
    `station` TEXT        DEFAULT NULL COMMENT 'Station name.'
    -- FOREIGN KEY (s) REFERENCES bahn.timetableStop (id),
    -- FOREIGN KEY (m) REFERENCES bahn.message (id)
    ) ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_unicode_ci COMMENT ='A timetable is made of a set of TimetableStops and a potential Disruption.';




--
-- Table structure for table `tripReference` generated from model 'tripReference'
-- It&#39;s a reference to another trip, which holds its label and reference trips, if available.
--

CREATE TABLE IF NOT EXISTS `tripReference`
(
    `rt` JSON DEFAULT NULL COMMENT 'The referred trips reference trip elements.',
    `tl` TEXT NOT NULL
) ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_unicode_ci COMMENT ='It&#39;s a reference to another trip, which holds its label and reference trips, if available.';

--
-- Table structure for table `tripLabel` generated from model 'tripLabel'
-- It&#39;s a compound data type that contains common data items that characterize a Trip. The contents is represented as a compact 6-tuple in XML.
--

CREATE TABLE IF NOT EXISTS `tripLabel`
(
    `timetableStop_id` VARCHAR(50) COMMENT 'Eindeutige ID für jede Trip-Bezeichnung',
    `c` TEXT NOT NULL COMMENT 'Category. Trip category, e.g. \&quot;ICE\&quot; or \&quot;RE\&quot;.',
    `f` TEXT DEFAULT NULL COMMENT 'Filter flags.',
    `n` TEXT NOT NULL COMMENT 'Trip/train number, e.g. \&quot;4523\&quot;.',
    `o` TEXT NOT NULL COMMENT 'Owner. A unique short-form and only intended to map a trip to specific evu.',
    `t` TEXT DEFAULT NULL
    -- FOREIGN KEY (timetableStop_id) REFERENCES timetableStop(id)
    ) ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_unicode_ci COMMENT ='It&#39;s a compound data type that contains common data items that characterize a Trip. The contents is represented as a compact 6-tuple in XML.';
