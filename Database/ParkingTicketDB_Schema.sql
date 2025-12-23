-- =============================================
-- Parking Ticket Management System - Database Schema
-- SQL Server 2019+
-- Created: 2024-12-23
-- =============================================

USE master;
GO

-- Drop database if exists (for fresh install)
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'ParkingTicketDB')
BEGIN
    ALTER DATABASE ParkingTicketDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE ParkingTicketDB;
END
GO

-- Create database
CREATE DATABASE ParkingTicketDB
ON PRIMARY 
(
    NAME = N'ParkingTicketDB_Data',
    FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\ParkingTicketDB.mdf',
    SIZE = 100MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 10MB
)
LOG ON 
(
    NAME = N'ParkingTicketDB_Log',
    FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\ParkingTicketDB_log.ldf',
    SIZE = 50MB,
    MAXSIZE = 1GB,
    FILEGROWTH = 10MB
);
GO

USE ParkingTicketDB;
GO

-- =============================================
-- Set database options
-- =============================================
ALTER DATABASE ParkingTicketDB SET RECOVERY SIMPLE;
ALTER DATABASE ParkingTicketDB COLLATE Vietnamese_CI_AS;
GO

-- =============================================
-- Table: NhanVien (Employees)
-- Description: Nh?n vi?n ph?t v? thu phi?u
-- =============================================
CREATE TABLE NhanVien (
    MaNV INT IDENTITY(1,1) PRIMARY KEY,
    TenNV NVARCHAR(100) NOT NULL,
    SDT VARCHAR(15),
    Email VARCHAR(100),
    VaiTro NVARCHAR(50) NOT NULL DEFAULT N'Thu Ng?n',
    MatKhau NVARCHAR(255) NOT NULL,
    TrangThai NVARCHAR(20) NOT NULL DEFAULT N'Ho?t ??ng',
    NgayTao DATETIME NOT NULL DEFAULT GETDATE(),
    NgayCapNhat DATETIME NULL,
    
    CONSTRAINT CK_NhanVien_VaiTro CHECK (VaiTro IN (N'Qu?n L?', N'Thu Ng?n', N'B?o V?')),
    CONSTRAINT CK_NhanVien_TrangThai CHECK (TrangThai IN (N'Ho?t ??ng', N'T?m Ngh?', N'Ngh? Vi?c'))
);
GO

-- =============================================
-- Table: GiaVe (Ticket Pricing)
-- Description: B?ng gi? v? theo lo?i xe v? lo?i v?
-- =============================================
CREATE TABLE GiaVe (
    MaGia INT IDENTITY(1,1) PRIMARY KEY,
    LoaiXe NVARCHAR(20) NOT NULL,
    LoaiVe NVARCHAR(20) NOT NULL,
    GiaTien DECIMAL(18,0) NOT NULL,
    NgayApDung DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    NgayKetThuc DATE NULL,
    TrangThai NVARCHAR(20) NOT NULL DEFAULT N'?ang ?p D?ng',
    GhiChu NVARCHAR(500),
    
    CONSTRAINT CK_GiaVe_LoaiXe CHECK (LoaiXe IN (N'Xe ??p', N'Xe M?y', N'? T?')),
    CONSTRAINT CK_GiaVe_LoaiVe CHECK (LoaiVe IN (N'V? Ng?y', N'V? Th?ng', N'Mi?n Ph?')),
    CONSTRAINT CK_GiaVe_GiaTien CHECK (GiaTien >= 0),
    CONSTRAINT CK_GiaVe_TrangThai CHECK (TrangThai IN (N'?ang ?p D?ng', N'H?t Hi?u L?c'))
);
GO

