-- Total count of emails subscription requests and % of email subscription converting sessions by marketing channel & category

SELECT
marketing_channel AS "Marketing Channel"
, marketing_channel_category AS "Marketing Channel Category"
, count(e.hashed_user_id) AS "Count of Emails Subscribed"
, round(count(e.hashed_user_id)/count(*),4)*100 AS "% of Email Subscription Converting Sessions"
FROM fact_sessions s
LEFT JOIN emails e
    ON e.hashed_user_id = s.hashed_user_id
    AND e.received_at BETWEEN s.session_started_at AND s.session_ended_at
WHERE marketing_channel != 'direct'
GROUP BY 1,2
ORDER BY 3 DESC
