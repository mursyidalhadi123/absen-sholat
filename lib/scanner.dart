import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:adhan_flutter/adhan_flutter.dart';

const flash_on = "Nyalakan Flash";
const flash_off = "Matikan Flash";
const front_camera = "Kamera Depan";
const back_camera = "Kamera Belakang";

class QRViewExample extends StatefulWidget {
  const QRViewExample({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  final latitude = -6.5836;
  final longitude = 106.6452;
  var qrText = "";
  var prText = "";
  var flashState = flash_on;
  var cameraState = front_camera;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(8.0),
                        child: RaisedButton(
                          onPressed: () {
                            if (controller != null) {
                              controller.toggleFlash();
                              if (_isFlashOn(flashState)) {
                                setState(() {
                                  flashState = flash_off;
                                });
                              } else {
                                setState(() {
                                  flashState = flash_on;
                                });
                              }
                            }
                          },
                          child:
                          Text(flashState, style: TextStyle(fontSize: 20)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(8.0),
                        child: RaisedButton(
                          onPressed: () {
                            if (controller != null) {
                              controller.flipCamera();
                              if (_isBackCamera(cameraState)) {
                                setState(() {
                                  cameraState = front_camera;
                                });
                              } else {
                                setState(() {
                                  cameraState = back_camera;
                                });
                              }
                            }
                          },
                          child:
                          Text(cameraState, style: TextStyle(fontSize: 20)),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            flex: 1,
          ),
          Expanded(
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.red,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300,
              ),
            ),
            flex: 4,
          ),
          Text("$prText",style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  _isFlashOn(String current) {
    return flash_on == current;
  }

  _isBackCamera(String current) {
    return back_camera == current;
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('YYYY-MM-dd').format(now);
      String time = DateFormat('HH:mm').format(now);
      wait();
      addData(scanData, formattedDate, time);
      setState(() {
        qrText = scanData;
        prText = "Data $qrText berhasil dimasukkan";
      });
    });
  }

  void addData(nis, date, time){
    var url="http://asrama.systemof.fail/api/catatanSholat";
    int nisnum = int.parse(nis)

    http.post(url, body: {
      "NIS": nisnum,
      "jenis_sholat": "shubuh",
      "waktu_adzan": time,
      "waktu_masuk": time,
      "tanggal": date
    });
  }

  void wait() async {
    controller?.pauseCamera();
    await Future.delayed(const Duration(seconds: 1), (){
      controller?.resumeCamera();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<DateTime> getTodayFajrTime() async {
    final adhan = AdhanFlutter.create(Coordinates(latitude, longitude), DateTime.now(), CalculationMethod.SINGAPORE);
    return await adhan.fajr;
  }
  Future<DateTime> getTodayDhuhrTime() async {
    final adhan = AdhanFlutter.create(Coordinates(latitude, longitude), DateTime.now(), CalculationMethod.SINGAPORE);
    return await adhan.dhuhr;
  }
  Future<DateTime> getTodayIshaTime() async {
    final adhan = AdhanFlutter.create(Coordinates(latitude, longitude), DateTime.now(), CalculationMethod.SINGAPORE);
    return await adhan.isha;
  }
}