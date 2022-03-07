-- LINKED LOCK QUERY
WITH RECURSIVE lockinfo as (
SELECT blocked_locks.pid::int     AS blocked_pid,
       blocked_activity.usename::text  AS blocked_user,
       blocking_locks.pid::int     AS blocking_pid,
       blocking_activity.usename::text AS blocking_user,
       blocked_activity.query::text    AS blocked_statement,
       blocking_activity.query::text   AS current_statement_in_blocking_process
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
),
linked_lockinfo as (
SELECT ROW_NUMBER() OVER (PARTITION BY p.blocking_pid) as id,
       p.blocking_pid,
       p.blocking_user,
       p.blocked_pid,
       p.blocked_user,
       0 as depth,
       p.blocked_statement,
       p.current_statement_in_blocking_process as blocking_statement
  FROM lockinfo as p
 WHERE p.blocking_pid NOT IN (
                                 SELECT DISTINCT
                                        x.blocked_pid
                                   FROM lockinfo as x
                             )
 UNION ALL
SELECT ROW_NUMBER() OVER (PARTITION BY p.blocking_pid) as id,
       c.blocking_pid,
       c.blocking_user,
       c.blocked_pid,
       c.blocked_user,
       p.depth + 1 as depth,
       c.blocked_statement,
       c.current_statement_in_blocking_process as blocking_statement
  FROM lockinfo as c
  JOIN linked_lockinfo as p
    ON p.blocked_pid = c.blocking_pid
)
SELECT CASE WHEN id = 1 THEN blocking_pid ELSE null::int END::int as blocking_pid,
       CASE WHEN id = 1 THEN blocking_user ELSE null::text END::text as blocking_user,
       blocked_pid,
       blocked_user,
       blocked_statement,
       CASE WHEN id = 1 THEN blocking_statement ELSE null::text END::text as blocking_statement
  FROM linked_lockinfo;
;
