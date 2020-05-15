import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_scanner/qr_scanner_overlay_shape.dart';

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
  var qrText = "";
  var prText = "";
  var flashState = flash_on;
  var cameraState = front_camera;
  var count = 0;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
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
          Expanded(
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text("$prText",style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold)),
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
          )
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

      DocumentReference documentReference =
      db.collection("ID").document(scanData);
      documentReference.get().then((datasnapshot) {
        if(datasnapshot.data['nama'] != null) {
          setState(() {
            qrText = datasnapshot.data['nama'];
            prText = "Data $qrText berhasil dimasukkan";
          });
          createRecord(scanData);
        }else{
          setState(() {
            qrText = null;
            prText = 'tidak dikenal';
          });
          createRecord("hmm");
        }
      });
      wait();
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

  void createRecord(id) async {
    await db.collection("Absensi")
        .document(id)
        .setData({
      'time': DateTime.now(),
    });
  }
}