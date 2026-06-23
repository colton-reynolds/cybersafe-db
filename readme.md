# CyberSafe LA - Database Project 

PostgreSQL database, roles and api for the employee & client management.

## One command to start the services

docker compose up -d

or to rebuild: docker compose down -v && docker compose up -d

## Requirements
 
| Req | Requirement | Where it's met |
|-----|-------------|----------------|
| D1 | Schema normalized to 3NF | `V1` 12 tables, no deliberate denormalization |
| D2 | created_at / updated_at via triggers; soft-delete | `V1`  timestamp columns + `set_updated_at` trigger on every table |
| D3 | Column sensitivity tags (PUBLIC/INTERNAL/CCPA/HIPAA/PCI) | `V5` (SQL comments) + `data-dictionary.xlsx` |
| D4 | Read-only and read-write roles; audit log append-only | `V2`  `cybersafe_read`, `cybersafe_write`; audit log INSERT-only |
| D5 | REST endpoints for intake + staff CRUD | PostgREST serves the `api` schema at :3000 |
| D6 | QuestionnaireResponse store (10 DBIR answers) | `V1`  `questionnaire_response` table |
| D7 | Versioned migrations; one-command reproducible build with seed | `migrations/` + Docker Compose + `seed.py` |
| D8 | At least three operational views | `V4`  3 views |
| D9 | Extensible schema (other domain addable without rewrite) | Dedicated `api` schema; additive design |

## REST Api

The OpenAPI documentation is here:
GET  http://localhost:3000/

GET  http://localhost:3000/business_client
GET  http://localhost:3000/business_client?employee_count=gt.20
GET  http://localhost:3000/consultants_per_cohort

## Backup & Restore
./backup.sh

./restore.sh backups/cybersafe_(timestamp).dump