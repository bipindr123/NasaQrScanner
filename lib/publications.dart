import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';


////// Data class.
class Student {
  Student(this.collegeId, this.uSec, this.uDes);
  final String collegeId;
  final int uSec;
  final int uDes;
//bool selected = false;
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

////// Data source class for obtaining row data for PaginatedDataTable.
class StudentDataSource extends DataTableSource {
  int _selectedCount = 0;

  List _students = [];


  StudentDataSource(List some1) {

    for (var i in some1) {
      _students.add(Student(i[0], i[1], i[2]));
    }
  }

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


class Publications extends StatefulWidget {

  @override
  PublicationsState createState() {
    return new PublicationsState();
  }
}

class PublicationsState extends State<Publications> {
  String myqrResult = "Hey there";
  String _selectedDate = 'Choose Date';
  List myqrList = [];
  List<List> listCreated;
  String filename = "Default.csv";

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

  readFromFile()
  async {
    final myDir = new Directory('/sdcard/Nasa');
    myDir.exists().then((isThere) {
      isThere ? print('directory exists') : myDir.create();
    });

    final file = File('/sdcard/nasa/' + filename);

    if( await file.exists() == true)
      {
        listCreated =
        CsvToListConverter(eol: "\r\n", fieldDelimiter: ",")
            .convert(file.readAsStringSync(), shouldParseNumbers: true);
        setState(() {
          some = listCreated;
        });
      }
      else
        {
          await file.create();
          listCreated =
              CsvToListConverter(eol: "\r\n", fieldDelimiter: ",")
                  .convert(file.readAsStringSync(), shouldParseNumbers: true);
          setState(() {
            some = listCreated;
          });

        }

  }

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2019),
        lastDate: new DateTime(2025)
    );
    if(picked != null)
      {
        setState(
                () {
              _selectedDate =
                  picked.day.toString() + "-" + picked.month.toString() + "-" +
                      picked.year.toString();
            });
        filename = _selectedDate + "Publication";
        readFromFile();
      }
  }

  List some = [];

  PublicationsState()
  {
    readFromFile();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Column(children: [
        Text(myqrResult),
        new RaisedButton(
          onPressed: _selectDate,
          child: new Text(_selectedDate),
        ),
        Expanded(
            child: new SingleChildScrollView(
                child: PaginatedDataTable(
                  header: Text('Distributed To'),
                  rowsPerPage: 3,
                  columns: kTableColumns,
                  source: StudentDataSource(some),
                ))),
      ])
    );
  }
}