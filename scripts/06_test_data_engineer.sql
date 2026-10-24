-- Pembuktian data_engineer: CREATE, MODIFY, DROP object + CRUD table
-- Jalankan sebagai data_engineer
\set ON_ERROR_STOP off
SELECT current_user AS login_sebagai;

\echo '=== CREATE TABLE (harus BERHASIL) ==='
CREATE TABLE salam.mata_kuliah (
    kode  VARCHAR(10) PRIMARY KEY,
    nama  VARCHAR(100) NOT NULL
);

\echo '=== ALTER/MODIFY TABLE (harus BERHASIL) ==='
ALTER TABLE salam.mata_kuliah ADD COLUMN sks INT NOT NULL DEFAULT 3;

\echo '=== CRUD pada tabel (harus BERHASIL) ==='
INSERT INTO salam.mata_kuliah (kode, nama) VALUES ('MBD', 'Manajemen Basis Data');
UPDATE salam.mata_kuliah SET sks = 3 WHERE kode = 'MBD';
SELECT * FROM salam.mata_kuliah;
DELETE FROM salam.mata_kuliah WHERE kode = 'MBD';

\echo '=== CREATE VIEW (harus BERHASIL) ==='
CREATE VIEW salam.v_tes AS SELECT nim, nama FROM salam.mahasiswas;

\echo '=== DROP VIEW (harus BERHASIL) ==='
DROP VIEW salam.v_tes;

\echo '=== DROP TABLE (harus BERHASIL) ==='
DROP TABLE salam.mata_kuliah;
