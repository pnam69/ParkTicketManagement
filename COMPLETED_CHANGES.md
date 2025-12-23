# ? HO?N TH?NH - ??n Gi?n H?a H? Th?ng B?i Xe

## ?? Nh?ng G? ?? S?a

### 1. ? **Dark/Light Mode - ?? FIX**
- ? Th?m script dark mode v?o Dashboard
- ? Th?m script dark mode v?o Reports
- ? T?o file `_DarkModeScript.cshtml` ?? d? d?ng include v?o c?c trang kh?c
- **C?ch d?ng**: Th?m `<script src="~/assets/static/js/components/dark.js"></script>` v?o @section Scripts c?a m?i trang

### 2. ? **Vi?t H?a Ho?n To?n**
- ? Layout: Menu sidebar ?? Vi?t h?a
- ? Dashboard: Trang ch? v?i ti?ng Vi?t
- ? Reports: B?o c?o th?ng k? b?ng ti?ng Vi?t
- ? Footer: "?? ?n PRN211"

### 3. ? **??n Gi?n H?a D? Li?u**
- ? Gi?m t? 500 ch? Å® **200 ch?** (ph? h?p tr??ng h?c)
- ? Doanh thu: ??i t? USD Å® **VN?**
- ? Ch? 2 lo?i xe: **? t?** v? **Xe m?y**
- ? Bi?n s? Vi?t Nam: 29A-12345, 30G-56789
- ? B?o c?o ??n gi?n, d? hi?u cho sinh vi?n

## ?? Chi Ti?t Thay ??i

### **_Layout.cshtml** ?
```
- Title: "H? Th?ng Qu?n L? B?i Xe"
- Menu:
  ? Trang Ch?
  ? Xe V?o
  ? Xe Ra
  ? V? ?ang G?i
  ? B?o C?o Th?ng K?
  ? Nh?n Vi?n
- B?: Pricing, Settings (kh?ng c?n)
```

### **Dashboard/Index.cshtml** ?
```
- Th?ng k?:
  ? 200 ch? t?ng c?ng
  ? 142 ?ang g?i
  ? 58 c?n tr?ng
  ? 850.000? doanh thu h?m nay
- Ch? 2 lo?i xe: ? t? (85 xe), Xe m?y (57 xe)
- Bi?n s? Vi?t: #VX-001, 29A-12345
```

### **Reports/Index.cshtml** ?
```
- Ti?u ??: "B?o C?o Th?ng K?"
- Lo?i b?o c?o:
  ? Doanh Thu
  ? Ho?t ??ng Xe
  ? B?o C?o H?ng Ng?y
- Doanh thu th?ng: 18.500.000?
- Ch? 2 lo?i xe trong bi?u ??
- Gi? cao ?i?m: 7-9h, 11-13h, 16-18h
```

## ?? C?N C?N L?M (Cho Sinh Vi?n)

### **Entry/Index.cshtml** (C?n s?a)
```cshtml
Thay ??i c?n thi?t:
1. Title: "??ng K? Xe V?o"
2. Vehicle Type - CH? 2 LO?I:
   <option value="car">? t?</option>
   <option value="motorcycle">Xe m?y</option>
3. B?: Vehicle Make, Model (kh?ng c?n)
4. Parking Spot (kh?ng c? t?ng):
   - A1-A50 (Xe m?y)
   - B1-B50 (? t?)
5. Gi?:
   - Xe m?y: 3.000?/gi?
   - ? t?: 5.000?/gi?
```

### **Exit/Index.cshtml** (C?n s?a)
```cshtml
Thay ??i c?n thi?t:
1. Title: "Xe Ra & Thanh To?n"
2. T?m v? theo bi?n s?
3. Hi?n th?:
   - Lo?i xe
   - Gi? v?o
   - Gi? ra
   - Th?i gian g?i
   - T?ng ti?n (VN?)
4. Ph??ng th?c thanh to?n:
   - Ti?n m?t
   - Chuy?n kho?n
```

### **Tickets/Index.cshtml** (C?n s?a)
```cshtml
Thay ??i c?n thi?t:
1. Title: "Danh S?ch V? ?ang G?i"
2. C?t:
   - M? v?
   - Bi?n s?
   - Lo?i xe (? t?/Xe m?y)
   - V? tr?
   - Gi? v?o
   - Th?i gian g?i
   - Tr?ng th?i
3. T?m ki?m theo bi?n s?
```

### **Employees/Index.cshtml** (C?n s?a)
```cshtml
3 nh?n vi?n m?u:
1. Nguy?n V?n An - Qu?n l? - 0901234567
2. Tr?n Th? B?ch - Thu ng?n - 0912345678
3. L? V?n C??ng - B?o v? - 0923456789
```

## ?? Gi? G?i Xe (??n Gi?n)

| Lo?i Xe | Gi?/Gi? | Gi? C? Ng?y |
|---------|---------|-------------|
| Xe m?y  | 3.000?  | 20.000?     |
| ? t?    | 5.000?  | 40.000?     |

## ?? C?ng Th?c T?nh Ti?n

```csharp
// V? d? code ??n gi?n
public decimal CalculateFee(string vehicleType, DateTime entryTime, DateTime exitTime)
{
    TimeSpan duration = exitTime - entryTime;
    double hours = Math.Ceiling(duration.TotalHours); // L?m tr?n l?n
    
    decimal hourlyRate = vehicleType == "motorcycle" ? 3000 : 5000;
    decimal dailyMax = vehicleType == "motorcycle" ? 20000 : 40000;
    
    decimal fee = (decimal)hours * hourlyRate;
    
    // N?u > 24 gi?, t?nh theo ng?y
    if (hours >= 24)
    {
        int days = (int)Math.Ceiling(hours / 24);
        fee = days * dailyMax;
    }
    
    return fee;
}
```

