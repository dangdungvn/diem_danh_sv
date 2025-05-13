import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:diem_danh_sv/models/qr_attendance_model.dart';
import 'package:diem_danh_sv/services/attendance_service.dart';
import 'package:diem_danh_sv/views/qr_attendance_result_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class QrImageProcessPage extends StatefulWidget {
  final String? imagePath;

  const QrImageProcessPage({Key? key, this.imagePath}) : super(key: key);

  @override
  State<QrImageProcessPage> createState() => _QrImageProcessPageState();
}

class _QrImageProcessPageState extends State<QrImageProcessPage> {
  final AttendanceService _attendanceService = AttendanceService();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  bool isProcessing = true;
  String? errorMessage;
  String? _selectedImagePath;

  @override
  void initState() {
    super.initState();
    if (widget.imagePath != null) {
      _selectedImagePath = widget.imagePath;
      _processQRImage();
    } else {
      // Nếu không có đường dẫn ảnh, mở thư viện ảnh
      _pickImageFromGallery();
    }
  }

  Future<void> _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );

    if (image != null) {
      setState(() {
        _selectedImagePath = image.path;
      });
      _processQRImage();
    } else {
      // Người dùng đã hủy việc chọn ảnh
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> _processQRImage() async {
    if (_selectedImagePath == null) return;

    try {
      // Đọc ảnh từ đường dẫn
      final File imageFile = File(_selectedImagePath!);
      final InputImage inputImage = InputImage.fromFile(imageFile);

      // Sử dụng ML Kit để quét mã QR
      final BarcodeScanner barcodeScanner = GoogleMlKit.vision.barcodeScanner();
      final List<Barcode> barcodes =
          await barcodeScanner.processImage(inputImage);

      // Giải phóng bộ nhớ
      await barcodeScanner.close();

      // Kiểm tra kết quả quét
      if (barcodes.isEmpty) {
        setState(() {
          isProcessing = false;
          errorMessage = 'Không tìm thấy mã QR trong ảnh';
        });
        return;
      }

      // Lấy dữ liệu QR
      final String? qrData = barcodes.first.displayValue;
      if (qrData == null || qrData.isEmpty) {
        setState(() {
          isProcessing = false;
          errorMessage = 'Mã QR không chứa dữ liệu';
        });
        return;
      }

      // Phân tích dữ liệu QR
      final QrAttendanceModel attendanceData =
          QrAttendanceModel.fromRawData(qrData);

      // Kiểm tra hợp lệ của dữ liệu QR
      if (attendanceData.scheduleId <= 0) {
        setState(() {
          isProcessing = false;
          errorMessage = 'Mã QR không chứa dữ liệu lịch học hợp lệ';
        });
        return;
      }

      // Lấy vị trí hiện tại
      final locationData = await _getCurrentLocation();

      // Lấy token
      final token = await _secureStorage.read(key: 'access_token');
      if (token == null) {
        setState(() {
          isProcessing = false;
          errorMessage = 'Bạn chưa đăng nhập';
        });
        return;
      }

      // Gửi yêu cầu điểm danh
      final result = await _attendanceService.attendanceByQR(
        token,
        attendanceData,
        locationData,
      );

      // Chuyển đến trang kết quả
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => QrAttendanceResultPage(
            result: result,
            scheduleId: attendanceData.scheduleId,
          ),
        ),
      );
    } catch (e) {
      // Xử lý lỗi
      if (!mounted) return;
      setState(() {
        isProcessing = false;
        errorMessage = 'Lỗi: ${e.toString()}';
      });
    }
  }

  Future<Map<String, dynamic>> _getCurrentLocation() async {
    // Kiểm tra và yêu cầu quyền truy cập vị trí
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Dịch vụ vị trí bị tắt');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Quyền truy cập vị trí bị từ chối');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Quyền truy cập vị trí bị từ chối vĩnh viễn, không thể yêu cầu quyền');
    }

    // Lấy vị trí hiện tại
    final position = await Geolocator.getCurrentPosition();

    return {
      'latitude': position.latitude,
      'longitude': position.longitude,
      'device_info':
          "${Platform.operatingSystem} ${Platform.operatingSystemVersion}",
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Xử lý mã QR'),
        elevation: 2,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isProcessing) ...[
                const CircularProgressIndicator(),
                const SizedBox(height: 24),
                Text(
                  'Đang xử lý ảnh mã QR...',
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ] else if (errorMessage != null) ...[
                const Icon(
                  Icons.error_outline,
                  size: 70,
                  color: Colors.red,
                ),
                const SizedBox(height: 24),
                Text(
                  'Không thể xử lý mã QR',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  errorMessage!,
                  style: theme.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Thử lại',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        isProcessing = true;
                        errorMessage = null;
                      });
                      _pickImageFromGallery();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Chọn ảnh khác',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ], // Hiển thị ảnh QR đã chọn
              if (!isProcessing &&
                  _selectedImagePath != null &&
                  File(_selectedImagePath!).existsSync()) ...[
                const SizedBox(height: 32),
                const Text('Ảnh QR đã chọn:'),
                const SizedBox(height: 8),
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: colorScheme.outline),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(_selectedImagePath!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