-- =============================================
-- Table: LoPhieu (Ticket Batch)
-- Description: Qu?n l? l? phi?u (t? s? ??n s?)
-- =============================================
CREATE TABLE LoPhieu (
    MaLo INT IDENTITY(1,1) PRIMARY KEY,
    TenLo NVARCHAR(100) NOT NULL,
    TuSo INT NOT NULL,
    DenSo INT NOT NULL,
    LoaiVe NVARCHAR(20) NOT NULL,
    SoLuongPhat INT NOT NULL DEFAULT 0,
    SoLuongConLai INT NOT NULL,
    TrangThai NVARCHAR(20) NOT NULL DEFAULT N'?ang S? D?ng',
    NgayTao DATETIME NOT NULL DEFAULT GETDATE(),
    NguoiTao INT NOT NULL,
    
    CONSTRAINT FK_LoPhieu_NhanVien FOREIGN KEY (NguoiTao) REFERENCES NhanVien(MaNV),
    CONSTRAINT CK_LoPhieu_LoaiVe CHECK (LoaiVe IN (N'V? Ng?y', N'V? Th?ng')),
    CONSTRAINT CK_LoPhieu_TuDenSo CHECK (DenSo > TuSo),
    CONSTRAINT CK_LoPhieu_TrangThai CHECK (TrangThai IN (N'?ang S? D?ng', N'H?t Phi?u', N'T?m Ng?ng'))
);
GO

-- =============================================
-- Table: PhieuXe (Parking Tickets)
-- Description: Phi?u g?i xe (v? ?o)
-- =============================================
CREATE TABLE PhieuXe (
    MaPhieu INT IDENTITY(1,1) PRIMARY KEY,
    SoPhieu VARCHAR(20) NOT NULL UNIQUE, -- #VX-001, #VT-101
    MaLo INT NOT NULL,
    BienSo VARCHAR(20) NOT NULL,
    LoaiXe NVARCHAR(20) NOT NULL,
    LoaiVe NVARCHAR(20) NOT NULL,
    TenChuXe NVARCHAR(100),
    SDTChuXe VARCHAR(15),
    ViTriDo NVARCHAR(20),
    ThoiGianVao DATETIME NOT NULL DEFAULT GETDATE(),
    ThoiGianRa DATETIME NULL,
    ThoiGianHetHan DATETIME NULL,
    GiaVe DECIMAL(18,0) NOT NULL,
    TrangThai NVARCHAR(20) NOT NULL DEFAULT N'?ang G?i',
    NhanVienPhat INT NOT NULL,
    NhanVienThu INT NULL,
    GhiChu NVARCHAR(500),
    
    CONSTRAINT FK_PhieuXe_LoPhieu FOREIGN KEY (MaLo) REFERENCES LoPhieu(MaLo),
    CONSTRAINT FK_PhieuXe_NhanVienPhat FOREIGN KEY (NhanVienPhat) REFERENCES NhanVien(MaNV),
    CONSTRAINT FK_PhieuXe_NhanVienThu FOREIGN KEY (NhanVienThu) REFERENCES NhanVien(MaNV),
    CONSTRAINT CK_PhieuXe_LoaiXe CHECK (LoaiXe IN (N'Xe ??p', N'Xe M?y', N'? T?')),
    CONSTRAINT CK_PhieuXe_LoaiVe CHECK (LoaiVe IN (N'V? Ng?y', N'V? Th?ng', N'Mi?n Ph?')),
    CONSTRAINT CK_PhieuXe_TrangThai CHECK (TrangThai IN (N'?ang G?i', N'?? Tr? Xe', N'H?t H?n', N'?? H?y'))
);
GO

-- =============================================
-- Table: LichSuThanhToan (Payment History)
-- Description: L?ch s? thanh to?n khi tr? xe
-- =============================================
CREATE TABLE LichSuThanhToan (
    MaThanhToan INT IDENTITY(1,1) PRIMARY KEY,
    MaPhieu INT NOT NULL,
    SoTien DECIMAL(18,0) NOT NULL,
    PhuongThucThanhToan NVARCHAR(50) NOT NULL DEFAULT N'Ti?n M?t',
    ThoiGianThanhToan DATETIME NOT NULL DEFAULT GETDATE(),
    NhanVienThu INT NOT NULL,
    GhiChu NVARCHAR(500),
    
    CONSTRAINT FK_LichSuThanhToan_PhieuXe FOREIGN KEY (MaPhieu) REFERENCES PhieuXe(MaPhieu),
    CONSTRAINT FK_LichSuThanhToan_NhanVien FOREIGN KEY (NhanVienThu) REFERENCES NhanVien(MaNV),
    CONSTRAINT CK_LichSuThanhToan_PhuongThuc CHECK (PhuongThucThanhToan IN (N'Ti?n M?t', N'Chuy?n Kho?n', N'V? ?i?n T?'))
);
GO

