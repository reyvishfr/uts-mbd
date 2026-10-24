-- Pembuktian bi_dev: hanya SELECT
-- Jalankan sebagai bi_dev
\set ON_ERROR_STOP off
SELECT current_user AS login_sebagai;

\echo '=== SELECT tabel (harus BERHASIL) ==='
SELECT id, nim, nama FROM salam.mahasiswas;

\echo '=== SELECT view (harus BERHASIL) ==='
SELECT * FROM salam.v_mahasiswas_aktif;

\echo '=== INSERT (harus GAGAL) ==='
INSERT INTO salam.mahasiswas (nim, nama, email, angkatan, ipk)
VALUES ('1247050041', 'Tes BI', 'bi@example.com', 2024, 3.00);

\echo '=== UPDATE (harus GAGAL) ==='
UPDATE salam.mahasiswas SET ipk = 4.00;

\echo '=== DELETE (harus GAGAL) ==='
DELETE FROM salam.mahasiswas;

\echo '=== CREATE TABLE (harus GAGAL) ==='
CREATE TABLE salam.coba_bi (id INT);
