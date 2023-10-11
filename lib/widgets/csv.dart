// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'package:flutter/material.dart';

class CsvDataWidget extends StatefulWidget {
  final List<List<dynamic>>? csvData;

  CsvDataWidget({required this.csvData});

  @override
  CsvDataWidgetState createState() => CsvDataWidgetState();
}

class CsvDataWidgetState extends State<CsvDataWidget> {
  List<List<dynamic>>? _csvData;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _csvData = widget.csvData;
    _timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
      // Add your actual data to the CSV here
      addRow([DateTime.now(), 30.5, 25.0]); // Replace this with your data
    });
  }

  void addRow(List<dynamic> newRow) {
    setState(() {
      _csvData?.add(newRow);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Use square brackets here
          Text(
            'CSV Data',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
          SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 20,
              headingRowColor: MaterialStateColor.resolveWith(
                  (states) => Colors.blueGrey[200]!),
              columns: [
                DataColumn(
                  label: Text('Timestamp'),
                  numeric: true,
                ),
                DataColumn(
                  label: Text('CPU temp(°C)'),
                  numeric: true,
                ),
                DataColumn(
                  label: Text('Battery temp(°C)'),
                  numeric: true,
                ),
              ],
              rows: _csvData?.map((row) {
                    final timestamp = DateTime.parse(row[0].toString());
                    final formattedTimestamp =
                        '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}:${timestamp.second.toString().padLeft(2, '0')}';

                    return DataRow(cells: [
                      DataCell(Text(formattedTimestamp)),
                      DataCell(Text(row[1].toString())),
                      DataCell(Text(row[2].toString())),
                    ]);
                  }).toList() ??
                  [],
            ),
          ),
        ],
      ),
    );
  }
}
