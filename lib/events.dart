import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';


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

  int _rowsPerPage = 3;


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
        lastDate: new DateTime(2025));
    if (picked != null)
      setState(() => _selectedDate = picked.day.toString() +
          "-" +
          picked.month.toString() +
          "-" +
          picked.year.toString());
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        padding: EdgeInsets.all(30),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
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
              new RaisedButton(
                onPressed: _selectDate,
                child: new Text(_selectedDate),
              ),
              Expanded(
                  child: new SingleChildScrollView(
                      child: PaginatedDataTable(
                header: Text('Attendance'),
                rowsPerPage: _rowsPerPage,
                availableRowsPerPage: <int>[3, 4, 5, 6],
                onRowsPerPageChanged: (int value) {
                  setState(() {
                    _rowsPerPage = value;
                  });
                },
                columns: kTableColumns,
                source: StudentDataSource(),
              ))),
            ]),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: ScanQR, icon: Icon(Icons.camera_alt), label: Text("Scan")),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

////// Columns in table.
const kTableColumns = <DataColumn>[
  DataColumn(
    label: const Text('College Code'),
  ),
  DataColumn(
    label: const Text('USec'),
    numeric: true,
  ),
  DataColumn(
    label: const Text('UDes'),
    numeric: true,
  )
];

////// Data class.
class Student {
  Student(this.collegeId, this.uSec, this.uDes);
  final String collegeId;
  final int uSec;
  final int uDes;
  //bool selected = false;
}

////// Data source class for obtaining row data for PaginatedDataTable.
class StudentDataSource extends DataTableSource {
  int _selectedCount = 0;
  final List<Student> _students = <Student>[
    new Student('Z005CS', 1, 1),
    new Student('Z105CS', 1, 0),
    new Student('Z115CS', 0, 1),
    new Student('A115CS', 0, 1),
    new Student('A115CS', 0, 1),
  ];

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= _students.length) return null;
    final Student student = _students[index];
    return DataRow.byIndex(index: index,
        // selected: student.selected,
        // onSelectChanged: (bool value) {
        //   if (student.selected != value) {
        //     _selectedCount += value ? 1 : -1;
        //     assert(_selectedCount >= 0);
        //     student.selected = value;
        //     notifyListeners();
        //   }
        // },
        cells: <DataCell>[
          DataCell(Text('${student.collegeId}')),
          DataCell(Text('${student.uSec}')),
          DataCell(Text('${student.uDes}')),
        ]);
  }

  @override
  int get rowCount => _students.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}
