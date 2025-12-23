# ??? Parking Ticket Management System - Database Documentation

## ?? Table of Contents
1. [Overview](#overview)
2. [Database Schema](#database-schema)
3. [Installation Guide](#installation-guide)
4. [Usage Examples](#usage-examples)
5. [Maintenance](#maintenance)

---

## ?? Overview

This database supports the **Virtual Parking Ticket Management System** for managing parking operations at schools, apartments, or public parking lots.

### Key Features:
- ? **3 Vehicle Types:** Bikes (Xe ??p), Motorcycles (Xe m?y), Cars (? t?)
- ? **2 Ticket Types:** Daily tickets (V? ng?y), Monthly tickets (V? th?ng)
- ? **Employee Management:** Cashiers, Security guards, Managers
- ? **Payment Tracking:** Cash, Bank transfer, E-wallet
- ? **Exception Handling:** Lost tickets, invalid tickets
- ? **Statistics & Reports:** Daily revenue, employee performance

### Pricing Structure:
| Vehicle Type | Daily Ticket | Monthly Ticket |
|-------------|--------------|----------------|
| ?? Bike | 2,000? | 50,000? |
| ?? Motorcycle | 3,000? | 50,000? |
| ?? Car | **FREE** | - |

*Note: Cars are free for faculty members*

---

## ?? Database Schema

### Entity Relationship Diagram (ERD)

```
„¡„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„¢         „¡„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„¢         „¡„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„¢
„   NhanVien   „ ?„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„    PhieuXe    „ „Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ?„    LoPhieu   „ 
„  (Employee)  „          „   (Ticket)    „          „   (Batch)    „ 
„¤„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„£         „¤„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„£         „¤„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„£
       „                        „ 
       „                        „ 
       ¥                       ¥
„¡„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„¢         „¡„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„¢
„    GiaVe     „          „ LichSuThanhToan„ 
„   (Pricing)  „          „   (Payment)    „ 
„¤„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„£         „¤„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„£
                              „ 
                              ¥
                        „¡„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„¢
                        „    NgoaiLe    „ 
                        „  (Exception)  „ 
                        „¤„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„Ÿ„£
```

### Tables Overview

| Table Name | Description | Records (Sample) |
|-----------|-------------|------------------|
| **NhanVien** | Employees (cashiers, guards, managers) | 6 |
| **GiaVe** | Ticket pricing by vehicle & ticket type | 5 |
| **LoPhieu** | Ticket batches (number ranges) | 3 |
| **PhieuXe** | Parking tickets (virtual tickets) | 8 |
| **LichSuThanhToan** | Payment history | 2 |
| **NgoaiLe** | Exception handling records | 1 |

---

## ?? Installation Guide

### Prerequisites:
- ? SQL Server 2019+ (or SQL Server Express)
- ? SQL Server Management Studio (SSMS)
- ? Database permissions (CREATE DATABASE, CREATE TABLE)

### Step 1: Create Database Schema

1. Open **SQL Server Management Studio (SSMS)**
2. Connect to your SQL Server instance
3. Open `ParkingTicketDB_Schema.sql`
4. Execute the script (F5 or Ctrl+E)

```sql
-- This will:
-- ? Create database: ParkingTicketDB
-- ? Create 6 tables with relationships
-- ? Create indexes for performance
-- ? Create 3 views for reporting
-- ? Create 3 stored procedures
-- ? Create 2 functions
```

**Expected Output:**
```
? Database schema created successfully!
? Next step: Run ParkingTicketDB_SampleData.sql to insert sample data.
```

### Step 2: Insert Sample Data

1. Open `ParkingTicketDB_SampleData.sql`
2. Execute the script

```sql
-- This will insert:
-- ? 6 employees (1 manager, 3 cashiers, 2 guards)
-- ? 5 pricing records
-- ? 3 ticket batches
-- ? 8 parking tickets (6 active, 2 completed)
-- ? 2 payment records
-- ? 1 exception record
```

**Expected Output:**
```
?? ===== DATABASE SUMMARY =====

?? Employees: 6
?? Pricing Records: 5
?? Ticket Batches: 3
?? Total Tickets: 8
   - ?ang G?i: 6
   - ?? Tr? Xe: 2
   - H?t H?n: 1
?? Payment Records: 2
?? Exception Records: 1

? ===== SAMPLE DATA INSERTED SUCCESSFULLY! =====
```

### Step 3: Verify Installation

Run this query:
```sql
USE ParkingTicketDB;
SELECT * FROM vw_VeDangGui;
```

You should see **6 active tickets** displayed.

---

## ?? Usage Examples

### Example 1: Issue a New Ticket (Xe V?o)

```sql
USE ParkingTicketDB;

DECLARE @MaPhieu INT, @SoPhieu VARCHAR(20);

EXEC sp_PhatPhieuXeVao 
    @BienSo = '51C-12345',
    @LoaiXe = N'Xe M?y',
    @LoaiVe = N'V? Ng?y',
    @TenChuXe = N'Nguy?n V?n Test',
    @SDTChuXe = '0909123456',
    @ViTriDo = 'A10',
    @NhanVienPhat = 2,  -- Cashier employee ID
    @MaPhieu = @MaPhieu OUTPUT,
    @SoPhieu = @SoPhieu OUTPUT;

-- Display result
SELECT 
    @MaPhieu AS TicketID, 
    @SoPhieu AS TicketNumber,
    N'Ticket issued successfully!' AS Message;
```

**Output:**
```
TicketID | TicketNumber | Message
---------|--------------|-------------------------
9        | #VX-006      | Ticket issued successfully!
```

### Example 2: Return Vehicle (Xe Ra)

```sql
DECLARE @SoTien DECIMAL(18,0);

EXEC sp_ThuPhieuXeRa
    @SoPhieu = '#VX-006',
    @NhanVienThu = 2,
    @PhuongThucThanhToan = N'Ti?n M?t',
    @SoTienThanhToan = @SoTien OUTPUT;

SELECT 
    @SoTien AS AmountPaid,
    N'Vehicle returned. Payment processed.' AS Message;
```

**Output:**
```
AmountPaid | Message
-----------|-------------------------------------
3000       | Vehicle returned. Payment processed.
```

### Example 3: Search Tickets

```sql
-- Search by license plate
SELECT * FROM PhieuXe WHERE BienSo = '29A-12345';

-- Search by ticket number
SELECT * FROM PhieuXe WHERE SoPhieu = '#VX-001';

-- Search by customer name
SELECT * FROM PhieuXe WHERE TenChuXe LIKE N'%Nguy?n%';
```

### Example 4: Daily Revenue Report

```sql
SELECT 
    CAST(GETDATE() AS DATE) AS Date,
    COUNT(*) AS TotalTickets,
    SUM(GiaVe) AS TotalRevenue
FROM PhieuXe
WHERE CAST(ThoiGianVao AS DATE) = CAST(GETDATE() AS DATE)
  AND TrangThai IN (N'?ang G?i', N'?? Tr? Xe');
```

### Example 5: Active Tickets Summary

```sql
-- Use the pre-built view
SELECT * FROM vw_VeDangGui 
ORDER BY ThoiGianVao DESC;

-- Or custom query
SELECT 
    TrangThai AS Status,
    COUNT(*) AS Count
FROM PhieuXe
GROUP BY TrangThai;
```

---

## ?? Maintenance

### Daily Tasks

1. **Update Expired Tickets**
```sql
UPDATE PhieuXe
SET TrangThai = N'H?t H?n'
WHERE TrangThai = N'?ang G?i'
  AND ThoiGianHetHan IS NOT NULL
  AND ThoiGianHetHan < GETDATE();
```

2. **Check Tickets Expiring Soon (7 days)**
```sql
SELECT 
    SoPhieu,
    BienSo,
    TenChuXe,
    ThoiGianHetHan,
    DATEDIFF(DAY, GETDATE(), ThoiGianHetHan) AS DaysRemaining
FROM PhieuXe
WHERE TrangThai = N'?ang G?i'
  AND LoaiVe = N'V? Th?ng'
  AND DATEDIFF(DAY, GETDATE(), ThoiGianHetHan) BETWEEN 0 AND 7
ORDER BY ThoiGianHetHan;
```

### Weekly Tasks

1. **Backup Database**
```sql
BACKUP DATABASE ParkingTicketDB
TO DISK = 'C:\Backup\ParkingTicketDB_Backup.bak'
WITH FORMAT, COMPRESSION;
```

2. **Rebuild Fragmented Indexes**
```sql
-- Check fragmentation first
SELECT 
    OBJECT_NAME(ips.object_id) AS TableName,
    i.name AS IndexName,
    ips.avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') ips
INNER JOIN sys.indexes i ON ips.object_id = i.object_id AND ips.index_id = i.index_id
WHERE ips.avg_fragmentation_in_percent > 30;

-- Rebuild if needed
ALTER INDEX ALL ON PhieuXe REBUILD;
```

### Monthly Tasks

1. **Archive Old Data (1 year+)**
```sql
-- Delete payment history for old tickets
DELETE FROM LichSuThanhToan 
WHERE MaPhieu IN (
    SELECT MaPhieu FROM PhieuXe 
    WHERE TrangThai = N'?? Tr? Xe' 
      AND ThoiGianRa < DATEADD(YEAR, -1, GETDATE())
);

-- Delete old tickets
DELETE FROM PhieuXe 
WHERE TrangThai = N'?? Tr? Xe' 
  AND ThoiGianRa < DATEADD(YEAR, -1, GETDATE());
```

2. **Update Statistics**
```sql
UPDATE STATISTICS NhanVien WITH FULLSCAN;
UPDATE STATISTICS PhieuXe WITH FULLSCAN;
UPDATE STATISTICS LichSuThanhToan WITH FULLSCAN;
```

---

## ?? Quick Reference

### Connection String (C#)
```csharp
"Server=localhost;Database=ParkingTicketDB;Trusted_Connection=True;TrustServerCertificate=True;"
```

### Important Views
- `vw_VeDangGui` - Active tickets
- `vw_ThongKeTheoNgay` - Daily statistics
- `vw_DoanhThuTheoNhanVien` - Revenue by employee

### Important Stored Procedures
- `sp_PhatPhieuXeVao` - Issue new ticket
- `sp_ThuPhieuXeRa` - Process vehicle return
- `sp_TaoLoPhieu` - Create ticket batch

### Important Functions
- `fn_DoanhThuTheoNgay(@Ngay)` - Revenue by date
- `fn_DemVeDangGui()` - Count active tickets

---

## ??? Security Notes

1. **Change default passwords** in production
2. **Create separate SQL login** for application
3. **Grant minimum permissions** needed
4. **Enable encryption** for sensitive data
5. **Regular backups** are essential

---

## ?? Support

For issues or questions:
- ?? Email: support@parkingticket.vn
- ?? GitHub: https://github.com/pnam69/ParkTicketManagement
- ?? Phone: 0901234567

---

## ?? License

This database schema is part of the Parking Ticket Management System project.

**Created:** 2024-12-23  
**Version:** 1.0  
**Database:** SQL Server 2019+  
**Encoding:** UTF-8 (Vietnamese collation)

---

? **You're all set! Happy coding!** ??
