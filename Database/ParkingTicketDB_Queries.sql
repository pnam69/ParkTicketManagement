-- =============================================
-- Parking Ticket Management System - Useful Queries
-- SQL Server 2019+
-- =============================================

USE ParkingTicketDB;
GO

-- =============================================
-- 1. BASIC QUERIES
-- =============================================

-- Xem t?t c? v? ?ang g?i
SELECT * FROM vw_VeDangGui ORDER BY ThoiGianVao DESC;
GO

-- ??m s? v? theo tr?ng th?i
SELECT 
    TrangThai,
    COUNT(*) AS SoLuong
FROM PhieuXe
GROUP BY TrangThai;
GO

-- Th?ng k? theo lo?i xe
SELECT 
    LoaiXe,
    COUNT(*) AS SoLuong,
    SUM(GiaVe) AS TongDoanhThu
FROM PhieuXe
WHERE TrangThai IN (N'?ang G?i', N'?? Tr? Xe')
GROUP BY LoaiXe;
GO

-- =============================================
-- 2. SEARCH QUERIES
-- =============================================

-- T?m v? theo bi?n s?
DECLARE @BienSo VARCHAR(20) = '29A-12345';
SELECT * FROM PhieuXe WHERE BienSo = @BienSo ORDER BY ThoiGianVao DESC;
GO

-- T?m v? theo s? phi?u
DECLARE @SoPhieu VARCHAR(20) = '#VX-001';
SELECT * FROM PhieuXe WHERE SoPhieu = @SoPhieu;
GO

-- T?m v? theo t?n ch? xe
DECLARE @TenChuXe NVARCHAR(100) = N'%Nguy?n%';
SELECT * FROM PhieuXe WHERE TenChuXe LIKE @TenChuXe ORDER BY ThoiGianVao DESC;
GO

-- =============================================
-- 3. STATISTICS & REPORTS
-- =============================================

-- Doanh thu h?m nay
SELECT 
    CAST(GETDATE() AS DATE) AS Ngay,
    COUNT(*) AS SoVe,
    SUM(GiaVe) AS TongDoanhThu
FROM PhieuXe
WHERE CAST(ThoiGianVao AS DATE) = CAST(GETDATE() AS DATE)
  AND TrangThai IN (N'?ang G?i', N'?? Tr? Xe');
GO

-- Doanh thu theo th?ng
SELECT 
    YEAR(ThoiGianVao) AS Nam,
    MONTH(ThoiGianVao) AS Thang,
    COUNT(*) AS SoVe,
    SUM(GiaVe) AS TongDoanhThu
FROM PhieuXe
WHERE TrangThai IN (N'?ang G?i', N'?? Tr? Xe')
GROUP BY YEAR(ThoiGianVao), MONTH(ThoiGianVao)
ORDER BY Nam DESC, Thang DESC;
GO

-- Th?ng k? theo nh?n vi?n (th?ng n?y)
SELECT 
    nv.TenNV,
    nv.VaiTro,
    COUNT(p.MaPhieu) AS SoVePhat,
    SUM(p.GiaVe) AS TongDoanhThu
FROM NhanVien nv
LEFT JOIN PhieuXe p ON nv.MaNV = p.NhanVienPhat
WHERE MONTH(p.ThoiGianVao) = MONTH(GETDATE())
  AND YEAR(p.ThoiGianVao) = YEAR(GETDATE())
GROUP BY nv.MaNV, nv.TenNV, nv.VaiTro
ORDER BY TongDoanhThu DESC;
GO

-- Top 10 kh?ch h?ng g?i xe nhi?u nh?t
SELECT TOP 10
    TenChuXe,
    BienSo,
    COUNT(*) AS SoLanGui,
    SUM(GiaVe) AS TongChiTieu
FROM PhieuXe
WHERE TenChuXe IS NOT NULL
GROUP BY TenChuXe, BienSo
ORDER BY SoLanGui DESC;
GO

-- =============================================
-- 4. TICKET MANAGEMENT QUERIES
-- =============================================

-- V? s?p h?t h?n (c?n 7 ng?y)
SELECT 
    SoPhieu,
    BienSo,
    TenChuXe,
    LoaiXe,
    ThoiGianHetHan,
    DATEDIFF(DAY, GETDATE(), ThoiGianHetHan) AS SoNgayConLai
FROM PhieuXe
WHERE TrangThai = N'?ang G?i'
  AND LoaiVe = N'V? Th?ng'
  AND ThoiGianHetHan IS NOT NULL
  AND DATEDIFF(DAY, GETDATE(), ThoiGianHetHan) BETWEEN 0 AND 7
ORDER BY ThoiGianHetHan;
GO

-- T? ??ng c?p nh?t tr?ng th?i v? h?t h?n
UPDATE PhieuXe
SET TrangThai = N'H?t H?n'
WHERE TrangThai = N'?ang G?i'
  AND ThoiGianHetHan IS NOT NULL
  AND ThoiGianHetHan < GETDATE();
GO

