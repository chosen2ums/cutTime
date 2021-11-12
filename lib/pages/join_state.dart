import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:salon/helper/helper.dart';
import 'package:salon/helper/loading.dart';
import 'package:salon/models/app_user.dart';
import 'package:salon/provider/app_provider.dart' as app;
import 'package:salon/repository.dart';

class Join extends StatefulWidget {
  Join({Key key}) : super(key: key);

  @override
  _JoinState createState() => _JoinState();
}

class _JoinState extends State<Join> {
  bool start = false;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  QRViewController controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    } else if (Platform.isIOS) {
      controller.resumeCamera();
    }
  }

  void _onQRViewCreated(QRViewController controller) async {
    this.controller = controller;
    this.controller.scannedDataStream.listen((scanData) async {
      List<String> datas = scanData.code.split('-');

      if (datas.length == 2) {
        this.controller?.dispose();
        setState(() {
          start = true;
        });
        AppUser newartist = await repo.joinSalon(datas.first, datas.last);
        if (newartist != null) {
          repo.app.updateMe(newartist);
          repo.app.changeState(app.State.Artist);
          repo.app.navi.pushNamedAndRemoveUntil('/Home', (route) => true);
        }
      } else
        repo.snackBar('QR код буруу байна!');
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double scanArea = MediaQuery.of(context).size.width - 60;
    return WillPopScope(
      onWillPop: Helper.of(context).backPage,
      child: Material(
        child: Stack(
          children: [
            QRView(
              key: qrKey,
              cameraFacing: CameraFacing.back,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Theme.of(context).colorScheme.secondary,
                borderWidth: 2,
                borderRadius: 8,
                borderLength: 30,
                cutOutSize: scanArea,
              ),
            ),
            Positioned(
              top: 30,
              left: 8,
              child: IconButton(
                onPressed: Helper.of(context).backPage,
                icon: Icon(Ionicons.arrow_back_outline),
              ),
            ),
            start
                ? Align(
                    alignment: Alignment.center,
                    child: Loading(30),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
