-- pg_stat_statements (PG13)
select d.datname as "database",
       r.rolname as "role",
       s.calls,
       s.rows,
       s.mean_exec_time,
       s.max_exec_time,
       s.query
  from public.pg_stat_statements s
  left
  join pg_database d
    on d.oid = s.dbid
  left
  join pg_roles r
    on r.oid = s.userid
 where r.rolname != 'rdsadmin'
 order
    by d.datname,
       s.mean_exec_time
 limit 25
;
