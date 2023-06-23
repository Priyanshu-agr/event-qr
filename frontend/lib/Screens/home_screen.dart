import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../Database/database.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final qrKey = GlobalKey(debugLabel:  "QR");
  QRViewController? QRcontroller;
  Barcode? code ;
  String? res;

  @override
  void dispose() {
    // TODO: implement dispose
    QRcontroller?.dispose;
    super.dispose();
  }

  // This is used to ensure that hotReload works appropriately during development cycle
  @override
  void reassemble() async {
    // TODO: implement reassemble
    super.reassemble();
    if(Platform.isAndroid){
      await QRcontroller!.pauseCamera();
    }
    QRcontroller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    final urlToPost = Provider.of<Data>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff252525),
        body: Stack(
          alignment: Alignment.center,
          children: [
            buildQRView(context),
            Positioned(bottom: 10, child: buildResult(),),
            Positioned(bottom: 50, child: ElevatedButton(
              onPressed: (){
                print("${code!.code}");
                urlToPost.sendData(code!.code.toString()).then((value){
                  print(value);
                  if(value == "1"){
                    res = "1";
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text("Success"),
                          // content: Image(image: ),
                          actions: [],
                        ));
                  }
                  else if(value == "0"){
                    res ="0";
                  }
                  else{
                    res = "3";
                  }
                });
              },
              child: Text("Scan"),
            ),),
          ]
        ),
      ),
    );
  }

  Widget buildResult(){
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color : Colors.white54,
        ),
        child: Text((code!= null) ? "Result : ${code!.code}" : "Scan a code"));
  }

  Widget buildQRView(BuildContext context){
    return QRView(
      key: qrKey,
      onQRViewCreated: onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Color(0xff7CFFB8),
        borderWidth: 10,
        borderLength: 30,
        borderRadius: 20,
        cutOutSize: MediaQuery.of(context).size.width *0.8,
      ),
    );
  }

  void onQRViewCreated(QRcontroller){
    setState(() => this.QRcontroller = QRcontroller);
    QRcontroller!.scannedDataStream.listen((code) => setState(() => this.code = code));
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Color(0xff252525),
  //     body: Center(
  //       child: ElevatedButton(
  //         onPressed: (){
  //           _qrScanner();
  //         },
  //         child: Text("Scan"),
  //       ),
  //     ),
  //   );
  // }
}
