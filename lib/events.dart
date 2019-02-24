import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

enum WhyFarther { harder, smarter, selfStarter, tradingCharter }

class Events extends StatefulWidget {
  @override
  EventsState createState() {
    return new EventsState();
  }
}

class EventsState extends State<Events> {
  String myqrResult = "Hey there";

  String selectedEvent, selectedSession;
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

  String _selectedDate = 'Choose Date';

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2019),
        lastDate: new DateTime(2025)
    );
    if(picked != null) setState(() => _selectedDate = picked.day.toString() + "-" + picked.month.toString() + "-" + picked.year.toString());
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment :MainAxisAlignment.spaceEvenly,
          mainAxisSize:MainAxisSize.min,
          children: [
           Text("Event Options",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black87,
              )),
         
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[

              DropdownButton<String>(
                value: selectedEvent,
                hint: const Text('Choose Event'),
                onChanged: (String newValue) {
                  setState(() {
                    selectedEvent = newValue;
                  });
                },
                items: <String>['ZCM', 'FCM', 'PRE CON', 'ANNUAL GBM']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              DropdownButton<String>(
                value: selectedSession,
                hint: const Text('Choose Session'),
                onChanged: (String newValue) {
                  setState(() {
                    selectedSession = newValue;
                  });
                },
                items: <String>['Morning', 'Afternoon']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          new RaisedButton(onPressed: _selectDate, child: new Text(_selectedDate),),
        ]),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: ScanQR, icon: Icon(Icons.camera_alt), label: Text("Scan")),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
