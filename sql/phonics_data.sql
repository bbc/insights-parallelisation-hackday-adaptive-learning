-- 0. Rough
-- 1. Get data
-- - 1.1 Extract info from metadata - all answers available, option chosen etc
-- - - Created central_insights_sandbox.mc_adaptivelearning_user_data_temp
-- - 1.2 Add the correct answers
-- - - Created central_insights_sandbox.mc_adaptivelearning_user_data
-- - - Dropped central_insights_sandbox.mc_adaptivelearning_user_data_temp

-- 0. went live October
with d as (
SELECT
  hashed_record_id_publisher,
  event_source,
  metadata,
  dt,
  hr,
  event_start_datetime,
  REGEXP_REPLACE(metadata, 'ping-pong', 'ping_pong'),
  result
FROM s3_audience.publisher
WHERE dt BETWEEN '20191212' AND '20191220'
      AND destination = 'PS_BITESIZE'
      AND container = 'identify-activity')
SELECT * FROM d
;


-- 1. Get data
-- - 1.1 Extract info from metadata - all answers available, option chosen etc
DROP TABLE IF EXISTS central_insights_sandbox.mc_adaptivelearning_user_data_temp;
CREATE TABLE central_insights_sandbox.mc_adaptivelearning_user_data_temp AS (
with d as (
SELECT
  hashed_record_id_publisher,
  event_source,
  metadata,
  dt,
  hr,
  event_start_datetime,
  REGEXP_REPLACE(metadata, 'ping-pong', 'ping_pong'),
  result
FROM s3_audience.publisher
WHERE dt BETWEEN '20191212' AND '20191220'
      AND destination = 'PS_BITESIZE'
      AND container = 'identify-activity')
SELECT
  hashed_record_id_publisher,
  event_source,
  metadata,
  dt,
  hr,
  event_start_datetime,
  SPLIT_PART(SPLIT_PART(SPLIT_PART(metadata, 'ANS=', 2), 'LVL=', 2), '-', 1) AS option1,
  SPLIT_PART(SPLIT_PART(SPLIT_PART(metadata, 'ANS=', 2), 'LVL=', 2), '-', 2) AS option2,
  SPLIT_PART(SPLIT_PART(SPLIT_PART(metadata, 'ANS=', 2), 'LVL=', 2), '-', 3) AS option3,
  SPLIT_PART(SPLIT_PART(SPLIT_PART(metadata, 'ANS=', 2), 'LVL=', 2), '-', 4) AS option4,
  SPLIT_PART(SPLIT_PART(metadata, 'ANS=', 2), '~', 1)                        AS answer,
  result                                                                     AS was_correct
FROM d
ORDER BY event_source);

SELECT * FROM central_insights_sandbox.mc_adaptivelearning_user_data;

-- - 1.2 Add the correct answers
DROP TABLE IF EXISTS central_insights_sandbox.mc_adaptivelearning_user_data;
CREATE TABLE central_insights_sandbox.mc_adaptivelearning_user_data AS (
with c AS (
SELECT
  event_source,
  SPLIT_PART(event_source, ' ', 1) AS phonic_sound,
  SPLIT_PART(SPLIT_PART(metadata, 'ANS=', 2), '~', 1)                        AS answer
FROM s3_audience.publisher
WHERE dt BETWEEN '20191212' AND '20191220'
  AND destination = 'PS_BITESIZE'
  AND container = 'identify-activity'
  AND result = 'correct'
GROUP BY event_source, answer),
o1 AS (
SELECT
  hashed_record_id_publisher,
  d.event_source,
  phonic_sound,
  metadata,
  dt,
  hr,
  event_start_datetime,
  option1,
  option2,
  option3,
  option4,
  d.answer,
  was_correct,
  c.answer AS o1_correct
FROM central_insights_sandbox.mc_adaptivelearning_user_data_temp AS d
LEFT JOIN c
ON d.event_source = c.event_source
AND d.option1 = c.answer),
o2 AS (
SELECT
  hashed_record_id_publisher,
  o1.event_source,
  phonic_sound,
  metadata,
  dt,
  hr,
  event_start_datetime,
  option1,
  option2,
  option3,
  option4,
  o1.answer,
  was_correct,
  o1_correct,
  c.answer AS o2_correct
FROM o1
LEFT JOIN c
ON o1.event_source = c.event_source
AND o1.option2 = c.answer),
o3 AS (
SELECT
  hashed_record_id_publisher,
  o2.event_source,
  phonic_sound,
  metadata,
  dt,
  hr,
  event_start_datetime,
  option1,
  option2,
  option3,
  option4,
  o2.answer,
  was_correct,
  o1_correct,
  o2_correct,
  c.answer AS o3_correct
FROM o2
LEFT JOIN c
ON o2.event_source = c.event_source
AND o2.option3 = c.answer),
o4 AS (
SELECT
  hashed_record_id_publisher,
  o3.event_source,
  phonic_sound,
  metadata,
  dt,
  hr,
  event_start_datetime,
  option1,
  option2,
  option3,
  option4,
  o3.answer,
  was_correct,
  o1_correct,
  o2_correct,
  o3_correct,
  c.answer AS o4_correct
FROM o3
LEFT JOIN c
ON o3.event_source = c.event_source
AND o3.option4 = c.answer),
correct_options AS (
SELECT
  hashed_record_id_publisher,
  event_source,
  phonic_sound,
  metadata,
  dt,
  hr,
  event_start_datetime,
  option1,
  option2,
  option3,
  option4,
  answer,
  was_correct,
  CASE
    WHEN o1_correct IS NOT NULL
      THEN o1_correct
    WHEN o2_correct IS NOT NULL
      THEN o2_correct
    WHEN o3_correct IS NOT NULL
      THEN o3_correct
    WHEN o4_correct IS NOT NULL
      THEN o4_correct
    END AS correct_answer
FROM o4)
-- If no one has answered a particular question correctly, then look for the correct phonic sound in the words
SELECT
  hashed_record_id_publisher,
  event_source,
  phonic_sound,
  metadata,
  dt,
  hr,
  event_start_datetime,
  option1,
  option2,
  option3,
  option4,
  answer,
  was_correct,
  CASE
    WHEN correct_answer IS NULL
;
DROP TABLE IF EXISTS central_insights_sandbox.mc_adaptivelearning_user_data_temp;

-- - 1.3 Replace correct answers for questions that never get answered correctly based off their phonic letter
SELECT
  SPLIT_PART(event_source, ' ', 1) AS phonic_sound,
  option1
FROM central_insights_sandbox.mc_adaptivelearning_user_data

-- - 1.3 Why do some still not have correct answers?
-- A. where ever 'ping-pong' appears as an answer the split_part on '-' fails
-- - try replacing with 'ping_pong'
-- B. Sometimes no one has answered with a correct answer. no one has given 'meet' as a correct answer to 'phonics ee blending'
-- - might need to get the list from Paul but this may resolve itself with more data
SELECT * FROM central_insights_sandbox.mc_adaptivelearning_user_data
WHERE correct_answer IS NULL
AND metadata NOT LIKE '%ping-pong%';

SELECT * FROM central_insights_sandbox.mc_adaptivelearning_user_data_temp
WHERE event_source = 'phonics ee blending'
AND answer = 'meet'
AND was_correct = 'correct'
;

