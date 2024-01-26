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
  bool isLoading = false;

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
            bottom: 700,
            child: buildResult(),
          ),
          Positioned(
            bottom: 40,
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
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
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
                  onPressed: () async {
                    if (kDebugMode) {
                      print("${code!.code}");
                    }
                    QRcontroller?.pauseCamera();
                    setState(() {
                      isLoading = true;
                    });
                    await urlToPost.sendData(code!.code.toString()).then((value) {
                      setState(() {
                        isLoading = false;
                      });
                      if (kDebugMode) {
                        print(value);
                      }
                      if (value == "scanned") {
                        res = "scanned";
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
                      } else if (value == "already_scanned") {
                        res = "already_scanned";
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
                      } else if (value == "not_found") {
                        res = "not_found";
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
                      }else if(value == "wrong_time"){
                        res = "wrong_time";
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text(
                              "It's not meal time yet !!",
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
                      }else if(value == "no_checkin"){
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text(
                              "You haven't checked in for the event !!",
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
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
          if(isLoading)
            Center(
            child: CircularProgressIndicator(),
          )
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
