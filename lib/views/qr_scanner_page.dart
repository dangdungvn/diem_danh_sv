import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'dart:io';
import 'package:diem_danh_sv/models/qr_attendance_model.dart';
import 'package:diem_danh_sv/services/attendance_service.dart';
import 'package:diem_danh_sv/views/qr_attendance_result_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({Key? key}) : super(key: key);

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isProcessing = false;
  final AttendanceService _attendanceService = AttendanceService();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quét mã QR điểm danh'),
        elevation: 2,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.blue,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: MediaQuery.of(context).size.width * 0.8,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: isProcessing
                  ? const CircularProgressIndicator()
                  : const Text(
                      'Đặt mã QR vào vùng quét',
                      style: TextStyle(fontSize: 16),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (isProcessing || scanData.code == null) return;

      setState(() {
        isProcessing = true;
      });

      try {
        // Tạm dừng camera khi đang xử lý
        controller.pauseCamera();

        print('QR Data: ${scanData.code!}'); // Lấy dữ liệu QR
        final qrData = QrAttendanceModel.fromRawData(scanData.code!);

        print('Parsed QR Data: ${qrData.toJson()}');

        // Kiểm tra hợp lệ của dữ liệu QR
        if (qrData.scheduleId <= 0) {
          throw Exception('Mã QR không chứa dữ liệu lịch học hợp lệ');
        }

        // Lấy vị trí hiện tại
        final locationData = await _getCurrentLocation();

        // Lấy token
        final token = await _secureStorage.read(key: 'access_token');

        if (token == null) {
          throw Exception('Bạn chưa đăng nhập');
        }

        // Gửi yêu cầu điểm danh
        final result = await _attendanceService.attendanceByQR(
          token,
          qrData,
          locationData,
        );

        // Chuyển đến trang kết quả
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => QrAttendanceResultPage(
              result: result,
              scheduleId: qrData.scheduleId,
            ),
          ),
        );
      } catch (e) {
        // Hiển thị lỗi
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
        print('Lỗi: ${e.toString()}');

        // Tiếp tục quét sau khi xử lý lỗi
        controller.resumeCamera();
        setState(() {
          isProcessing = false;
        });
      }
    });
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
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
