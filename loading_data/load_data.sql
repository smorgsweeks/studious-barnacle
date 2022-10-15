-- Create table for email sign-ups
create or replace table emails (
  received_at timestamp_ntz, 
  hashed_user_id varchar,	
  url varchar
  ); 
  
-- Create table for sessions data 
create or replace table test_sessions (
    session_start_tstamp timestamp_ntz, 
    session_end_tstamp timestamp_ntz,
    page_views int,
    utm_source varchar,
    utm_content varchar,
    utm_medium varchar,
    utm_campaign varchar,
    utm_term varchar,
    first_page_url varchar,
    referrer varchar,
    last_page_url varchar,
    hashed_user_id varchar
  );
  
-- upload my local ramp data files to an internal stage location (csv_stage)
put file:///tmp/load/ramp*.csv @my_csv_stage auto_compress=true;  

-- Copy email sign-ups into the emails table 
copy into emails
  from @my_csv_stage/ramp_emails.csv.gz
  file_format = (format_name = csv) --CSV format had already been defined 
  on_error = 'skip_file';
  
-- Copy web sessions into the sessions table 
copy into sessions
  from @my_csv_stage/ramp_sessions.csv.gz
  file_format = (format_name = csv)
  on_error = 'skip_file';

-- Remove staged files
remove @my_csv_stage pattern='.*.csv.gz';

  
