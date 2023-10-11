// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cpu_reader/cpu_reader.dart';
import 'package:cpu_reader/cpuinfo.dart';
import 'package:battery_info/battery_info_plugin.dart';

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
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
      _fetchAndAddData();
    });
  }

  Future<void> _fetchAndAddData() async {
    try {
      // Fetch CPU and battery temperature data
      final double cpuTemperature = await fetchCpuTemperature();
      final int batteryTemperature = await fetchBatteryTemperature();

      // Add the data to the CSV
      addRow([DateTime.now(), cpuTemperature, batteryTemperature]);
    } catch (error) {
      print("Error fetching or adding data: $error");
    }
  }

  Future<double> fetchCpuTemperature() async {
    try {
      // Fetch CPU temperature
      final CpuInfo cpuInfo = await CpuReader.cpuInfo;
      final double cpuTemperature = cpuInfo.cpuTemperature ?? 0.0;
      return cpuTemperature;
    } catch (error) {
      print("Error fetching CPU temperature: $error");
      return 0.0;
    }
  }

  Future<int> fetchBatteryTemperature() async {
    try {
      // Fetch battery information
      final batteryInfo = await BatteryInfoPlugin().androidBatteryInfo;

      if (batteryInfo != null && batteryInfo.temperature != null) {
        final int batteryTemperature = (batteryInfo.temperature! / 1)
            .toInt(); // Convert to Celsius and to an integer
        return batteryTemperature;
      } else {
        print("Battery temperature data is not available.");
        return 0; // Return a default value (0) in case of missing data
      }
    } catch (error) {
      print("Error fetching battery temperature: $error");
      return 0; // Return 0 in case of any errors
    }
  }

  void addRow(List<dynamic> newRow) {
    setState(() {
      _csvData?.add(newRow);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