-- =============================================
-- Table: NgoaiLe (Exception Handling)
-- Description: X? l? c?c tr??ng h?p ngo?i l?
-- =============================================
CREATE TABLE NgoaiLe (
    MaNgoaiLe INT IDENTITY(1,1) PRIMARY KEY,
    MaPhieu INT NOT NULL,
    LoaiNgoaiLe NVARCHAR(50) NOT NULL,
    MoTa NVARCHAR(500),
    BienPhapXuLy NVARCHAR(500),
    ThoiGian DATETIME NOT NULL DEFAULT GETDATE(),
    NguoiXuLy INT NOT NULL,
    TrangThai NVARCHAR(20) NOT NULL DEFAULT N'?ang X? L?',
    
    CONSTRAINT FK_NgoaiLe_PhieuXe FOREIGN KEY (MaPhieu) REFERENCES PhieuXe(MaPhieu),
    CONSTRAINT FK_NgoaiLe_NhanVien FOREIGN KEY (NguoiXuLy) REFERENCES NhanVien(MaNV),
    CONSTRAINT CK_NgoaiLe_LoaiNgoaiLe CHECK (LoaiNgoaiLe IN (N'Phi?u M?t', N'Sai Lo?i Xe', N'Phi?u Kh?ng H?p L?', N'Kh?c')),
    CONSTRAINT CK_NgoaiLe_TrangThai CHECK (TrangThai IN (N'?ang X? L?', N'?? X? L?', N'Ch?a X? L?'))
);
GO

-- =============================================
-- Create Indexes for Performance
-- =============================================

-- Index for PhieuXe
CREATE NONCLUSTERED INDEX IX_PhieuXe_BienSo ON PhieuXe(BienSo);
CREATE NONCLUSTERED INDEX IX_PhieuXe_SoPhieu ON PhieuXe(SoPhieu);
CREATE NONCLUSTERED INDEX IX_PhieuXe_TrangThai ON PhieuXe(TrangThai);
CREATE NONCLUSTERED INDEX IX_PhieuXe_ThoiGianVao ON PhieuXe(ThoiGianVao DESC);
CREATE NONCLUSTERED INDEX IX_PhieuXe_NhanVienPhat ON PhieuXe(NhanVienPhat);
GO

-- Index for LichSuThanhToan
CREATE NONCLUSTERED INDEX IX_LichSuThanhToan_MaPhieu ON LichSuThanhToan(MaPhieu);
CREATE NONCLUSTERED INDEX IX_LichSuThanhToan_ThoiGian ON LichSuThanhToan(ThoiGianThanhToan DESC);
GO

-- Index for NhanVien
CREATE NONCLUSTERED INDEX IX_NhanVien_TrangThai ON NhanVien(TrangThai);
GO

-- =============================================
-- Create Views
-- =============================================

-- View: V? ?ang g?i
CREATE VIEW vw_VeDangGui
AS
SELECT 
    p.MaPhieu,
    p.SoPhieu,
    p.BienSo,
    p.LoaiXe,
    p.LoaiVe,
    p.TenChuXe,
    p.ViTriDo,
    p.ThoiGianVao,
    p.ThoiGianHetHan,
    p.GiaVe,
    p.TrangThai,
    nv.TenNV AS NhanVienPhat,
    CASE 
        WHEN p.LoaiVe = N'V? Th?ng' AND p.ThoiGianHetHan IS NOT NULL 
        THEN DATEDIFF(DAY, GETDATE(), p.ThoiGianHetHan)
        ELSE NULL
    END AS SoNgayConLai
FROM PhieuXe p
INNER JOIN NhanVien nv ON p.NhanVienPhat = nv.MaNV
WHERE p.TrangThai = N'?ang G?i';
GO

-- View: Th?ng k? theo ng?y
CREATE VIEW vw_ThongKeTheoNgay
AS
SELECT 
    CAST(ThoiGianVao AS DATE) AS Ngay,
    LoaiXe,
    LoaiVe,
    COUNT(*) AS SoLuong,
    SUM(GiaVe) AS TongDoanhThu
FROM PhieuXe
WHERE TrangThai IN (N'?ang G?i', N'?? Tr? Xe')
GROUP BY CAST(ThoiGianVao AS DATE), LoaiXe, LoaiVe;
GO

