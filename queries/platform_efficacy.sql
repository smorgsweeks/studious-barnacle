-- Count of Sessions by Marketing Channel & Category
SELECT 
marketing_channel
, marketing_channel_category
, COUNT(*)
FROM fact_sessions
WHERE marketing_channel != 'direct'
GROUP BY 1,2
ORDER BY 3 DESC
;

-- Count of Users, Avg Session Duration in Minutes, Average # of Pages Viewed by Marketing Channel & Category 
SELECT 
marketing_channel
, marketing_channel_category
, COUNT(distinct hashed_user_id) AS count_of_users
, round(avg(session_duration_minutes),2) AS average_session_duration
, round(avg(page_views),2) AS average_session_pageviews
FROM fact_sessions
WHERE marketing_channel != 'direct' 
AND is_bounced_session = FALSE -- want to remove bounced sessions for better insights into behaviors
GROUP BY 1,2
ORDER BY 3 DESC
;

-- Count of Sessions & Bounce Rate by Marketing Channell & Category
SELECT 
marketing_channel
, marketing_channel_category
, count(*) AS count_of_sessions
, count_if(is_bounced_session = TRUE) AS count_of_bounced_sessions
, round(count_if(is_bounced_session = TRUE) /count(*),2) AS bounce_rate
FROM fact_sessions
WHERE marketing_channel != 'direct' 
GROUP BY 1,2
ORDER BY 3 DESC
;
