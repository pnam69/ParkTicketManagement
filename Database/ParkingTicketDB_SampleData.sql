-- =============================================
-- Parking Ticket Management System - Sample Data
-- SQL Server 2019+
-- Created: 2024-12-23
-- =============================================

USE ParkingTicketDB;
GO

PRINT N'?? Inserting sample data...';
GO

-- =============================================
-- 1. Insert Sample Employees (NhanVien)
-- =============================================
PRINT N'?? Inserting employees...';

INSERT INTO NhanVien (TenNV, SDT, Email, VaiTro, MatKhau, TrangThai)
VALUES 
    (N'Nguy?n V?n An', '0901234567', 'an.nguyen@parking.vn', N'Qu?n L?', 'hashed_password_1', N'Ho?t ??ng'),
    (N'Tr?n Th? B?nh', '0912345678', 'binh.tran@parking.vn', N'Thu Ng?n', 'hashed_password_2', N'Ho?t ??ng'),
    (N'L? V?n C??ng', '0923456789', 'cuong.le@parking.vn', N'Thu Ng?n', 'hashed_password_3', N'Ho?t ??ng'),
    (N'Ph?m Th? Dung', '0934567890', 'dung.pham@parking.vn', N'B?o V?', 'hashed_password_4', N'Ho?t ??ng'),
    (N'Ho?ng V?n Em', '0945678901', 'em.hoang@parking.vn', N'B?o V?', 'hashed_password_5', N'Ho?t ??ng'),
    (N'V? Th? Ph??ng', '0956789012', 'phuong.vu@parking.vn', N'Thu Ng?n', 'hashed_password_6', N'T?m Ngh?');
GO

PRINT N'? ' + CAST(@@ROWCOUNT AS NVARCHAR(10)) + N' employees inserted.';
GO

-- =============================================
-- 2. Insert Ticket Pricing (GiaVe)
-- =============================================
PRINT N'?? Inserting ticket pricing...';

INSERT INTO GiaVe (LoaiXe, LoaiVe, GiaTien, NgayApDung, TrangThai, GhiChu)
VALUES 
    (N'Xe ??p', N'V? Ng?y', 2000, '2024-01-01', N'?ang ?p D?ng', N'Gi? v? ng?y xe ??p'),
    (N'Xe ??p', N'V? Th?ng', 50000, '2024-01-01', N'?ang ?p D?ng', N'Gi? v? th?ng xe ??p'),
    (N'Xe M?y', N'V? Ng?y', 3000, '2024-01-01', N'?ang ?p D?ng', N'Gi? v? ng?y xe m?y'),
    (N'Xe M?y', N'V? Th?ng', 50000, '2024-01-01', N'?ang ?p D?ng', N'Gi? v? th?ng xe m?y'),
    (N'? T?', N'Mi?n Ph?', 0, '2024-01-01', N'?ang ?p D?ng', N'Mi?n ph? cho gi?ng vi?n');
GO

PRINT N'? ' + CAST(@@ROWCOUNT AS NVARCHAR(10)) + N' pricing records inserted.';
GO

-- =============================================
-- 3. Create Ticket Batches (LoPhieu)
-- =============================================
PRINT N'?? Creating ticket batches...';

DECLARE @MaNVQuanLy INT = (SELECT TOP 1 MaNV FROM NhanVien WHERE VaiTro = N'Qu?n L?');

INSERT INTO LoPhieu (TenLo, TuSo, DenSo, LoaiVe, SoLuongPhat, SoLuongConLai, TrangThai, NguoiTao)
VALUES 
    (N'L? V? Ng?y 001', 1, 500, N'V? Ng?y', 50, 450, N'?ang S? D?ng', @MaNVQuanLy),
    (N'L? V? Th?ng 001', 101, 300, N'V? Th?ng', 20, 180, N'?ang S? D?ng', @MaNVQuanLy),
    (N'L? V? Ng?y 002', 501, 1000, N'V? Ng?y', 0, 500, N'?ang S? D?ng', @MaNVQuanLy);
GO

PRINT N'? ' + CAST(@@ROWCOUNT AS NVARCHAR(10)) + N' ticket batches created.';
GO

-- =============================================
-- 4. Insert Sample Parking Tickets (PhieuXe)
-- =============================================
PRINT N'?? Inserting parking tickets...';