-- View: Doanh thu theo nh?n vi?n
CREATE VIEW vw_DoanhThuTheoNhanVien
AS
SELECT 
    nv.MaNV,
    nv.TenNV,
    COUNT(p.MaPhieu) AS SoPhieuPhat,
    SUM(p.GiaVe) AS TongDoanhThu,
    CAST(p.ThoiGianVao AS DATE) AS Ngay
FROM NhanVien nv
LEFT JOIN PhieuXe p ON nv.MaNV = p.NhanVienPhat
WHERE p.TrangThai IN (N'?ang G?i', N'?? Tr? Xe')
GROUP BY nv.MaNV, nv.TenNV, CAST(p.ThoiGianVao AS DATE);
GO

-- =============================================
-- Create Stored Procedures
-- =============================================

-- Procedure: Ph?t phi?u xe v?o
CREATE PROCEDURE sp_PhatPhieuXeVao
    @BienSo VARCHAR(20),
    @LoaiXe NVARCHAR(20),
    @LoaiVe NVARCHAR(20),
    @TenChuXe NVARCHAR(100) = NULL,
    @SDTChuXe VARCHAR(15) = NULL,
    @ViTriDo NVARCHAR(20) = NULL,
    @NhanVienPhat INT,
    @MaPhieu INT OUTPUT,
    @SoPhieu VARCHAR(20) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @MaLo INT;
    DECLARE @GiaVe DECIMAL(18,0);
    DECLARE @ThoiGianHetHan DATETIME = NULL;
    DECLARE @SoPhieuMoi INT;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- L?y gi? v?
        SELECT TOP 1 @GiaVe = GiaTien 
        FROM GiaVe 
        WHERE LoaiXe = @LoaiXe 
          AND LoaiVe = @LoaiVe 
          AND TrangThai = N'?ang ?p D?ng'
          AND NgayApDung <= CAST(GETDATE() AS DATE)
          AND (NgayKetThuc IS NULL OR NgayKetThuc >= CAST(GETDATE() AS DATE));
        
        IF @GiaVe IS NULL
            THROW 50001, N'Kh?ng t?m th?y gi? v? ph? h?p', 1;
        
        -- L?y l? phi?u ?ang s? d?ng
        SELECT TOP 1 @MaLo = MaLo
        FROM LoPhieu
        WHERE LoaiVe = @LoaiVe 
          AND TrangThai = N'?ang S? D?ng'
          AND SoLuongConLai > 0
        ORDER BY MaLo;
        
        IF @MaLo IS NULL
            THROW 50002, N'Kh?ng c?n phi?u trong l?', 1;
        
        -- T?nh th?i gian h?t h?n
        IF @LoaiVe = N'V? Ng?y'
            SET @ThoiGianHetHan = CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST('23:59:59' AS DATETIME);
        ELSE IF @LoaiVe = N'V? Th?ng'
            SET @ThoiGianHetHan = DATEADD(DAY, 30, GETDATE());
        
        -- T?o s? phi?u
        SELECT @SoPhieuMoi = TuSo + SoLuongPhat FROM LoPhieu WHERE MaLo = @MaLo;
        
        IF @LoaiVe = N'V? Ng?y'
            SET @SoPhieu = '#VX-' + RIGHT('000' + CAST(@SoPhieuMoi AS VARCHAR), 3);
        ELSE
            SET @SoPhieu = '#VT-' + RIGHT('000' + CAST(@SoPhieuMoi AS VARCHAR), 3);
        
        -- Th?m phi?u m?i
        INSERT INTO PhieuXe (SoPhieu, MaLo, BienSo, LoaiXe, LoaiVe, TenChuXe, SDTChuXe, ViTriDo, ThoiGianHetHan, GiaVe, NhanVienPhat)
        VALUES (@SoPhieu, @MaLo, @BienSo, @LoaiXe, @LoaiVe, @TenChuXe, @SDTChuXe, @ViTriDo, @ThoiGianHetHan, @GiaVe, @NhanVienPhat);
        
        SET @MaPhieu = SCOPE_IDENTITY();
        
        -- C?p nh?t l? phi?u
        UPDATE LoPhieu
        SET SoLuongPhat = SoLuongPhat + 1,
            SoLuongConLai = SoLuongConLai - 1,
            TrangThai = CASE WHEN SoLuongConLai - 1 = 0 THEN N'H?t Phi?u' ELSE TrangThai END
        WHERE MaLo = @MaLo;
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        THROW;
    END CATCH
