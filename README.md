# IT43 - Ứng dụng quản lý ghi chú bảo mật

## Công nghệ
- ASP.NET Core MVC / .NET 10
- Entity Framework Core 10
- SQL Server
- Cookie Authentication
- Bootstrap + JavaScript

## 1. Chuẩn bị SQL Server

Cài một trong các phiên bản:
- SQL Server Developer / Express
- SQL Server LocalDB
- SQL Server đã có sẵn trên máy

Đồng thời có thể dùng SQL Server Management Studio (SSMS) để kiểm tra database.

## 2. Cấu hình kết nối SQL Server

Mở `appsettings.json` và sửa `DefaultConnection` nếu SQL Server của bạn không dùng instance mặc định.

### SQL Server mặc định / localhost
```text
Server=localhost;Database=SecureNotesDb;Trusted_Connection=True;TrustServerCertificate=True;MultipleActiveResultSets=True
```

### SQL Server Express
```text
Server=localhost\SQLEXPRESS;Database=SecureNotesDb;Trusted_Connection=True;TrustServerCertificate=True;MultipleActiveResultSets=True
```

### SQL Server LocalDB
```text
Server=(localdb)\MSSQLLocalDB;Database=SecureNotesDb;Trusted_Connection=True;TrustServerCertificate=True;MultipleActiveResultSets=True
```

### SQL Server Authentication
Nếu dùng tài khoản SQL Server thay vì Windows Authentication:
```text
Server=localhost;Database=SecureNotesDb;User Id=sa;Password=YOUR_PASSWORD;TrustServerCertificate=True;MultipleActiveResultSets=True
```

Không commit mật khẩu thật vào Git. Nên dùng User Secrets hoặc biến môi trường khi triển khai.

## 3. Chạy project

Mở Terminal tại thư mục chứa `AspNetMvcDemo.csproj`:

```powershell
dotnet restore
dotnet build
dotnet run --launch-profile http
```

Sau đó mở:

```text
http://localhost:5290
```

Hoặc trên Windows có thể chạy `run.bat`.

## 4. Database

Ứng dụng sử dụng Entity Framework Core với SQL Server. Khi chạy lần đầu, `Program.cs` gọi `EnsureCreatedAsync()` để tự tạo database và các bảng nếu database chưa tồn tại.

Các bảng chính:
- `Users`
- `Notes`
- `NoteShares`

Sau khi chạy, mở SSMS và refresh Databases để thấy `SecureNotesDb`.

> Nếu dự án được phát triển tiếp theo hướng production, nên chuyển từ `EnsureCreated` sang EF Core Migrations (`Add-Migration`, `Update-Database`).

## 5. Xử lý lỗi kết nối SQL Server

Nếu gặp `A network-related or instance-specific error`, kiểm tra:
1. SQL Server service đang Running.
2. Tên Server/Instance trong `appsettings.json` đúng.
3. SQL Server Authentication đúng nếu dùng tài khoản SQL.
4. `TrustServerCertificate=True` có trong connection string khi test local.
5. Nếu dùng SQL Server Express, thử `localhost\SQLEXPRESS`.

## Chức năng hiện có
- Đăng ký / đăng nhập
- Cookie Authentication
- Phân quyền truy cập
- Tạo / sửa / xóa ghi chú
- Chia sẻ ghi chú cho người dùng khác
- Phân quyền xem / chỉnh sửa ghi chú được chia sẻ
- Xem ghi chú của mình và ghi chú được chia sẻ
