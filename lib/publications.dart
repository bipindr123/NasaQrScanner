import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

class Publications extends StatefulWidget {

  @override
  PublicationsState createState() {
    return new PublicationsState();
  }
}

class PublicationsState extends State<Publications> {
  String myqrResult = "Hey there";

  List myqrList = [];

 Future ScanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        if (myqrList.contains(qrResult)) {
          myqrResult = "already exists";
        } else {
          myqrResult = qrResult;
          myqrList.add(qrResult);
        }
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          myqrResult = "permission denied";
        });
      } else {
        setState(() {
          myqrResult = "Unkown error";
        });
      }
    } catch (e) {
      setState(() {
        myqrResult = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        child: Text("HI")
      ),
       floatingActionButton: FloatingActionButton.extended(
          onPressed: ScanQR, icon: Icon(Icons.camera_alt), label: Text("Scan")),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}