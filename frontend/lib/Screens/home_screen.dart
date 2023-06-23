import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../Database/database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final qrKey = GlobalKey(debugLabel: "QR");
  QRViewController? QRcontroller;
  Barcode? code;
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
    if (Platform.isAndroid) {
      await QRcontroller!.pauseCamera();
    }
    QRcontroller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    final urlToPost = Provider.of<Data>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff252525),
        body: Stack(alignment: Alignment.center, children: [
          buildQRView(context),
          Positioned(
            bottom: 10,
            child: buildResult(),
          ),
          Positioned(
            bottom: 50,
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      QRcontroller?.stopCamera();
                      QRcontroller?.resumeCamera();
                    });
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.refresh,
                          size: 35,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          "Refresh",
                          style: TextStyle(fontSize: 25),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (kDebugMode) {
                      print("${code!.code}");
                    }
                    QRcontroller?.pauseCamera();
                    urlToPost.sendData(code!.code.toString()).then((value) {
                      if (kDebugMode) {
                        print(value);
                      }
                      if (value == "Scanned") {
                        res = "Scanned";
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text(
                              "Success",
                            ),
                            content: const Image(
                              image: AssetImage("Assets/success.gif"),
                            ),
                            actions: [
                              TextButton.icon(
                                icon: const Icon(
                                  Icons.done,
                                  color: Colors.green,
                                  size: 25,
                                ),
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                                label: const Text(
                                  "Done",
                                  style: TextStyle(
                                      color: Colors.green, fontSize: 17),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (value == "Already scanned") {
                        res = "Already scanned";
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text(
                              "Already Scanned!!",
                            ),
                            content: const Image(
                              image: AssetImage("Assets/already_scanned.gif"),
                            ),
                            actions: [
                              TextButton.icon(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                  size: 25,
                                ),
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                  setState(() {});
                                },
                                label: const Text(
                                  "Close",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 17),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (value == "Not found") {
                        res = "Not found";
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text(
                              "Coupon not Found!!",
                            ),
                            content: const Image(
                              image: AssetImage("Assets/not_found.gif"),
                            ),
                            actions: [
                              TextButton.icon(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                  size: 25,
                                ),
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                                label: const Text(
                                  "Close",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 17),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    });
                    QRcontroller?.resumeCamera();
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.qr_code_scanner_rounded,
                          size: 35,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          "Scan",
                          style: TextStyle(fontSize: 25),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget buildResult() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white54,
        ),
        child: Text((code != null) ? "Result : ${code!.code}" : "Scan a code"));
  }

  Widget buildQRView(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: const Color(0xff7CFFB8),
        borderWidth: 10,
        borderLength: 30,
        borderRadius: 20,
        cutOutSize: MediaQuery.of(context).size.width * 0.8,
      ),
    );
  }

  void onQRViewCreated(QRcontroller) {
    setState(() => this.QRcontroller = QRcontroller);
    QRcontroller!.scannedDataStream
        .listen((code) => setState(() => this.code = code));
  }
}
