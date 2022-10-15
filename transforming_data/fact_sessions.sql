-- Fact Sessions will contain all session data along with useful transformations for analysis


create or replace table test_fact_sessions as (

SELECT 
hashed_user_id
, session_start_tstamp AS session_started_at
, session_end_tstamp AS session_ended_at
, timediff(minute,session_start_tstamp, session_end_tstamp) AS session_duration_minutes
, timediff(second, session_start_tstamp, session_end_tstamp) AS session_duration_seconds
, page_views
, CASE WHEN utm_source ILIKE ANY ('metadata','social') AND utm_medium ILIKE 'facebook' THEN 'facebook'
       WHEN utm_source = 'social' AND utm_medium= 'linkedin' THEN 'linkedin'
       WHEN referrer ILIKE '%forbes.com%' THEN 'forbes'
       WHEN utm_source IS NOT NULL THEN lower(utm_source) 
       WHEN referrer ILIKE '%google.%' THEN 'google'
       WHEN referrer ILIKE ANY ('%/t.co%', '%twitter%') THEN 'twitter'
       WHEN referrer ILIKE '%youtube%' THEN 'youtube'
       WHEN referrer ILIKE '%linkedin.%' THEN 'linkedin'
       WHEN referrer ILIKE '%bing.com%' THEN 'bing'
       WHEN referrer ILIKE '%facebook%' THEN 'facebook'
       WHEN referrer ILIKE '%instagram%' THEN 'instagram'
       WHEN referrer ILIKE '%duckduckgo%' THEN 'duckduckgo'
       WHEN referrer ILIKE '%techcrunch%' THEN 'tech_crunch'
       WHEN referrer ILIKE '%cnbc.com%' THEN 'cnbc'
       WHEN referrer ILIKE '%plastiq.com%' THEN 'plastiq'
       WHEN referrer ILIKE '%billpay%' THEN 'billpay'
       WHEN referrer ILIKE '%yandex.%' THEN 'yandex'
       WHEN referrer ILIKE '%producthunt%' THEN 'producthunt'
       WHEN referrer ILIKE '%yahoo%' THEN 'bing'
       WHEN referrer ILIKE '%linktr.ee%' THEN 'linktr.ee'
       WHEN referrer ILIKE '%g2.com%' THEN 'g2'
       WHEN referrer ILIKE '%ramp.com%' THEN 'direct'
       WHEN referrer IS NOT NULL THEN 'other-website'
       ELSE 'direct' 
       END AS marketing_channel
, CASE WHEN utm_medium in ('cpc','paid', 'cpm', 'paid-social') AND marketing_channel ILIKE ANY ('facebook','instagram','linkedin', 'twitter') THEN 'paid-social' 
       WHEN marketing_channel ILIKE ANY ('facebook','instagram','linkedin', 'twitter') THEN 'organic-social' 
       WHEN utm_medium in ('cpc','paid', 'cpm','ppc') AND marketing_channel ILIKE ANY ('google', 'adwords','bing','duckduckgo', 'yandex') AND utm_campaign ILIKE '%display%' THEN 'display'
       WHEN utm_medium in ('cpc','paid', 'cpm','ppc') AND marketing_channel ILIKE ANY ('google', 'adwords','bing','duckduckgo', 'yandex') THEN 'paid-search'
       WHEN marketing_channel ILIKE ANY ('google', 'adwords','bing','duckduckgo','yandex') THEN 'organic-search'
       WHEN utm_medium in ('cpc','paid', 'cpm') THEN 'paid' 
       WHEN utm_medium in ('pr','press') THEN 'press'
       WHEN marketing_channel = 'blog' THEN 'blog'
       WHEN marketing_channel = 'direct' THEN 'direct'
       WHEN marketing_channel = 'youtube' THEN 'video'
       WHEN marketing_channel IN ('tech_crunch') THEN 'blog'
       WHEN marketing_channel = 'forbes' THEN 'referral'
       WHEN utm_medium IS NOT NULL THEN utm_medium
       ELSE 'other' END AS marketing_channel_category
, CASE WHEN utm_campaign ILIKE '%remarketing%' THEN 'remarketing'
       WHEN utm_campaign ILIKE '%prospecting%' THEN 'prospecting'
       ELSE 'undefined'
       END AS marketing_user_type
, utm_source
, utm_content
, utm_medium
, utm_campaign
, utm_term
, first_page_url
, last_page_url
, referrer
, rank() OVER (PARTITION BY hashed_user_id ORDER BY session_start_tstamp ASC) AS session_sequence
, CASE WHEN rank() OVER (PARTITION BY hashed_user_id ORDER BY session_start_tstamp ASC) = 1 THEN TRUE ELSE FALSE END AS is_first_session
, lag(session_end_tstamp) OVER (PARTITION BY hashed_user_id ORDER BY session_end_tstamp) AS last_session_ended_at
, timediff(minute, lag(session_end_tstamp) OVER (PARTITION BY hashed_user_id ORDER BY session_end_tstamp), session_end_tstamp) AS minutes_since_last_session
, CASE WHEN session_duration_seconds = 0 THEN TRUE ELSE FALSE END AS is_bounced_session
FROM test_sessions 
)
