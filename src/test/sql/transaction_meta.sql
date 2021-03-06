-- Copyright 2021 Cloudera, Inc. All Rights Reserved.
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--       http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

USE ${HIVE_DB};
SHOW DATABASES;

SELECT *
FROM
    TXN_TO_WRITE_ID
WHERE
      T2W_DATABASE = 'covid_ga'
  and T2W_TABLE = 'county_cases_archive'
ORDER BY
    T2W_TXNID DESC;



SELECT *
FROM
    COMPACTION_QUEUE;

SELECT *
FROM
    MIN_HISTORY_LEVEL
LIMIT 10;

SELECT *
FROM
    COMPLETED_TXN_COMPONENTS
LIMIT 10;

DELETE
FROM
    MIN_HISTORY_LEVEL
WHERE
    MHL_TXNID = ${DEL_TXNID};

SELECT
    FROM_UNIXTIME(T.TXN_STARTED / 1000) AS 'STARTED',
    T.*
FROM
    TXNS T
LIMIT 10;

DELETE
FROM
    TXNS
WHERE
    TXN_ID = ${DEL_TXNID};

SELECT *
FROM
    TXNS
WHERE
    TXN_ID = ${TXNID};

SELECT DISTINCT
    CTC_DATABASE,
    CTC_TABLE,
    CTC_PARTITION
FROM
    COMPLETED_TXN_COMPONENTS
WHERE
      CTC_DATABASE = '${CTC_DB}'
  and CTC_TABLE = '${CTC_TABLE}'
  and CTC_PARTITION = '${CTC_PARTITION}'
#   and CTC_TABLE = 'county_cases'
ORDER BY
    CTC_TXNID DESC;



SELECT *
FROM
    COMPLETED_TXN_COMPONENTS
ORDER BY
    CTC_TXNID DESC
LIMIT 20;

SELECT *
FROM
    TXNS;
_COMPONENTS;
WHERE
TC_TXNID =
${TXNID};

SELECT *
FROM
    TXNS;

SELECT *
FROM
    COMPLETED_TXN_COMPONENTS
WHERE
    CTC_TXNID = ${TXN_ID};

SELECT *
FROM
    COMPLETED_TXN_COMPONENTS
LIMIT 100;


-- Find if there are TXNS that are open and more than 12 hours old and not heartbeated in last 10 minutes
SELECT
    FROM_UNIXTIME(T.TXN_STARTED / 1000),
    T.*
FROM
    TXNS T
WHERE
      T.TXN_STARTED / 1000 < UNIX_TIMESTAMP() - (86400 / 2)
  and T.TXN_LAST_HEARTBEAT / 1000 < UNIX_TIMESTAMP() - (60 * 10)
;


SELECT UNIX_TIMESTAMP() - UNIX_TIMESTAMP('2020-08-31 17:00:00');

-- Find Completed Txn Components that are probably stuck.
-- These may require and compaction OR (more likely) have been compacted BUT have NOT been cleaned up
-- Meaning the old directories have not been scrubbed after the transaction
SELECT DISTINCT
    CTC_DATABASE,
    CTC_TABLE,
    CTC_PARTITION,
    'STUCK'
FROM
    COMPLETED_TXN_COMPONENTS CTC
WHERE
    CTC_TXNID > ${MIN_HIST_TXN};

-- Min Hist Transaction
SELECT *
FROM
    MIN_HISTORY_LEVEL MHL;

SELECT DISTINCT
    CTC_DATABASE,
    CTC_TABLE,
    CTC_PARTITION
FROM
    COMPLETED_TXN_COMPONENTS CTC
WHERE
      CTC.CTC_TXNID > ${MIN_HIST_TXN}
  and CTC.CTC_TXNID NOT IN (SELECT TXN_ID FROM TXNS WHERE TXN_STARTED / 1000 > (3600 * ${HOURS_OLD}));


SELECT
    M.MHL_TXNID,
    FROM_UNIXTIME(T.TXN_STARTED / 1000)        as TXN_STARTED,
    T.TXN_STATE,
    FROM_UNIXTIME(T.TXN_LAST_HEARTBEAT / 1000) as LAST_HEARTBEAT,
    T.TXN_HEARTBEAT_COUNT,
    T.TXN_TYPE
FROM
    MIN_HISTORY_LEVEL M
        INNER JOIN TXNS T ON M.MHL_TXNID = T.TXN_ID
WHERE
    T.TXN_STARTED / 1000 < UNIX_TIMESTAMP() - (3600 * ${HOURS_OLD});

SELECT *
FROM
    MIN_HISTORY_LEVEL;

SELECT
    CTC_DATABASE,
    CTC_TABLE,
    CTC_PARTITION,
    'STUCK'
FROM
    COMPLETED_TXN_COMPONENTS CTC


SELECT DISTINCT
    CTC_DATABASE,
    CTC_TABLE,
    CTC_PARTITION
FROM
    COMPLETED_TXN_COMPONENTS CTC
        LEFT OUTER JOIN
