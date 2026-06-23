-- number of consultants per cohort
CREATE VIEW api.consultants_per_cohort AS
SELECT
    cohort.cohort_id,
    cohort.term,
    cohort.academic_year,
    COUNT(consultant.consultant_id) AS consultant_count
FROM api.cohort
LEFT JOIN api.consultant ON consultant.cohort_id = cohort.cohort_id
GROUP BY cohort.cohort_id, cohort.term, cohort.academic_year
ORDER BY cohort.cohort_id;

-- number of referred businesses and conversions
CREATE VIEW api.referral_conversion AS
SELECT partner_organization,
       COUNT(*) AS total_referrals,
       COUNT(*) FILTER (WHERE conversion_outcome = 'Converted') AS converted
FROM api.partner_referral
GROUP BY partner_organization;

-- number of clients in each industry
CREATE VIEW api.clients_per_industry AS
SELECT naics_code, COUNT(*) AS client_count
FROM api.business_client
GROUP BY naics_code;

-- have to give permission to role
GRANT SELECT ON api.consultants_per_cohort, api.referral_conversion, api.clients_per_industry
  TO cybersafe_read, cybersafe_write;