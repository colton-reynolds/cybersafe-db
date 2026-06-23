#!/bin/bash
# creates a backup of the database in backups: https://www.postgresql.org/docs/current/app-pgdump.html
# https://gist.github.com/mohanpedala/1e2ff5661761d3abd0385e8223e16425?permalink_comment_id=3799230
# https://wiki.postgresql.org/wiki/Automated_Backup_on_Linux

mkdir -p backups
FILE="backups/cybersafe_$(date +%Y%m%d_%H%M%S).dump"
docker compose exec -T db pg_dump -U cybersafe_admin -d cybersafe -Fc --no-owner > "$FILE"