## ??? Database Schema ??n Gi?n

```sql
-- Table: Vehicles
CREATE TABLE Vehicles (
    Id INT PRIMARY KEY IDENTITY(1,1),
    LicensePlate NVARCHAR(20) NOT NULL,
    Type NVARCHAR(20) NOT NULL, -- 'car' or 'motorcycle'
    EntryTime DATETIME NOT NULL,
    ExitTime DATETIME NULL,
    ParkingSpot NVARCHAR(10) NOT NULL,
    Fee DECIMAL(18,2) DEFAULT 0,
    Status NVARCHAR(20) DEFAULT 'Parked', -- 'Parked' or 'Exited'
    PaymentMethod NVARCHAR(20) NULL -- 'Cash' or 'Transfer'
);

-- Table: Employees
CREATE TABLE Employees (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    Role NVARCHAR(50) NOT NULL,
    Phone NVARCHAR(15) NOT NULL,
    IsActive BIT DEFAULT 1
);

-- Sample Data
INSERT INTO Employees (Name, Role, Phone) VALUES
(N'Nguy?n V?n An', N'Qu?n l?', '0901234567'),
(N'Tr?n Th? B?ch', N'Thu ng?n', '0912345678'),
(N'L? V?n C??ng', N'B?o v?', '0923456789');
```

## ?? M? M?u Bootstrap (Cho 2 Lo?i Xe)

```html
<!-- ? t?: Primary (Xanh d??ng) -->
<span class="badge bg-primary">? t?</span>

<!-- Xe m?y: Warning (V?ng) -->
<span class="badge bg-warning">Xe m?y</span>

<!-- ?ang g?i: Success (Xanh l?) -->
<span class="badge bg-success">?ang g?i</span>

<!-- ?? ra: Danger (??) -->
<span class="badge bg-danger">?? ra</span>
```

## ?? Workflow ??n Gi?n

### **Xe V?o**
1. Nh?p bi?n s? (VD: 29A-12345)
2. Ch?n lo?i xe (? t?/Xe m?y)
3. H? th?ng t? ??ng assign ch?:
   - Xe m?y: A1-A50
   - ? t?: B1-B50
4. L?u v?o database v?i status = "Parked"
5. In/hi?n th? v?

### **Xe Ra**
1. Nh?p bi?n s?
2. T?m v? trong database (status = "Parked")
3. T?nh ti?n d?a tr?n:
   - Lo?i xe
   - Th?i gian g?i
4. Nh?p ph??ng th?c thanh to?n
5. C?p nh?t:
   - ExitTime = now
   - Fee = calculated
   - Status = "Exited"
   - PaymentMethod

### **Xem V?**
1. Hi?n th? t?t c? v? c? status = "Parked"
2. T?m ki?m theo bi?n s?
3. Xem th?ng tin chi ti?t

### **B?o C?o**
1. S? xe v?o/ra theo ng?y: COUNT(*)
2. Doanh thu theo ng?y: SUM(Fee)
3. Bi?u ?? t? l? ? t?/xe m?y

## ?? Quick Start Guide

### **1. Database Setup**
```bash
# Package Manager Console
Add-Migration InitialCreate
Update-Database
```

### **2. Test Data**
```csharp
// Seed data in Program.cs or DbContext
public static void SeedData(ApplicationDbContext context)
{
    if (!context.Employees.Any())
    {
        context.Employees.AddRange(
            new Employee { Name = "Nguy?n V?n An", Role = "Qu?n l?", Phone = "0901234567" },
            new Employee { Name = "Tr?n Th? B?ch", Role = "Thu ng?n", Phone = "0912345678" },
            new Employee { Name = "L? V?n C??ng", Role = "B?o v?", Phone = "0923456789" }
        );
        context.SaveChanges();
    }
}
```

### **3. Run Project**
```bash
dotnet run
```

## ? Checklist Ho?n Th?nh

- [x] Fix Dark/Light Mode
- [x] Vi?t h?a Layout
- [x] Vi?t h?a Dashboard
- [x] Vi?t h?a Reports
- [x] ??n gi?n h?a s? l??ng (200 ch?)
- [x] Ch? 2 lo?i xe
- [x] ??i sang VN?
- [x] Build th?nh c?ng
- [ ] Vi?t h?a Entry (C?n l?m)
- [ ] Vi?t h?a Exit (C?n l?m)
- [ ] Vi?t h?a Tickets (C?n l?m)
- [ ] Vi?t h?a Employees (C?n l?m)
- [ ] K?t n?i Database (C?n l?m)
- [ ] CRUD Operations (C?n l?m)
- [ ] Testing (C?n l?m)

## ?? L?u ? Quan Tr?ng

1. **Dark Mode**: Lu?n th?m `<script src="~/assets/static/js/components/dark.js"></script>` v?o @section Scripts
2. **Bi?n s? Vi?t**: Format XX(Y)-XXXXX (VD: 29A-12345)
3. **Ti?n t?**: Lu?n d?ng VN?, format: 850.000?
4. **??n gi?n**: ??ng l?m ph?c t?p, t?p trung CRUD c? b?n
5. **Timeline**: 15 ng?y - ?u ti?n ch?c n?ng ho?t ??ng tr??c

## ?? Ph? H?p Cho ?? ?n PRN211

? ?? ??n gi?n cho 6 sinh vi?n trong 15 ng?y
? C? ??y ?? CRUD operations
? C? UI ??p s?n (Mazer template)
? Database kh?ng qu? ph?c t?p
? C? b?o c?o th?ng k? c? b?n
? Ph? h?p b?i xe tr??ng h?c Vi?t Nam

**Ch?c c?c b?n l?m ?? ?n th?nh c?ng! ??**
