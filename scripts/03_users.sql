-- Nomor 4: user baru + hak akses
-- Jalankan sebagai postgres, SETELAH 01_schema_salam.sql
-- Password user baru ini hanya untuk keperluan UTS.

-- 1. Bikin role (aman kalau dijalankan ulang)
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'backend_dev') THEN
        CREATE ROLE backend_dev LOGIN PASSWORD 'backend_pass';
    END IF;
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'bi_dev') THEN
        CREATE ROLE bi_dev LOGIN PASSWORD 'bi_pass';
    END IF;
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'data_engineer') THEN
        CREATE ROLE data_engineer LOGIN PASSWORD 'de_pass';
    END IF;
END
$$;

-- 2. data_engineer jadi pemilik skema salam beserta isinya
--    (pemilik otomatis boleh CREATE, ALTER/MODIFY, DROP, dan CRUD semua objectnya)
ALTER SCHEMA salam OWNER TO data_engineer;
ALTER TABLE salam.mahasiswas OWNER TO data_engineer;
ALTER TABLE salam.log_mahasiswas OWNER TO data_engineer;
ALTER VIEW salam.v_mahasiswas_aktif OWNER TO data_engineer;
ALTER FUNCTION salam.fn_log_mahasiswas() OWNER TO data_engineer;

-- 3. backend_dev: CRUD semua table
GRANT USAGE ON SCHEMA salam TO backend_dev;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA salam TO backend_dev;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA salam TO backend_dev;

-- 4. bi_dev: hanya SELECT semua table/view
GRANT USAGE ON SCHEMA salam TO bi_dev;
GRANT SELECT ON ALL TABLES IN SCHEMA salam TO bi_dev;

-- 5. Hak otomatis untuk object baru yang dibuat data_engineer / postgres di skema salam
ALTER DEFAULT PRIVILEGES FOR ROLE data_engineer IN SCHEMA salam
    GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO backend_dev;
ALTER DEFAULT PRIVILEGES FOR ROLE data_engineer IN SCHEMA salam
    GRANT USAGE, SELECT ON SEQUENCES TO backend_dev;
ALTER DEFAULT PRIVILEGES FOR ROLE data_engineer IN SCHEMA salam
    GRANT SELECT ON TABLES TO bi_dev;

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA salam
    GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO backend_dev;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA salam
    GRANT USAGE, SELECT ON SEQUENCES TO backend_dev;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA salam
    GRANT SELECT ON TABLES TO bi_dev;

-- 6. Ringkasan hak akses
\echo '=== Role yang dibuat ==='
SELECT rolname, rolcanlogin FROM pg_roles
WHERE rolname IN ('backend_dev', 'bi_dev', 'data_engineer') ORDER BY rolname;

\echo '=== Hak akses tabel di skema salam ==='
SELECT grantee, table_name, string_agg(privilege_type, ', ' ORDER BY privilege_type) AS hak
FROM information_schema.role_table_grants
WHERE table_schema = 'salam' AND grantee IN ('backend_dev', 'bi_dev')
GROUP BY grantee, table_name
ORDER BY grantee, table_name;
