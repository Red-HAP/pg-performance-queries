-- connection activity
select datname as "db_name",
       usename as "username",
       pid as "backend_pid",
       application_name,
       client_addr as "client_ip_address",
       backend_start,
       xact_start,
       query_start,
       state_change,
       wait_event_type,
       wait_event,
       state,
       query
  from pg_stat_activity
;
