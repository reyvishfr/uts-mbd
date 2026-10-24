-- Pembuktian constraint (jalankan sebagai postgres)
-- Tiap blok yang "GAGAL" memang HARUS error. Pakai \set ON_ERROR_STOP off supaya lanjut.
\set ON_ERROR_STOP off

\echo '=== 1. Data valid (harus BERHASIL) ==='
INSERT INTO salam.mahasiswas (nim, nama, email, angkatan, ipk, status)
VALUES ('1247050021', 'Reyvianti Shafira', 'reyvi@gmail.com', 2024, 3.75, 'aktif');

\echo '=== 2. PRIMARY KEY: id duplikat (harus GAGAL) ==='
INSERT INTO salam.mahasiswas (id, nim, nama, email, angkatan, ipk)
VALUES (1, '1247050099', 'Budi', 'budi@example.com', 2024, 3.00);

\echo '=== 3. UNIQUE: nim duplikat (harus GAGAL) ==='
INSERT INTO salam.mahasiswas (nim, nama, email, angkatan, ipk)
VALUES ('1247050021', 'Orang Lain', 'lain@example.com', 2024, 3.00);

\echo '=== 4. UNIQUE: email duplikat (harus GAGAL) ==='
INSERT INTO salam.mahasiswas (nim, nama, email, angkatan, ipk)
VALUES ('1247050022', 'Orang Lain', 'reyvi@gmail.com', 2024, 3.00);

\echo '=== 5. CHECK: ipk > 4 (harus GAGAL) ==='
INSERT INTO salam.mahasiswas (nim, nama, email, angkatan, ipk)
VALUES ('1247050023', 'Ani', 'ani@example.com', 2024, 4.50);

\echo '=== 6. CHECK: status tidak valid (harus GAGAL) ==='
INSERT INTO salam.mahasiswas (nim, nama, email, angkatan, ipk, status)
VALUES ('1247050024', 'Citra', 'citra@example.com', 2024, 3.00, 'bolos');

\echo '=== 7. CHECK: angkatan di luar rentang (harus GAGAL) ==='
INSERT INTO salam.mahasiswas (nim, nama, email, angkatan, ipk)
VALUES ('1247050025', 'Dedi', 'dedi@example.com', 1999, 3.00);

\echo '=== 8. NOT NULL: nama kosong (harus GAGAL) ==='
INSERT INTO salam.mahasiswas (nim, nama, email, angkatan, ipk)
VALUES ('1247050026', NULL, 'eka@example.com', 2024, 3.00);

\echo '=== Isi tabel akhir (hanya 1 baris valid) ==='
SELECT id, nim, nama, email, angkatan, ipk, status FROM salam.mahasiswas;

\echo '=== Log trigger (fitur pembeda) ==='
SELECT * FROM salam.log_mahasiswas;
