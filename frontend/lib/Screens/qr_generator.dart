import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRGenerator extends StatefulWidget {
  const QRGenerator({Key? key}) : super(key: key);

  @override
  State<QRGenerator> createState() => _QRGeneratorState();
}

class _QRGeneratorState extends State<QRGenerator> {
  var controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff252525),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImage(
              data: controller.text,
              size: 200,
              backgroundColor: Colors.white,
            ),
            buildTextField(context),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(BuildContext context) {
    var isFilled = false;
    return TextField(
      controller: controller,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      decoration: InputDecoration(
          hintText: 'Enter the text',
          hintStyle: TextStyle(color: Colors.grey),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Color(0xff9CFFC9),
            ),
          ),
          suffixIcon: IconButton(
            color: (controller.text.isNotEmpty) ? Color(0xff9CFFC9) : Colors.grey.shade600,
            icon: Icon(Icons.done, size: 30),
            onPressed: () {
              if(controller.text.isNotEmpty){
                setState(() {
                  print("Generate QR code");
                });
              }
            } ,
          )),
      onChanged: (s){
        if(s.isNotEmpty){
          if(isFilled == true){
            print(isFilled);
            isFilled = false;
            setState(() {});
          }
          else{
            print("Hello $isFilled");
            isFilled = false;
            setState(() {});
          }
        }
        else{
          isFilled = true;
          setState(() {});
        }
      },
      onEditingComplete:() => setState(() {}),
      onTapOutside: (_) => setState(() {}),
    );
  }
}
