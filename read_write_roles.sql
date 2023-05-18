CREATE ROLE reader;

do
$$
declare
r record;
new_role text := 'reader';
begin
for r in SELECT schema_name FROM information_schema.schemata where schema_name not like ('pg_%') and schema_name not in ('information_schema')
loop
EXECUTE ('GRANT USAGE ON SCHEMA ' || (format('%I', r.schema_name)) || ' to ' || new_role);
EXECUTE ('GRANT SELECT, USAGE ON ALL SEQUENCES IN SCHEMA ' || (format('%I', r.schema_name)) || ' to '|| new_role);
EXECUTE ('GRANT SELECT ON ALL TABLES IN SCHEMA ' || (format('%I', r.schema_name)) || ' to '|| new_role);
EXECUTE ('ALTER DEFAULT PRIVILEGES IN SCHEMA ' || (format('%I', r.schema_name)) || ' GRANT SELECT ON TABLES TO ' || new_role);
EXECUTE ('ALTER DEFAULT PRIVILEGES IN SCHEMA ' || (format('%I', r.schema_name)) || ' GRANT SELECT, USAGE ON SEQUENCES TO '|| new_role);
end loop;
end;
$$;

GRANT reader to named_user;


--

CREATE ROLE writer;



do
$$
declare
r record;
new_role text := 'writer';
begin
for r in SELECT schema_name FROM information_schema.schemata where schema_name not like ('pg_%') and schema_name not in ('information_schema')
loop
EXECUTE ('GRANT USAGE ON SCHEMA ' || (format('%I', r.schema_name)) || ' to ' || new_role);
EXECUTE ('GRANT SELECT, USAGE ON ALL SEQUENCES IN SCHEMA ' || (format('%I', r.schema_name)) || ' to '|| new_role);
EXECUTE ('GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA ' || (format('%I', r.schema_name)) || ' to '|| new_role);
EXECUTE ('ALTER DEFAULT PRIVILEGES IN SCHEMA ' || (format('%I', r.schema_name)) || ' GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO ' || new_role);
EXECUTE ('ALTER DEFAULT PRIVILEGES IN SCHEMA ' || (format('%I', r.schema_name)) || ' GRANT SELECT, USAGE ON SEQUENCES TO '|| new_role);
EXECUTE ('grant pg_read_all_stats, pg_monitor, pg_signal_backend, pg_read_server_files, pg_write_server_files, pg_execute_server_program to '|| new_role);
end loop;
end;
$$;


GRANT writer to named_user;

--

DROP ROLE

do
$$
declare
r record;
--new_role text := 'reader';
new_role text := 'writer';
begin
for r in SELECT schema_name FROM information_schema.schemata where schema_name not like ('pg_%') and schema_name not in ('information_schema')
loop
EXECUTE ('REVOKE USAGE ON SCHEMA ' || (format('%I', r.schema_name)) || ' from ' || new_role);
EXECUTE ('REVOKE SELECT, USAGE ON ALL SEQUENCES IN SCHEMA ' || (format('%I', r.schema_name)) || ' FROM '|| new_role);
EXECUTE ('REVOKE SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA ' || (format('%I', r.schema_name)) || ' FROM '|| new_role);
EXECUTE ('ALTER DEFAULT PRIVILEGES IN SCHEMA ' || (format('%I', r.schema_name)) || ' REVOKE SELECT, INSERT, UPDATE, DELETE ON TABLES FROM ' || new_role);
EXECUTE ('ALTER DEFAULT PRIVILEGES IN SCHEMA ' || (format('%I', r.schema_name)) || ' REVOKE SELECT, USAGE ON SEQUENCES FROM '|| new_role);
EXECUTE ('DROP ROLE '|| new_role);
end loop;
end;
$$;




