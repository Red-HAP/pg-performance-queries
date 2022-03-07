select (boot_val::int / 10000::int)::int as "release",
       ((boot_val::int / 100)::int % 100::int)::int as "major",
       (boot_val::int % 100::int)::int as "minor"
  from pg_settings
 where name = 'server_version_num';
