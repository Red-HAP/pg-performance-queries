-- LOCK INFO QUERY
SELECT count(blocking_locks.pid) over (partition by blocking_locks.pid) as blocking_pid_weight,
       blocking_locks.pid::int     AS blocking_pid,
       blocking_activity.usename::text AS blocking_user,
       blocked_locks.pid::int     AS blocked_pid,
       blocked_activity.usename::text  AS blocked_user,
       blocked_activity.query::text    AS blocked_statement,
       blocking_activity.query::text   AS blckng_proc_curr_stmt
  FROM pg_catalog.pg_locks         blocked_locks
  JOIN pg_catalog.pg_stat_activity blocked_activity
    ON blocked_activity.pid = blocked_locks.pid
  JOIN pg_catalog.pg_locks         blocking_locks
    ON blocking_locks.locktype = blocked_locks.locktype
   AND blocking_locks.database IS NOT DISTINCT FROM blocked_locks.database
   AND blocking_locks.relation IS NOT DISTINCT FROM blocked_locks.relation
   AND blocking_locks.page IS NOT DISTINCT FROM blocked_locks.page
   AND blocking_locks.tuple IS NOT DISTINCT FROM blocked_locks.tuple
   AND blocking_locks.virtualxid IS NOT DISTINCT FROM blocked_locks.virtualxid
   AND blocking_locks.transactionid IS NOT DISTINCT FROM blocked_locks.transactionid
   AND blocking_locks.classid IS NOT DISTINCT FROM blocked_locks.classid
   AND blocking_locks.objid IS NOT DISTINCT FROM blocked_locks.objid
   AND blocking_locks.objsubid IS NOT DISTINCT FROM blocked_locks.objsubid
   AND blocking_locks.pid != blocked_locks.pid
  JOIN pg_catalog.pg_stat_activity blocking_activity
    ON blocking_activity.pid = blocking_locks.pid
 WHERE NOT blocked_locks.granted
 ORDER
    BY "blocking_pid_weight" desc,
       blocking_locks.pid
;
