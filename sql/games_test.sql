DROP TABLE IF EXISTS central_insights_sandbox.mc_collections_data_18;
CREATE TABLE central_insights_sandbox.mc_collections_data_18 AS (
-- with cont AS (
    SELECT
      ns_vid,
      cal_yyyymmdd,
      name,
      MIN(ns_utc) AS first_game_play
    FROM s3_audience.comscore
    WHERE (dt BETWEEN '20180601' AND '20180631')
          AND name LIKE 'cbbc.games%'
    GROUP BY ns_vid, cal_yyyymmdd, name
);
SELECT COUNT(*) FROM central_insights_sandbox.mc_collections_data_18
WHERE name NOT LIKE '%keepalive%'; -- 2452853
SELECT COUNT(*) FROM central_insights_sandbox.mc_collections_data_18
WHERE name NOT LIKE '%keepalive%'
  AND name IN ('cbbc.games.operation_ouch_clonewards_game.page', 'cbbc.games.operation_ouch_the_snot_apocalypse.page'); -- 119216

SELECT * FROM s3_audience.comscore
  WHERE (dt BETWEEN '20180601' AND '20180601')
--     AND name LIKE '%operation_ouch_clonewards_game%'
  AND ns_jspageurl LIKE '%collection%'
  AND name LIKE 'cbbc.games%'
LIMIT 1000;


SELECT
  name,
  COUNT(ns_vid) AS freq
FROM central_insights_sandbox.mc_collections_data_18
  WHERE name LIKE '%snot%'
GROUP BY name
ORDER BY freq DESC;

-- cbbc.games.operation_ouch_clonewards_game.page
-- cbbc.games.operation_ouch_the_snot_apocalypse.page
--

-- 'cbbc.games.operation_ouch_clonewards_game.page'
DROP TABLE IF EXISTS central_insights_sandbox.mc_collections_data_18_onwards;
CREATE TABLE central_insights_sandbox.mc_collections_data_18_onwards AS (
  WITH sess AS (
      SELECT
        CAST(ns_vid AS TEXT) + '-' + cal_yyyymmdd AS session_id,
        MIN(first_game_play)                      AS start_of_session
      FROM central_insights_sandbox.mc_collections_data_18
      WHERE
        name IN ('cbbc.games.operation_ouch_clonewards_game.page', 'cbbc.games.operation_ouch_the_snot_apocalypse.page')
      GROUP BY ns_vid, cal_yyyymmdd
  )
  SELECT
    a.session_id,
    COUNT(DISTINCT b.name)
  FROM sess AS a
    LEFT JOIN
    (SELECT
       CAST(ns_vid AS TEXT) + '-' + cal_yyyymmdd AS session_id,
       name,
       first_game_play
     FROM central_insights_sandbox.mc_collections_data_18
     WHERE name NOT LIKE 'keepalive%') AS b
      ON a.session_id = b.session_id AND b.first_game_play > a.start_of_session
  GROUP BY a.session_id
)
;

SELECT * FROM central_insights_sandbox.mc_collections_data_18_onwards;
SELECT AVG(count) FROM central_insights_sandbox.mc_collections_data_18_onwards
WHERE count > 0; -- 2

SELECT sum(count) FROM central_insights_sandbox.mc_collections_data_18_onwards; -- 146013
SELECT COUNT(*) FROM central_insights_sandbox.mc_collections_data_18_onwards; -- 110648
SELECT CAST(sum(count) AS numeric)/COUNT(*) FROM central_insights_sandbox.mc_collections_data_18_onwards; -- 1.3196

SELECT sum(count) FROM central_insights_sandbox.mc_collections_data_18_onwards WHERE count > 0; -- 146013
SELECT COUNT(*) FROM central_insights_sandbox.mc_collections_data_18_onwards WHERE count > 0; -- 53019
SELECT CAST(sum(count) AS numeric)/COUNT(*) FROM central_insights_sandbox.mc_collections_data_18_onwards WHERE count > 0; -- 2.75397499009788943586


-- DROP TABLE IF EXISTS central_insights_sandbox.mc_collections_data_sep18;
-- CREATE TABLE central_insights_sandbox.mc_collections_data_sep18 AS (
-- with cont AS (
--     SELECT
--       ns_vid,
--       cal_yyyymmdd,
--       name,
--       MIN(ns_utc) AS first_game_play
--     FROM s3_audience.comscore
--     WHERE (dt BETWEEN '20180901' AND '20180931')
--           AND name LIKE '%cbbc.games%'
--     GROUP BY ns_vid, cal_yyyymmdd, name
-- )
-- SELECT
--   ns_vid,
--   cal_yyyymmdd,
--   COUNT(name)
-- FROM cont
-- GROUP BY ns_vid, cal_yyyymmdd);


DROP TABLE IF EXISTS central_insights_sandbox.mc_collections_data_19;
CREATE TABLE central_insights_sandbox.mc_collections_data_19 AS (
-- with cont AS (
    SELECT
      unique_visitor_cookie_id                 AS ns_vid,
      SPLIT_PART(visit_start_datetime, 'T', 1) AS cal_yyyymmdd,
      page_name                                AS name,
      MIN(SPLIT_PART(visit_start_datetime, 'T', 2)) AS first_game_play
    FROM s3_audience.Audience_activity
    WHERE (dt BETWEEN '20190601' AND '20190631')
          AND page_name LIKE '%cbbc.games%'
      AND name NOT LIKE 'keepalive%'
    GROUP BY ns_vid, cal_yyyymmdd, name
);
SELECT COUNT(*) FROM central_insights_sandbox.mc_collections_data_19
WHERE name NOT LIKE '%keepalive%'; -- 2452853/2730128
SELECT COUNT(*) FROM central_insights_sandbox.mc_collections_data_19
WHERE name NOT LIKE '%keepalive%'
  AND (name LIKE '%operation ouch clonewards game%'
   OR NAME LIKE '%operation ouch the snot apocalypse%'); -- 119216/187988

DROP TABLE IF EXISTS central_insights_sandbox.mc_collections_data_19_onwards;
CREATE TABLE central_insights_sandbox.mc_collections_data_19_onwards AS (
  WITH sess AS (
      SELECT
        CAST(ns_vid AS TEXT) + '-' + cal_yyyymmdd AS session_id,
        MIN(first_game_play) AS start_of_session
      FROM central_insights_sandbox.mc_collections_data_19
      WHERE
        name LIKE '%operation ouch clonewards game%'
          OR name LIKE '%operation ouch the snot apocalypse%'
      GROUP BY ns_vid, cal_yyyymmdd
  )
  SELECT
    a.session_id,
    COUNT(DISTINCT b.name)
  FROM sess AS a
    LEFT JOIN
    (SELECT
       CAST(ns_vid AS TEXT) + '-' + cal_yyyymmdd AS session_id,
       name,
       first_game_play
     FROM central_insights_sandbox.mc_collections_data_19
    WHERE name NOT LIKE 'keepalive%') AS b
    ON a.session_id = b.session_id AND b.first_game_play > a.start_of_session
  GROUP BY a.session_id
)
;
SELECT AVG(count) FROM central_insights_sandbox.mc_collections_data_19_onwards
WHERE count > 0; -- 3

SELECT sum(count) FROM central_insights_sandbox.mc_collections_data_19_onwards; -- 26807
SELECT COUNT(*) FROM central_insights_sandbox.mc_collections_data_19_onwards; -- 88964
SELECT CAST(sum(count) AS numeric)/COUNT(*) FROM central_insights_sandbox.mc_collections_data_19_onwards; -- 0.3

SELECT sum(count) FROM central_insights_sandbox.mc_collections_data_19_onwards WHERE count > 0; -- 26807
SELECT COUNT(*) FROM central_insights_sandbox.mc_collections_data_19_onwards WHERE count > 0; -- 7199
SELECT CAST(sum(count) AS numeric)/COUNT(*) FROM central_insights_sandbox.mc_collections_data_19_onwards WHERE count > 0; -- 3.72371162661480761216

with sessionised AS (
  SELECT
    CAST(ns_vid AS TEXT) + '-' + cal_yyyymmdd AS session_id,
    name
  FROM central_insights_sandbox.mc_collections_data_19_onwards
)
SELECT
    session_id,
    COUNT(DISTINCT name)
  FROM sessionised
  GROUP BY session_id;

SELECT
  CAST(a.ns_vid AS TEXT) + '-' +a.cal_yyyymmdd as session_id,
  COUNT(DISTINCT name)
FROM (
    (SELECT
       ns_vid,
       cal_yyyymmdd,
       MIN(first_game_play) AS start_of_session
     FROM central_insights_sandbox.mc_collections_data_19
     WHERE
       name LIKE '%operation ouch clonewards game%'
       OR name LIKE '%operation ouch the snot apocalypse%'
     GROUP BY ns_vid, cal_yyyymmdd) AS a
    LEFT JOIN
    (SELECT
       ns_vid,
       cal_yyyymmdd,
       name,
       first_game_play
     FROM central_insights_sandbox.mc_collections_data_19
    ) AS b
    ON a.ns_vid = b.ns_vid AND a.cal_yyyymmdd = b.cal_yyyymmdd AND b.first_game_play > a.start_of_session
)
  WHERE name NOT LIKE 'keepalive%'
GROUP BY session_id;











-- SELECT
--   ns_vid,
--   cal_yyyymmdd,
--   COUNT(name)
-- FROM cont
-- GROUP BY ns_vid, cal_yyyymmdd);
SELECT *
FROM s3_audience.Audience_activity
    WHERE (dt BETWEEN '20190601' AND '20190601')
          AND destination = 'PS_CBBC'
          AND page_name LIKE '%cbbc.games%'
LIMIT 10;

SELECT SUM(COUNT) FROM central_insights_sandbox.mc_collections_data_18
; -- 2,263,784
SELECT COUNT(COUNT) FROM central_insights_sandbox.mc_collections_data_18
WHERE COUNT = 1; -- 319817

SELECT SUM(COUNT) FROM central_insights_sandbox.mc_collections_data_sep18
; -- 2021039
SELECT COUNT(COUNT) FROM central_insights_sandbox.mc_collections_data_sep18
WHERE COUNT = 1; -- 307842

SELECT SUM(COUNT) FROM central_insights_sandbox.mc_collections_data_19
; -- 803,502
SELECT COUNT(COUNT) FROM central_insights_sandbox.mc_collections_data_19
WHERE COUNT = 1; -- 329277

SELECT * FROM central_insights_sandbox.mc_collections_data_18 LIMIT 100;