-- 1. Get data
-- - 1.1 Extract info from metadata - all answers available, option chosen etc
DROP TABLE IF EXISTS central_insights_sandbox.mc_adaptivelearning_user_data;
CREATE TABLE central_insights_sandbox.mc_adaptivelearning_user_data AS (
with d as (
SELECT
  unique_visitor_cookie_id,
  event_source,
  SPLIT_PART(event_source, ' ', 2) AS phonic_sound,
  dt,
  hr,
  event_start_datetime,
  REGEXP_REPLACE(metadata, 'ping-pong', 'ping_pong') AS metadata,
  result
FROM s3_audience.publisher
WHERE dt BETWEEN '20191001' AND '20191231'
      AND destination = 'PS_BITESIZE'
      AND container = 'identify-activity')
SELECT
  unique_visitor_cookie_id,
  event_source,
  SPLIT_PART(event_source, ' ', 3)  AS section,
  phonic_sound,
  metadata,
  dt,
  hr,
  event_start_datetime,
  SPLIT_PART(SPLIT_PART(SPLIT_PART(metadata, 'ANS=', 2), 'LVL=', 2), '-', 1) AS option1,
  SPLIT_PART(SPLIT_PART(SPLIT_PART(metadata, 'ANS=', 2), 'LVL=', 2), '-', 2) AS option2,
  SPLIT_PART(SPLIT_PART(SPLIT_PART(metadata, 'ANS=', 2), 'LVL=', 2), '-', 3) AS option3,
  SPLIT_PART(SPLIT_PART(SPLIT_PART(metadata, 'ANS=', 2), 'LVL=', 2), '-', 4) AS option4,
  SPLIT_PART(SPLIT_PART(metadata, 'ANS=', 2), '~', 1)                        AS answer,
  SPLIT_PART(SPLIT_PART(metadata, '~', 1), 'POS=', 2)                        AS question_number,
  CASE
    WHEN result = 'incorrect'
      THEN False
    WHEN result = 'correct'
      THEN True
  END                                                                        AS was_correct
FROM d
ORDER BY event_source);

SELECT * FROM s3_audience.publisher
WHERE dt = '20191101'
      AND destination = 'PS_BITESIZE'
      AND container = 'identify-activity'
  AND unique_visitor_cookie_id IN ('-1170429884931020486', -1170429884931020486);