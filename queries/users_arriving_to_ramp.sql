-- Get New and Repeat Sessions by Marketing Channel 
SELECT 
marketing_channel
, marketing_channel_category
, count_if(is_first_session = TRUE) AS new_sessions
, count_if(is_first_session = FALSE) AS repeat_sessions
, count(*) AS total_sessions
FROM test_fact_sessions
GROUP BY 1,2
ORDER BY 3 DESC 
;
