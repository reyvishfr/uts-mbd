-- Nomor 3: skema SALAM + tabel mahasiswas
-- Catatan: nama skema tanpa tanda kutip, jadi PostgreSQL menyimpannya sebagai "salam" (huruf kecil)

CREATE SCHEMA IF NOT EXISTS salam;

CREATE TABLE IF NOT EXISTS salam.mahasiswas (
    id          SERIAL PRIMARY KEY,                                   -- primary key
    nim         VARCHAR(10)  NOT NULL UNIQUE,                         -- unique constraint
    nama        VARCHAR(100) NOT NULL,
    email       VARCHAR(100) UNIQUE,                                  -- unique constraint
    angkatan    INT          NOT NULL,
    ipk         NUMERIC(3,2) NOT NULL DEFAULT 0,
    status      VARCHAR(10)  NOT NULL DEFAULT 'aktif',
    created_at  TIMESTAMP    NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_ipk      CHECK (ipk >= 0 AND ipk <= 4),            -- check constraint
    CONSTRAINT chk_angkatan CHECK (angkatan BETWEEN 2015 AND 2030),   -- check constraint
    CONSTRAINT chk_status   CHECK (status IN ('aktif', 'cuti', 'lulus')),
    CONSTRAINT chk_nim_len  CHECK (char_length(nim) = 10)
);

-- Fitur pembeda: view mahasiswa aktif + tabel log perubahan (audit) lewat trigger
CREATE OR REPLACE VIEW salam.v_mahasiswas_aktif AS
SELECT id, nim, nama, angkatan, ipk
FROM salam.mahasiswas
WHERE status = 'aktif';

CREATE TABLE IF NOT EXISTS salam.log_mahasiswas (
    log_id     SERIAL PRIMARY KEY,
    aksi       VARCHAR(10) NOT NULL,
    nim        VARCHAR(10),
    waktu      TIMESTAMP NOT NULL DEFAULT NOW(),
    oleh       TEXT NOT NULL DEFAULT current_user
);

CREATE OR REPLACE FUNCTION salam.fn_log_mahasiswas() RETURNS trigger AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        INSERT INTO salam.log_mahasiswas (aksi, nim) VALUES (TG_OP, OLD.nim);
        RETURN OLD;
    ELSE
        INSERT INTO salam.log_mahasiswas (aksi, nim) VALUES (TG_OP, NEW.nim);
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trg_log_mahasiswas ON salam.mahasiswas;
CREATE TRIGGER trg_log_mahasiswas
AFTER INSERT OR UPDATE OR DELETE ON salam.mahasiswas
FOR EACH ROW EXECUTE FUNCTION salam.fn_log_mahasiswas();
