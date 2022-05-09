-- pg_stat_statements (PG12)
select d.datname as "database",
       r.rolname as "role",
       s.calls,
       s.rows,
       s.mean_time,
       s.max_time,
       left(s.query, 100) as "query_abbrev"
  from public.pg_stat_statements s
  left
  join pg_database d
    on d.oid = s.dbid
  left
  join pg_roles r
    on r.oid = s.userid
 where r.rolname != 'rdsadmin'
 order
    by case when d.datname in ('koku', 'postgres') then 1 else 0 end::int,
       s.mean_time
 limit 25
;
