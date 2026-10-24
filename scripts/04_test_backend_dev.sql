-- Pembuktian backend_dev: CRUD boleh, DDL ditolak
-- Jalankan sebagai backend_dev
\set ON_ERROR_STOP off
SELECT current_user AS login_sebagai;

\echo '=== INSERT (harus BERHASIL) ==='
INSERT INTO salam.mahasiswas (nim, nama, email, angkatan, ipk)
VALUES ('1247050031', 'Tes Backend', 'backend@example.com', 2024, 3.20);

\echo '=== SELECT (harus BERHASIL) ==='
SELECT id, nim, nama FROM salam.mahasiswas;

\echo '=== UPDATE (harus BERHASIL) ==='
UPDATE salam.mahasiswas SET ipk = 3.50 WHERE nim = '1247050031';

\echo '=== DELETE (harus BERHASIL) ==='
DELETE FROM salam.mahasiswas WHERE nim = '1247050031';

\echo '=== CREATE TABLE (harus GAGAL) ==='
CREATE TABLE salam.coba_backend (id INT);

\echo '=== DROP TABLE (harus GAGAL) ==='
DROP TABLE salam.mahasiswas;
