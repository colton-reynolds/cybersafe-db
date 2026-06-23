#!/bin/bash
# restore the database from a backup: https://www.tigerdata.com/learn/a-guide-to-pg_restore-and-pg_restore-example

docker compose exec -T db pg_restore -U cybersafe_admin -d cybersafe --clean --if-exists < "$1"