END;
GO

-- Procedure: Thu phi?u xe ra
CREATE PROCEDURE sp_ThuPhieuXeRa
    @MaPhieu INT = NULL,
    @SoPhieu VARCHAR(20) = NULL,
    @BienSo VARCHAR(20) = NULL,
    @NhanVienThu INT,
    @PhuongThucThanhToan NVARCHAR(50) = N'Ti?n M?t',
    @SoTienThanhToan DECIMAL(18,0) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @MaPhieuTim INT;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- T?m phi?u
        IF @MaPhieu IS NOT NULL
            SET @MaPhieuTim = @MaPhieu;
        ELSE IF @SoPhieu IS NOT NULL
            SELECT @MaPhieuTim = MaPhieu FROM PhieuXe WHERE SoPhieu = @SoPhieu;
        ELSE IF @BienSo IS NOT NULL
            SELECT TOP 1 @MaPhieuTim = MaPhieu FROM PhieuXe WHERE BienSo = @BienSo AND TrangThai = N'?ang G?i' ORDER BY ThoiGianVao DESC;
        
        IF @MaPhieuTim IS NULL
            THROW 50003, N'Kh?ng t?m th?y phi?u', 1;
        
        -- L?y s? ti?n c?n thanh to?n
        SELECT @SoTienThanhToan = GiaVe FROM PhieuXe WHERE MaPhieu = @MaPhieuTim;
        
        -- C?p nh?t phi?u
        UPDATE PhieuXe
        SET ThoiGianRa = GETDATE(),
            TrangThai = N'?? Tr? Xe',
            NhanVienThu = @NhanVienThu
        WHERE MaPhieu = @MaPhieuTim;
        
        -- Th?m l?ch s? thanh to?n
        INSERT INTO LichSuThanhToan (MaPhieu, SoTien, PhuongThucThanhToan, NhanVienThu)
        VALUES (@MaPhieuTim, @SoTienThanhToan, @PhuongThucThanhToan, @NhanVienThu);
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        THROW;
    END CATCH
END;
GO

-- Procedure: T?o l? phi?u m?i
CREATE PROCEDURE sp_TaoLoPhieu
    @TenLo NVARCHAR(100),
    @TuSo INT,
    @DenSo INT,
    @LoaiVe NVARCHAR(20),
    @NguoiTao INT,
    @MaLo INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @SoLuong INT = @DenSo - @TuSo + 1;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        INSERT INTO LoPhieu (TenLo, TuSo, DenSo, LoaiVe, SoLuongConLai, NguoiTao)
        VALUES (@TenLo, @TuSo, @DenSo, @LoaiVe, @SoLuong, @NguoiTao);
        
        SET @MaLo = SCOPE_IDENTITY();
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        THROW;
    END CATCH
END;
GO

-- =============================================
-- Create Functions
-- =============================================

-- Function: T?nh doanh thu theo ng?y
CREATE FUNCTION fn_DoanhThuTheoNgay(@Ngay DATE)
RETURNS DECIMAL(18,0)
AS
BEGIN
    DECLARE @DoanhThu DECIMAL(18,0);
    
    SELECT @DoanhThu = ISNULL(SUM(GiaVe), 0)
    FROM PhieuXe
    WHERE CAST(ThoiGianVao AS DATE) = @Ngay
      AND TrangThai IN (N'?ang G?i', N'?? Tr? Xe');
    
    RETURN @DoanhThu;
END;
GO

-- Function: ??m s? v? ?ang g?i
CREATE FUNCTION fn_DemVeDangGui()
RETURNS INT
AS
BEGIN
    DECLARE @SoLuong INT;
    
    SELECT @SoLuong = COUNT(*)
    FROM PhieuXe
    WHERE TrangThai = N'?ang G?i';
    
    RETURN @SoLuong;
END;
GO

PRINT N'? Database schema created successfully!';
PRINT N'? Next step: Run ParkingTicketDB_SampleData.sql to insert sample data.';
GO
