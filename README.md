# UTS Manajemen Basis Data - PostgreSQL + pgAdmin4 (Docker)

Nama: Reyvianti Shafira
NIM: 1247050021

## Isi repo
- `docker-compose.yml` : service postgres_reyvianti (port 22021) dan pgadmin_reyvianti (port 44021)
- `.env.example` : contoh isi .env (file `.env` asli tidak di-push)
- `scripts/01_schema_salam.sql` : skema SALAM, tabel mahasiswas, view, trigger log
- `scripts/02_test_constraint.sql` : pembuktian constraint
- `scripts/03_users.sql` : user backend_dev, bi_dev, data_engineer
- `scripts/04-06_test_*.sql` : pembuktian hak akses tiap user

## Cara jalanin
1. Salin `.env.example` jadi `.env`, lalu isi username dan password.
2. `docker compose up -d`
3. Jalankan script SQL:
```
docker exec postgres_reyvianti psql -U postgres -d db_rey -f /scripts/01_schema_salam.sql
docker exec postgres_reyvianti psql -U postgres -d db_rey -f /scripts/02_test_constraint.sql
docker exec postgres_reyvianti psql -U postgres -d db_rey -f /scripts/03_users.sql
docker exec postgres_reyvianti psql -U backend_dev -d db_rey -f /scripts/04_test_backend_dev.sql
docker exec postgres_reyvianti psql -U bi_dev -d db_rey -f /scripts/05_test_bi_dev.sql
docker exec postgres_reyvianti psql -U data_engineer -d db_rey -f /scripts/06_test_data_engineer.sql
```
4. pgAdmin: http://localhost:44021
5. DBeaver: host localhost, port 22021, database db_rey