-- V? tr? ?? xe tr?ng (gi? s? c? 50 v? tr? A1-A50)
WITH AllPositions AS (
    SELECT 'A' + CAST(n AS VARCHAR) AS ViTri
    FROM (VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10),
                 (11),(12),(13),(14),(15),(16),(17),(18),(19),(20),
                 (21),(22),(23),(24),(25),(26),(27),(28),(29),(30),
                 (31),(32),(33),(34),(35),(36),(37),(38),(39),(40),
                 (41),(42),(43),(44),(45),(46),(47),(48),(49),(50)) AS Numbers(n)
)
SELECT ap.ViTri, 'Tr?ng' AS TrangThai
FROM AllPositions ap
WHERE NOT EXISTS (
    SELECT 1 FROM PhieuXe p 
    WHERE p.ViTriDo = ap.ViTri 
      AND p.TrangThai = N'?ang G?i'
)
ORDER BY ap.ViTri;
GO

-- =============================================
-- 5. STORED PROCEDURE EXAMPLES
-- =============================================

-- Ph?t phi?u m?i (Xe v?o)
DECLARE @MaPhieu INT, @SoPhieu VARCHAR(20);
EXEC sp_PhatPhieuXeVao 
    @BienSo = '29Z-99999',
    @LoaiXe = N'Xe M?y',
    @LoaiVe = N'V? Ng?y',
    @TenChuXe = N'Test User',
    @SDTChuXe = '0909999999',
    @ViTriDo = 'A1',
    @NhanVienPhat = 2,
    @MaPhieu = @MaPhieu OUTPUT,
    @SoPhieu = @SoPhieu OUTPUT;

SELECT @MaPhieu AS MaPhieu, @SoPhieu AS SoPhieu;
GO

-- Thu phi?u (Xe ra)
DECLARE @SoTien DECIMAL(18,0);
EXEC sp_ThuPhieuXeRa
    @SoPhieu = '#VX-001',
    @NhanVienThu = 2,
    @PhuongThucThanhToan = N'Ti?n M?t',
    @SoTienThanhToan = @SoTien OUTPUT;

SELECT @SoTien AS SoTienThanhToan;
GO

-- T?o l? phi?u m?i
DECLARE @MaLo INT;
EXEC sp_TaoLoPhieu
    @TenLo = N'L? V? Ng?y 003',
    @TuSo = 1001,
    @DenSo = 1500,
    @LoaiVe = N'V? Ng?y',
    @NguoiTao = 1,
    @MaLo = @MaLo OUTPUT;

SELECT @MaLo AS MaLoMoi;
GO

-- =============================================
-- 6. MAINTENANCE QUERIES
-- =============================================

-- Ki?m tra to?n v?n d? li?u
SELECT 
    'Phi?u kh?ng c? nh?n vi?n ph?t' AS VanDe,
    COUNT(*) AS SoLuong
FROM PhieuXe 
WHERE NhanVienPhat IS NULL
UNION ALL
SELECT 
    'Phi?u ?? tr? kh?ng c? th?i gian ra',
    COUNT(*)
FROM PhieuXe 
WHERE TrangThai = N'?? Tr? Xe' AND ThoiGianRa IS NULL
UNION ALL
SELECT 
    'L? phi?u kh?ng nh?t qu?n',
    COUNT(*)
FROM LoPhieu
WHERE SoLuongPhat > (DenSo - TuSo + 1);
GO

-- X?a d? li?u c? (c?n th?n!)
-- X?a phi?u ?? tr? tr?n 1 n?m
DELETE FROM LichSuThanhToan 
WHERE MaPhieu IN (
    SELECT MaPhieu FROM PhieuXe 
    WHERE TrangThai = N'?? Tr? Xe' 
      AND ThoiGianRa < DATEADD(YEAR, -1, GETDATE())
);

DELETE FROM PhieuXe 
WHERE TrangThai = N'?? Tr? Xe' 
  AND ThoiGianRa < DATEADD(YEAR, -1, GETDATE());
GO

-- =============================================
-- 7. PERFORMANCE MONITORING
-- =============================================

-- Ki?m tra k?ch th??c b?ng
SELECT 
    t.NAME AS TableName,
    p.rows AS RowCounts,
    SUM(a.total_pages) * 8 AS TotalSpaceKB,
    SUM(a.used_pages) * 8 AS UsedSpaceKB,
    (SUM(a.total_pages) - SUM(a.used_pages)) * 8 AS UnusedSpaceKB
FROM sys.tables t
INNER JOIN sys.indexes i ON t.OBJECT_ID = i.object_id
INNER JOIN sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id
WHERE t.is_ms_shipped = 0
GROUP BY t.Name, p.Rows
ORDER BY TotalSpaceKB DESC;
GO

-- Ki?m tra index fragmentation
SELECT 
    OBJECT_NAME(ips.object_id) AS TableName,
    i.name AS IndexName,
    ips.index_type_desc,
    ips.avg_fragmentation_in_percent,
    ips.page_count
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') ips
INNER JOIN sys.indexes i ON ips.object_id = i.object_id AND ips.index_id = i.index_id
WHERE ips.avg_fragmentation_in_percent > 10
  AND ips.page_count > 100
ORDER BY ips.avg_fragmentation_in_percent DESC;
GO

PRINT N'? Query examples loaded successfully!';
PRINT N'?? Run these queries to test your database.';
GO
