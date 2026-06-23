# AI assistance (Claude) was used to write this generator.
from faker import Faker

faker = Faker("en_US")
Faker.seed(20262027)

def quote(value):
    if value is None:
        return "NULL"
    escaped = str(value).replace("'", "''")
    return "'" + escaped + "'"

sql_statements = []

competency_levels = ["Foundation", "Professional", "Expert"]
naics_codes = ["722511", "445110", "541211", "621210", "811212"]
partner_organizations = ["LA SBDC", "SBA", "East LA Chamber", "CISA Region 9"]
conversion_outcomes = ["Converted", "No response", "Referred elsewhere", "Pending"]
expertise_areas = ["Network Security", "Identity & Access", "Incident Response", "Compliance"]
departments = ["Information Systems", "Computer Science", "Cybersecurity"]
assigned_roles = ["Lead", "Support", "Reviewer"]
audit_actions = ["INSERT", "UPDATE", "DELETE", "LOGIN"]
audit_targets = ["business_client", "contact", "assignment", "mou"]

terms = ["Fall", "Spring", "Summer"]
academic_years = [
    "2024-2025", "2025-2026", "2026-2027",
    "2027-2028", "2028-2029", "2029-2030",
    "2030-2031",
]
for academic_year in academic_years:
    for term in terms:
        sql_statements.append(
            "INSERT INTO api.cohort (term, academic_year) VALUES ("
            + quote(term) + ", " + quote(academic_year) + ");"
        )

number_of_businesses = 25
for business_number in range(number_of_businesses):
    business_name = faker.company()
    naics_code = faker.random_element(naics_codes)
    employee_count = faker.random_int(min=1, max=49)
    street_address = faker.street_address()
    location = faker.city()
    sql_statements.append(
        "INSERT INTO api.business_client "
        "(business_name, naics_code, employee_count, street_address, location) VALUES ("
        + quote(business_name) + ", "
        + quote(naics_code) + ", "
        + str(employee_count) + ", "
        + quote(street_address) + ", "
        + quote(location) + ");"
    )

for client_id in range(1, number_of_businesses + 1):
    number_of_contacts = faker.random_int(min=1, max=2)
    for contact_number in range(number_of_contacts):
        first_name = faker.first_name()
        last_name = faker.last_name()
        role = faker.job()[:40]
        email = faker.unique.email()
        sql_statements.append(
            "INSERT INTO api.contact "
            "(client_id, first_name, last_name, role, email) VALUES ("
            + str(client_id) + ", "
            + quote(first_name) + ", "
            + quote(last_name) + ", "
            + quote(role) + ", "
            + quote(email) + ");"
        )

number_of_consultants = 22
for consultant_number in range(number_of_consultants):
    cohort_id = faker.random_int(min=1, max=4)
    first_name = faker.first_name()
    last_name = faker.last_name()
    competency_level = faker.random_element(competency_levels)
    sql_statements.append(
        "INSERT INTO api.consultant "
        "(cohort_id, first_name, last_name, competency_level) VALUES ("
        + str(cohort_id) + ", "
        + quote(first_name) + ", "
        + quote(last_name) + ", "
        + quote(competency_level) + ");"
    )

number_of_mentors = 20
for mentor_number in range(number_of_mentors):
    assigned_cohort_id = faker.random_int(min=1, max=4)
    first_name = faker.first_name()
    last_name = faker.last_name()
    expertise_area = faker.random_element(expertise_areas)
    sql_statements.append(
        "INSERT INTO api.industry_mentor "
        "(assigned_cohort_id, first_name, last_name, expertise_area) VALUES ("
        + str(assigned_cohort_id) + ", "
        + quote(first_name) + ", "
        + quote(last_name) + ", "
        + quote(expertise_area) + ");"
    )

number_of_faculty_advisors = 20
for faculty_advisor_number in range(number_of_faculty_advisors):
    first_name = faker.first_name()
    last_name = faker.last_name()
    department = faker.random_element(departments)
    sql_statements.append(
        "INSERT INTO api.faculty_advisor "
        "(first_name, last_name, department) VALUES ("
        + quote(first_name) + ", "
        + quote(last_name) + ", "
        + quote(department) + ");"
    )

number_of_assignments = 30
for assignment_number in range(number_of_assignments):
    consultant_id = faker.random_int(min=1, max=number_of_consultants)
    client_id = faker.random_int(min=1, max=number_of_businesses)
    mentor_id = faker.random_int(min=1, max=number_of_mentors)
    faculty_advisor_id = faker.random_int(min=1, max=number_of_faculty_advisors)
    assigned_role = faker.random_element(assigned_roles)
    sql_statements.append(
        "INSERT INTO api.assignment "
        "(consultant_id, client_id, mentor_id, faculty_advisor_id, assigned_role) VALUES ("
        + str(consultant_id) + ", "
        + str(client_id) + ", "
        + str(mentor_id) + ", "
        + str(faculty_advisor_id) + ", "
        + quote(assigned_role) + ");"
    )

for client_id in range(1, number_of_businesses + 1):
    version = "v" + str(faker.random_int(min=1, max=3)) + ".0"
    sql_statements.append(
        "INSERT INTO api.mou (client_id, version) VALUES ("
        + str(client_id) + ", "
        + quote(version) + ");"
    )

number_of_referrals = 25
for referral_number in range(number_of_referrals):
    client_id = faker.random_int(min=1, max=number_of_businesses)
    partner_organization = faker.random_element(partner_organizations)
    referral_event_name = faker.catch_phrase()[:60]
    conversion_outcome = faker.random_element(conversion_outcomes)
    sql_statements.append(
        "INSERT INTO api.partner_referral "
        "(client_id, partner_organization, referral_event_name, conversion_outcome) VALUES ("
        + str(client_id) + ", "
        + quote(partner_organization) + ", "
        + quote(referral_event_name) + ", "
        + quote(conversion_outcome) + ");"
    )

number_of_audit_entries = 25
for audit_entry_number in range(number_of_audit_entries):
    user_id = faker.random_int(min=1, max=number_of_consultants)
    action_type = faker.random_element(audit_actions)
    target_table = faker.random_element(audit_targets)
    sql_statements.append(
        "INSERT INTO api.audit_log_entry "
        "(user_id, action_type, target_table) VALUES ("
        + str(user_id) + ", "
        + quote(action_type) + ", "
        + quote(target_table) + ");"
    )

answer_options = ["A", "B", "C", "D"]
severity_levels = ["Low", "Medium", "High", "Critical"]

for client_id in range(1, number_of_businesses + 1):
    for question_number in range(1, 11):
        answer = faker.random_element(answer_options)
        sql_statements.append(
            "INSERT INTO api.questionnaire_response "
            "(client_id, question_number, answer) VALUES ("
            + str(client_id) + ", "
            + str(question_number) + ", "
            + quote(answer) + ");"
        )

number_of_knowledge_base_entries = 25
for knowledge_base_entry_number in range(number_of_knowledge_base_entries):
    title = faker.catch_phrase()[:120]
    finding = faker.paragraph(nb_sentences=3)
    severity = faker.random_element(severity_levels)
    remediation = faker.paragraph(nb_sentences=2)
    sql_statements.append(
        "INSERT INTO api.knowledge_base_entry "
        "(title, finding, severity, remediation) VALUES ("
        + quote(title) + ", "
        + quote(finding) + ", "
        + quote(severity) + ", "
        + quote(remediation) + ");"
    )

for statement in sql_statements:
    print(statement)
