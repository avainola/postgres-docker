docker cp server/base.sql database_postgres_1:/base.sql
docker exec database_postgres_1 psql --user postgres -d tree_testing02 -f base.sql