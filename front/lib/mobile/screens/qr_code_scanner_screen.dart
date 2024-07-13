import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:mobile/mobile/services/api_reservation_services.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';

class QRCodeScannerScreen extends StatefulWidget {
  @override
  _QRCodeScannerScreenState createState() => _QRCodeScannerScreenState();
}

class _QRCodeScannerScreenState extends State<QRCodeScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String qrText = '';
  bool _isLoading = false;

  bool isValidUUID(String uuid) {
    final uuidRegExp = RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
      caseSensitive: false,
    );
    return uuidRegExp.hasMatch(uuid);
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scanner QR Code')),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: QRView(
                  key: GlobalKey(),
                  onQRViewCreated: _onQRViewCreated,
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Text('Reservation: $qrText'),
                ),
              ),
            ],
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(), // Indicateur de chargement
            ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      String scannedText = scanData.code!;
      print("Scanned QR Code: $scannedText");

      setState(() {
        qrText = scannedText;
      });

      if (isValidUUID(scannedText)) {
        setState(() {
          _isLoading = true;
        });

        try {
          ReservationStatus status = await ApiReservation.isValid(scannedText);

          setState(() {
            _isLoading = false;
            if (status.isValid) {
              qrText = 'Réservation valide';
            } else {
              qrText = 'Réservation invalide';
            }
          });
        } catch (e) {
          setState(() {
            _isLoading = false;
            qrText = 'Error: $e';
          });
        }
      } else {
        setState(() {
          qrText = 'QR Code invalide';
        });
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
