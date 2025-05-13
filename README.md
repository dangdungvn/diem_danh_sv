# DIEM DANH SV - Ứng dụng Điểm Danh Sinh Viên

Ứng dụng điểm danh sinh viên được phát triển bằng Flutter, giúp sinh viên điểm danh nhanh chóng thông qua quét mã QR và xem thông tin học tập.

## Tính năng chính

- **Đăng nhập/Xác thực**: Hệ thống đăng nhập an toàn và quản lý phiên người dùng
- **Quét mã QR**: Điểm danh thông qua quét mã QR
- **Xử lý ảnh QR**: Điểm danh thông qua ảnh chứa mã QR
- **Xem lịch học**: Xem lịch học theo khoảng thời gian
- **Theo dõi điểm danh**: Xem lịch sử và thống kê điểm danh
- **Quản lý lớp học**: Xem thông tin các lớp học đã tham gia
- **Quản lý hồ sơ**: Xem và cập nhật thông tin cá nhân

## Endpoints API

### Xác thực

- **Đăng nhập**: `POST /auth/jwt/create/`
- **Làm mới token**: `POST /auth/jwt/refresh/`
- **Thông tin người dùng**: `GET /api/users/me/`

### Điểm danh

- **Lịch sử điểm danh**: `GET /api/attendance/`
- **Điểm danh bằng QR**: `POST /api/attendance/qr-attendance/`
- **Chi tiết buổi học**: `GET /api/core/schedules/{scheduleId}/`

### Hồ sơ người dùng

- **Thông tin người dùng**: `GET /api/user-info/`
- **Cập nhật hồ sơ**: `PATCH /api/users/update-profile/`
- **Tải lên avatar**: `POST /api/users/upload-avatar/`
- **Xóa avatar**: `DELETE /api/users/remove-avatar/`
- **Đổi mật khẩu**: `POST /api/users/change-password/`

### Lớp học

- **Danh sách lớp của tôi**: `GET /api/school/students/my_classes/`

### Lịch học

- **Lịch học sinh viên**: `GET /api/core/schedules/student_schedule/`
- **Lịch học theo khoảng thời gian**: `GET /api/core/schedules/student_schedule/?start_date={startDate}&end_date={endDate}`

## Cài đặt

1. Đảm bảo bạn đã cài đặt Flutter SDK:

```bash
flutter --version
```

2. Clone dự án:

```bash
git clone [url-repository]
```

3. Cài đặt các phụ thuộc:

```bash
flutter pub get
```

4. Tạo file `.env` tại thư mục gốc với nội dung:

```
API_URL=http://34.143.254.122
```

5. Chạy ứng dụng:

```bash
flutter run
```

## Cấu trúc dự án

- **lib/main.dart**: Điểm khởi đầu của ứng dụng
- **lib/views/**: Chứa các màn hình UI
- **lib/models/**: Các mô hình dữ liệu
- **lib/providers/**: State management với Provider
- **lib/services/**: Các dịch vụ tương tác với API
- **lib/routes/**: Định nghĩa các route trong ứng dụng
- **lib/theme/**: Cấu hình giao diện sáng/tối
- **lib/components/**: Các thành phần UI tái sử dụng
- **lib/widgets/**: Các widget tùy chỉnh
