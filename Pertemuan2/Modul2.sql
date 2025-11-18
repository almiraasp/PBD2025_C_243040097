IF DB_ID('TokoRetailDB') IS NOT NULL
BEGIN 
	USE master;
		DROP DATABASE TokoRetailDB;
END
GO

--MEMBUAT DATABASE BARU
CREATE DATABASE TokoRetailDB;
GO

--MENGGUNAKAN DB
USE TokoRetailDB;
GO

PRINT 'Database TokoRetailDB berhasil dibuat dan digunakan.';

-- 1. MEMBUAT TABEL KATEGORI
CREATE TABLE KategoriProduk (
	KategoriID INT IDENTITY(1, 1) PRIMARY KEY,
	NamaKategori VARCHAR(100) NOT NULL UNIQUE,
);
GO

-- 2. MEMBUAT TABEL PRODUK
CREATE TABLE Produk (
	ProdukID INT IDENTITY(1001, 1) PRIMARY KEY,
	SKU VARCHAR(20) NOT NULL UNIQUE,
	NamaProduk VARCHAR(150) NOT NULL,
	Harga DECIMAL(10, 2) NOT NULL,
	Stok INT NOT NULL,
	KategoriID INT NULL,

	-- CARA MENULIS CONSTRAINT
	-- CONSTRAINT NAMA_CONSTRAINT JENIS_CONSTRAINT (NAMA KOLOM YG AKAN DITAMBAH CONSTRAINT)
	CONSTRAINT CHK_HargaPositif CHECK (Harga >= 0),
	CONSTRAINT CHK_StokPositif CHECK (Stok >= 0),
	CONSTRAINT FK_Produk_Kategori 
	FOREIGN KEY (KategoriID)
	REFERENCES KategoriProduk (KategoriID)
);
GO

-- 3. MEMBUAT TABEL PELANGGAN
CREATE TABLE Pelanggan (
	PelangganID INT IDENTITY(1,1) PRIMARY KEY,
	NamaDepan VARCHAR(50) NOT NULL,
	NamaBelakang VARCHAR(50) NULL,
	Email VARCHAR(100) NOT NULL UNIQUE,
	NoTelepon VARCHAR(20) NULL,
	TanggalDaftar DATE DEFAULT GETDATE()
);
GO

-- 4. MEMBUAT TABEL PESANANHEADER
CREATE TABLE PesananHeader (
	PesananID INT IDENTITY(50001,1) PRIMARY KEY,
	PelangganID INT NOT NULL,
	TanggalPesanan DATETIME DEFAULT GETDATE(),
	StatusPesanan VARCHAR(20) NOT NULL,

	CONSTRAINT CHK_StatusPesanan CHECK (StatusPesanan IN('Baru', 'Proses', 'Selesai', 'Batal')),
	CONSTRAINT FK_Pesanan_Pelanggan 
	FOREIGN KEY (PelangganID)
	REFERENCES Pelanggan(PelangganID)
);
GO

-- 5. MEMBUAT TABEL PESANANDETAIL
CREATE TABLE PesananDetail (
	PesananDetailID INT IDENTITY(1,1) PRIMARY KEY,
	PesananID INT NOT NULL,
	ProdukID INT NOT NULL,
	Jumlah INT NOT NULL,
	HargaSatuan DECIMAL(10,2) NOT NULL,

	CONSTRAINT CHK_JumlahPositif CHECK (Jumlah>0),
	CONSTRAINT FK_Detail_Header
		FOREIGN KEY (PesananID)
		REFERENCES PesananHeader(PesananID)
		ON DELETE CASCADE,

	CONSTRAINT FK_Detail_Produk
		FOREIGN KEY (ProdukID)
		REFERENCES Produk(ProdukID)
);
GO


-- MENAMBAHKAN DATA KE TABEL PELANGGAN
INSERT INTO Pelanggan (NamaDepan, NamaBelakang, Email, NoTelepon)
VALUES 
('Budi', 'Santoso', 'budi.santoso@gmail.com', '08123456789'),
('Almira Alifia', 'Suparya Putri', 'almiraalifiasuparyaputri@gmail.com', NULL);

-- VERIFIKASI DATA
PRINT 'Data Pelanggan:';
SELECT *
FROM Pelanggan;

-- MENAMBAHKAN DATA KATEGORI
INSERT INTO KategoriProduk (NamaKategori)
VALUES
('Elektronik'),
('Pakaian'),
('Buku');

-- VERIFIKASI DATA
PRINT 'Data Kategori:';
SELECT *
FROM KategoriProduk;

-- 
INSERT INTO Produk (SKU, NamaProduk, Harga, Stok, KategoriID)
VALUES
('ELEC-001', 'Laptop Pro 14 inch', 15000000.00, 50, 1),
('PAK-001', 'Kaos Polos Putih', 75000.00, 200, 2),
('BUK-001', 'Dasar-Dasar SQL', 120000.00, 100, 3);

-- VERIFIKASI DATA
PRINT 'Data Produk:';
SELECT *
FROM Produk;

-- MENCOBA PELANGGARAN UNIK
INSERT INTO Pelanggan (NamaDepan, Email)
VALUES ('Budiiii', 'budi.santoso@gmail.com');