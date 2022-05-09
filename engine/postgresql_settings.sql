-- PG SETTINGS QUERY
select case when s.category_setting_num = 1 then s.category else ''::text end as category,
       s.name,
       s.description,
       s.context,
       s.unit,
       s.setting,
       s.boot_val,
       s.reset_val,
       s.pending_restart
  from (
           select row_number() over (partition by category) as category_setting_num,
                  category,
                  name,
                  coalesce(short_desc, extra_desc) as description,
                  unit,
                  context,
                  setting,
                  boot_val,
                  reset_val,
                  pending_restart
             from pg_settings
       ) as s
;
