-- Count of Sessions by time of day 
SELECT
(CAST(EXTRACT(HOUR FROM TO_TIMESTAMP_NTZ(session_started_at)) AS INT)) AS session_started_at_hour_of_day
, COUNT(* ) AS count_of_sessions
FROM fact_sessions 
WHERE is_bounced_session = FALSE
GROUP BY 1
ORDER BY 1
;

-- Top 5 Landing Pages by Session Count
SELECT
first_page_url 
, COUNT(*) AS sessions_count
FROM fact_sessions
WHERE is_bounced_session = FALSE
GROUP BY 1
ORDER BY 2 DESC
FETCH NEXT 5 ROWS ONLY
;

-- New vs Repeat Sessions
SELECT 
round(count_if(is_first_session = TRUE)/COUNT(*)*100) AS new_sessions_percentage
, round(count_if(is_first_session = FALSE)/COUNT(*)*100) AS repeat_sessions_percentage
FROM fact_sessions
WHERE is_bounced_session = FALSE
;

-- Average Session Duration 
SELECT 
avg(session_duration_minutes)
FROM fact_sessions
WHERE is_bounced_session = FALSE
;

-- Average # Pages Viewed
SELECT 
avg(page_views)
FROM fact_sessions
WHERE is_bounced_session = FALSE
;

-- Bounce Rate
SELECT 
round(count_if(is_bounced_session = TRUE) /count(*),4)*100 AS bounce_rate
FROM fact_sessions
;

-- Top 5 Exit Pages by Session Count
SELECT
last_page_url 
, COUNT(*) AS sessions_count
FROM fact_sessions  AS sessions
WHERE is_bounced_session = FALSE
GROUP BY 1
ORDER BY 2 DESC
FETCH NEXT 5 ROWS ONLY
;