DECLARE @MaLoVeNgay INT = (SELECT TOP 1 MaLo FROM LoPhieu WHERE LoaiVe = N'V? Ng?y' AND TrangThai = N'?ang S? D?ng');
DECLARE @MaLoVeThang INT = (SELECT TOP 1 MaLo FROM LoPhieu WHERE LoaiVe = N'V? Th?ng' AND TrangThai = N'?ang S? D?ng');
DECLARE @MaNVThuNgan INT = (SELECT TOP 1 MaNV FROM NhanVien WHERE VaiTro = N'Thu Ng?n' AND TrangThai = N'Ho?t ??ng');

-- V? ng?y ?ang g?i
INSERT INTO PhieuXe (SoPhieu, MaLo, BienSo, LoaiXe, LoaiVe, TenChuXe, SDTChuXe, ViTriDo, ThoiGianVao, ThoiGianHetHan, GiaVe, TrangThai, NhanVienPhat)
VALUES 
    ('#VX-001', @MaLoVeNgay, '29A-12345', N'Xe M?y', N'V? Ng?y', N'Nguy?n V?n A', '0901111111', 'A1', 
     DATEADD(HOUR, -2, GETDATE()), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST('23:59:59' AS DATETIME), 
     3000, N'?ang G?i', @MaNVThuNgan),
    
    ('#VX-002', @MaLoVeNgay, '30G-56789', N'Xe ??p', N'V? Ng?y', N'Tr?n Th? B', '0902222222', 'A5', 
     DATEADD(HOUR, -1, GETDATE()), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST('23:59:59' AS DATETIME), 
     2000, N'?ang G?i', @MaNVThuNgan),
    
    ('#VX-003', @MaLoVeNgay, '51B-11111', N'? T?', N'Mi?n Ph?', N'GS. L? V?n C', '0903333333', 'B2', 
     DATEADD(HOUR, -3, GETDATE()), NULL, 
     0, N'?ang G?i', @MaNVThuNgan);

-- V? th?ng ?ang g?i
INSERT INTO PhieuXe (SoPhieu, MaLo, BienSo, LoaiXe, LoaiVe, TenChuXe, SDTChuXe, ViTriDo, ThoiGianVao, ThoiGianHetHan, GiaVe, TrangThai, NhanVienPhat)
VALUES 
    ('#VT-101', @MaLoVeThang, '29B-22222', N'Xe M?y', N'V? Th?ng', N'Ph?m V?n D', '0904444444', 'A3', 
     DATEADD(DAY, -15, GETDATE()), DATEADD(DAY, 15, GETDATE()), 
     50000, N'?ang G?i', @MaNVThuNgan),
    
    ('#VT-102', @MaLoVeThang, '30C-33333', N'Xe ??p', N'V? Th?ng', N'Ho?ng Th? E', '0905555555', 'A8', 
     DATEADD(DAY, -15, GETDATE()), DATEADD(DAY, 15, GETDATE()), 
     50000, N'?ang G?i', @MaNVThuNgan),
    
    ('#VT-103', @MaLoVeThang, '29D-44444', N'Xe M?y', N'V? Th?ng', N'V? V?n F', '0906666666', 'A12', 
     DATEADD(DAY, -11, GETDATE()), DATEADD(DAY, 19, GETDATE()), 
     50000, N'?ang G?i', @MaNVThuNgan);

-- V? th?ng h?t h?n
INSERT INTO PhieuXe (SoPhieu, MaLo, BienSo, LoaiXe, LoaiVe, TenChuXe, SDTChuXe, ViTriDo, ThoiGianVao, ThoiGianHetHan, GiaVe, TrangThai, NhanVienPhat)
VALUES 
    ('#VT-098', @MaLoVeThang, '51A-99999', N'Xe ??p', N'V? Th?ng', N'??ng V?n G', '0907777777', 'A15', 
     DATEADD(DAY, -60, GETDATE()), DATEADD(DAY, -30, GETDATE()), 
     50000, N'H?t H?n', @MaNVThuNgan);

-- V? ?? tr? (l?ch s?)
INSERT INTO PhieuXe (SoPhieu, MaLo, BienSo, LoaiXe, LoaiVe, TenChuXe, ThoiGianVao, ThoiGianRa, ThoiGianHetHan, GiaVe, TrangThai, NhanVienPhat, NhanVienThu)
VALUES 
    ('#VX-004', @MaLoVeNgay, '29E-55555', N'Xe M?y', N'V? Ng?y', N'B?i Th? H', 
     DATEADD(HOUR, -8, GETDATE()), DATEADD(HOUR, -2, GETDATE()), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST('23:59:59' AS DATETIME), 
     3000, N'?? Tr? Xe', @MaNVThuNgan, @MaNVThuNgan),
    
    ('#VX-005', @MaLoVeNgay, '30F-66666', N'Xe ??p', N'V? Ng?y', N'Mai V?n I', 
     DATEADD(HOUR, -10, GETDATE()), DATEADD(HOUR, -4, GETDATE()), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST('23:59:59' AS DATETIME), 
     2000, N'?? Tr? Xe', @MaNVThuNgan, @MaNVThuNgan);
