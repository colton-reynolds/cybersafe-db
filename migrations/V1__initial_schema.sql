--------------------------------------- Schema Setup (Colton) ---------------------------------------
-- api schema, which will contain tables that are exposed through PostgREST api.
CREATE SCHEMA IF NOT EXISTS api;

-- FR-D2 requirement:  Every table has created_at / updated_at columns populated by triggers; soft-deletes via deleted_at.
-- Adapted from example at: https://stackoverflow.com/questions/9556474/automatically-populate-a-timestamp-field-in-postgresql-when-a-new-row-is-inserte
-- Used reference from: https://www.postgresql.org/docs/current/plpgsql-trigger.html
CREATE OR REPLACE FUNCTION api.set_updated_at()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;
-----------------------------------------------------------------------------------------------------


--------------------------------------- Tables (Hance) ---------------------------------------
CREATE TABLE api.cohort (
    cohort_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    term VARCHAR(20) NOT NULL,
    academic_year VARCHAR(20) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    deleted_at TIMESTAMPTZ
);
 
CREATE TABLE api.business_client (
    client_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    business_name VARCHAR(150) NOT NULL,
    naics_code VARCHAR(20),
    employee_count INT CHECK (employee_count >= 0),
    street_address VARCHAR(200),
    location VARCHAR(100),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    deleted_at TIMESTAMPTZ
);
 
CREATE TABLE api.contact (
    contact_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    client_id BIGINT NOT NULL REFERENCES api.business_client(client_id) ON DELETE CASCADE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    role VARCHAR(75),
    email VARCHAR(150) UNIQUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    deleted_at TIMESTAMPTZ
);
 
CREATE TABLE api.consultant (
    consultant_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    cohort_id BIGINT REFERENCES api.cohort(cohort_id),
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    competency_level VARCHAR(50),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    deleted_at TIMESTAMPTZ
);
 
CREATE TABLE api.industry_mentor (
    mentor_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    assigned_cohort_id BIGINT REFERENCES api.cohort(cohort_id),
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    expertise_area VARCHAR(100),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    deleted_at TIMESTAMPTZ
);
 
CREATE TABLE api.faculty_advisor (
    faculty_advisor_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    department VARCHAR(100),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    deleted_at TIMESTAMPTZ
);
 
CREATE TABLE api.assignment (
    assignment_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    consultant_id BIGINT NOT NULL REFERENCES api.consultant(consultant_id),
    client_id BIGINT NOT NULL REFERENCES api.business_client(client_id),
    mentor_id BIGINT REFERENCES api.industry_mentor(mentor_id),
    faculty_advisor_id BIGINT REFERENCES api.faculty_advisor(faculty_advisor_id),
    assigned_role VARCHAR(75) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    deleted_at TIMESTAMPTZ
);
 
CREATE TABLE api.mou (
    mou_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    client_id BIGINT NOT NULL REFERENCES api.business_client(client_id) ON DELETE CASCADE,
    version VARCHAR(30) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    deleted_at TIMESTAMPTZ
);
 
CREATE TABLE api.partner_referral (
    referral_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    client_id BIGINT NOT NULL REFERENCES api.business_client(client_id) ON DELETE CASCADE,
    partner_organization VARCHAR(150) NOT NULL,
    referral_event_name VARCHAR(150),
    conversion_outcome VARCHAR(100),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    deleted_at TIMESTAMPTZ
);
 
CREATE TABLE api.audit_log_entry (
    log_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    timestamp TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    user_id BIGINT,
    action_type VARCHAR(50) NOT NULL,
    target_table VARCHAR(75) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    deleted_at TIMESTAMPTZ
);

CREATE TABLE api.questionnaire_response (
    response_id      BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    client_id        BIGINT NOT NULL REFERENCES api.business_client(client_id) ON DELETE CASCADE,
    question_number  INT NOT NULL CHECK (question_number BETWEEN 1 AND 10),
    answer           CHAR(1) NOT NULL CHECK (answer IN ('A','B','C','D')),
    created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
    deleted_at       TIMESTAMPTZ,
    UNIQUE (client_id, question_number)
);

CREATE TABLE api.knowledge_base_entry (
    entry_id           BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title              VARCHAR(150) NOT NULL,
    finding            TEXT NOT NULL,
    severity           VARCHAR(20) CHECK (severity IN ('Low','Medium','High','Critical')),
    remediation        TEXT,
    created_at         TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at         TIMESTAMPTZ NOT NULL DEFAULT now(),
    deleted_at         TIMESTAMPTZ
);

-----------------------------------------------------------------------------------------------------

--------------------------------------- Triggers (Colton) ---------------------------------------
CREATE TRIGGER set_updated_at BEFORE UPDATE ON api.cohort
  FOR EACH ROW EXECUTE FUNCTION api.set_updated_at();
CREATE TRIGGER set_updated_at BEFORE UPDATE ON api.business_client
  FOR EACH ROW EXECUTE FUNCTION api.set_updated_at();
CREATE TRIGGER set_updated_at BEFORE UPDATE ON api.contact
  FOR EACH ROW EXECUTE FUNCTION api.set_updated_at();
CREATE TRIGGER set_updated_at BEFORE UPDATE ON api.consultant
  FOR EACH ROW EXECUTE FUNCTION api.set_updated_at();
CREATE TRIGGER set_updated_at BEFORE UPDATE ON api.industry_mentor
  FOR EACH ROW EXECUTE FUNCTION api.set_updated_at();
CREATE TRIGGER set_updated_at BEFORE UPDATE ON api.faculty_advisor
  FOR EACH ROW EXECUTE FUNCTION api.set_updated_at();
CREATE TRIGGER set_updated_at BEFORE UPDATE ON api.assignment
  FOR EACH ROW EXECUTE FUNCTION api.set_updated_at();
CREATE TRIGGER set_updated_at BEFORE UPDATE ON api.mou
  FOR EACH ROW EXECUTE FUNCTION api.set_updated_at();
CREATE TRIGGER set_updated_at BEFORE UPDATE ON api.partner_referral
  FOR EACH ROW EXECUTE FUNCTION api.set_updated_at();
CREATE TRIGGER set_updated_at BEFORE UPDATE ON api.audit_log_entry
  FOR EACH ROW EXECUTE FUNCTION api.set_updated_at();
CREATE TRIGGER set_updated_at BEFORE UPDATE ON api.questionnaire_response
  FOR EACH ROW EXECUTE FUNCTION api.set_updated_at();
CREATE TRIGGER set_updated_at BEFORE UPDATE ON api.knowledge_base_entry
  FOR EACH ROW EXECUTE FUNCTION api.set_updated_at();
-------------------------------------------------------------------------------------------------------