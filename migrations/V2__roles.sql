-- Reference used:  https://docs.postgrest.org/en/v14/explanations/db_authz.html

-- PostgREST role which will log in and use the other two roles.
CREATE ROLE authenticator LOGIN NOINHERIT PASSWORD 'postgrest_password';

-- FR-D4: two roles, read and read-write.
CREATE ROLE cybersafe_read NOLOGIN;
CREATE ROLE cybersafe_write NOLOGIN;

-- Allow PostgREST to switch into the read and read-write roles.
GRANT cybersafe_read TO authenticator;
GRANT cybersafe_write TO authenticator;

-- Allow both roles to use the api schema
GRANT USAGE ON SCHEMA api TO cybersafe_read;
GRANT USAGE ON SCHEMA api TO cybersafe_write;

-- Allow read role to read from the api schema
GRANT SELECT ON ALL TABLES IN SCHEMA api TO cybersafe_read;

-- Allow read-write role to read and write on the api schema
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA api TO cybersafe_write;

-- FR-D4 prevent read-write role from modifying the audit log to preserve integrity.
REVOKE SELECT, UPDATE, DELETE ON api.audit_log_entry FROM cybersafe_write;

-- Allow read-write role to generate new ids.
-- https://stackoverflow.com/questions/10352695/grant-all-on-a-specific-schema-in-the-db-to-a-group-role-in-postgresql
GRANT USAGE ON ALL SEQUENCES IN SCHEMA api TO cybersafe_write;