GO

PRINT N'? ' + CAST(@@ROWCOUNT AS NVARCHAR(10)) + N' parking tickets inserted.';
GO

-- =============================================
-- 5. Insert Payment History (LichSuThanhToan)
-- =============================================
PRINT N'?? Inserting payment history...';

INSERT INTO LichSuThanhToan (MaPhieu, SoTien, PhuongThucThanhToan, ThoiGianThanhToan, NhanVienThu)
SELECT 
    MaPhieu, 
    GiaVe, 
    N'Ti?n M?t', 
    ThoiGianRa, 
    NhanVienThu
FROM PhieuXe
WHERE TrangThai = N'?? Tr? Xe' AND ThoiGianRa IS NOT NULL;
GO

PRINT N'? ' + CAST(@@ROWCOUNT AS NVARCHAR(10)) + N' payment records inserted.';
GO

-- =============================================
-- 6. Insert Sample Exceptions (NgoaiLe)
-- =============================================
PRINT N'?? Inserting exception records...';

DECLARE @MaPhieuMau INT = (SELECT TOP 1 MaPhieu FROM PhieuXe WHERE TrangThai = N'?ang G?i');
DECLARE @MaNVXuLy INT = (SELECT TOP 1 MaNV FROM NhanVien WHERE VaiTro = N'Qu?n L?');

INSERT INTO NgoaiLe (MaPhieu, LoaiNgoaiLe, MoTa, BienPhapXuLy, NguoiXuLy, TrangThai)
VALUES 
    (@MaPhieuMau, N'Phi?u M?t', N'Kh?ch h?ng b?o m?t phi?u xe', N'X?c minh bi?n s? v? th?ng tin, c?p phi?u m?i', @MaNVXuLy, N'?? X? L?');
GO

PRINT N'? ' + CAST(@@ROWCOUNT AS NVARCHAR(10)) + N' exception records inserted.';
GO

-- =============================================
-- 7. Display Summary Statistics
-- =============================================
PRINT N'';
PRINT N'?? ===== DATABASE SUMMARY =====';
PRINT N'';

PRINT N'?? Employees: ' + CAST((SELECT COUNT(*) FROM NhanVien) AS NVARCHAR(10));
PRINT N'?? Pricing Records: ' + CAST((SELECT COUNT(*) FROM GiaVe) AS NVARCHAR(10));
PRINT N'?? Ticket Batches: ' + CAST((SELECT COUNT(*) FROM LoPhieu) AS NVARCHAR(10));
PRINT N'?? Total Tickets: ' + CAST((SELECT COUNT(*) FROM PhieuXe) AS NVARCHAR(10));
PRINT N'   - ?ang G?i: ' + CAST((SELECT COUNT(*) FROM PhieuXe WHERE TrangThai = N'?ang G?i') AS NVARCHAR(10));
PRINT N'   - ?? Tr? Xe: ' + CAST((SELECT COUNT(*) FROM PhieuXe WHERE TrangThai = N'?? Tr? Xe') AS NVARCHAR(10));
PRINT N'   - H?t H?n: ' + CAST((SELECT COUNT(*) FROM PhieuXe WHERE TrangThai = N'H?t H?n') AS NVARCHAR(10));
PRINT N'?? Payment Records: ' + CAST((SELECT COUNT(*) FROM LichSuThanhToan) AS NVARCHAR(10));
PRINT N'?? Exception Records: ' + CAST((SELECT COUNT(*) FROM NgoaiLe) AS NVARCHAR(10));

PRINT N'';
PRINT N'? ===== SAMPLE DATA INSERTED SUCCESSFULLY! =====';
PRINT N'';
PRINT N'?? Default Test Accounts:';
PRINT N'   - Manager: an.nguyen@parking.vn (password: hashed_password_1)';
PRINT N'   - Cashier: binh.tran@parking.vn (password: hashed_password_2)';
PRINT N'';
PRINT N'?? You can now run queries or connect your application!';
GO
