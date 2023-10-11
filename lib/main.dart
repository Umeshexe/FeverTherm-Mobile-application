// ignore_for_file: unused_import, depend_on_referenced_packages, prefer_const_constructors, prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:cpu_reader/cpuinfo.dart';
import 'package:flutter/material.dart';
import 'package:fever_therm/pages/home_page.dart';
import 'package:fever_therm/pages/login_page.dart';
import 'package:fever_therm/utils/routes.dart';
import 'package:fever_therm/widgets/themes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:environment_sensors/environment_sensors.dart';
import 'package:cpu_reader/cpu_reader.dart';
import 'package:fever_therm/main.dart';
import 'package:battery_info/battery_info_plugin.dart';
import 'package:battery_info/enums/charging_status.dart';
import 'package:battery_info/model/android_battery_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:thermal/thermal.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'dart:async';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyRoutes {
  static const String homeRoute = '/';
  static const String loginRoute = '/login';
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _showThermalState = false;
  bool _showLightSensor = false;
  bool _showCpuTemperature = false;
  bool _showBatteryInfo = false;
  bool _showCsvData = false;
  Timer? _csvTimer;

  void _toggleCsvData(bool value) {
    setState(() async {
      _showCsvData = value;
      if (_showCsvData) {
        // Fetch sensor data
        CpuInfo cpuInfo = await CpuReader.cpuInfo;
        double cpuTemperature = cpuInfo.cpuTemperature ?? 0.0;
        AndroidBatteryInfo? batteryInfo =
            await BatteryInfoPlugin().androidBatteryInfo;

        // Write to CSV file
        final directory = await getApplicationDocumentsDirectory();
        final path = directory.path + '/sensor_data.csv';
        final file = File(path);

        if (!file.existsSync()) {
          // If the file does not exist, write headers
          String csvHeaders = const ListToCsvConverter().convert([
            ['Time', 'cpuTemperature', 'batteryInfo?.temperature']
          ]);
          file.writeAsStringSync(csvHeaders, mode: FileMode.write);
        }

        // Start the timer for periodic updates
        _csvTimer = Timer.periodic(Duration(seconds: 5), (timer) async {
          void _toggleCsvData(bool value) {
            setState(() async {
              _showCsvData = value;
              if (_showCsvData) {
                // Fetch sensor data
                CpuInfo cpuInfo = await CpuReader.cpuInfo;
                double cpuTemperature = cpuInfo.cpuTemperature ?? 0.0;
                AndroidBatteryInfo? batteryInfo =
                    await BatteryInfoPlugin().androidBatteryInfo;

                // Write to CSV file
                final directory = await getApplicationDocumentsDirectory();
                final path = directory.path + '/sensor_data.csv';
                final file = File(path);

                // Read existing data from the file
                String existingData = '';
                if (file.existsSync()) {
                  existingData = await file.readAsString();
                } else {
                  // If the file does not exist, write headers
                  String csvHeaders = const ListToCsvConverter().convert([
                    ['Time', 'cpuTemperature', 'batteryInfo?.temperature']
                  ]);
                  file.writeAsStringSync(csvHeaders, mode: FileMode.write);
                }

                // Start the timer for periodic updates
                _csvTimer = Timer.periodic(Duration(seconds: 5), (timer) async {
                  // Fetch sensor data again
                  CpuInfo updatedCpuInfo = await CpuReader.cpuInfo;
                  double updatedCpuTemperature =
                      updatedCpuInfo.cpuTemperature ?? 0.0;
                  AndroidBatteryInfo? updatedBatteryInfo =
                      await BatteryInfoPlugin().androidBatteryInfo;

                  // Format the updated timestamp to display only time
                  String updatedFormattedTime =
                      DateFormat.jm().format(DateTime.now());

                  // Append updated data
                  List<dynamic> newRow = [
                    updatedFormattedTime, // Display only time
                    updatedCpuTemperature.toString(),
                    updatedBatteryInfo?.temperature.toString(),
                  ];

                  // Convert and update the CSV data
                  String updatedCsvRow =
                      const ListToCsvConverter().convert([newRow]);
                  String updatedData = existingData + '\n' + updatedCsvRow;

                  // Write back to the file
                  file.writeAsStringSync(updatedData);
                });
              } else {
                _csvTimer?.cancel();
                _csvTimer = null;
              }
            });
          }
        });

        _toggleCsvData(value);
      }
    });
  }

  final environmentSensors = EnvironmentSensors();

  void _toggleThermalState(bool value) {
    setState(() {
      _showThermalState = value;
    });
  }

  void _toggleLightSensor(bool value) {
    setState(() {
      _showLightSensor = value;
    });
  }

  void _toggleCpuTemperature(bool value) {
    setState(() {
      _showCpuTemperature = value;
    });
  }

  void _toggleBatteryInfo(bool value) {
    setState(() {
      _showBatteryInfo = value;
    });
  }

  Stream<ThermalStatus> getThermalStatusCallback() {
    return Thermal().onThermalStatusChanged;
  }

  Stream<double> getLightSensorCallback() {
    return environmentSensors.light;
  }

  Stream<double> getCpuTemperatureCallback() {
    return CpuReader.cpuStream(1000)
        .map((cpuInfo) => cpuInfo.cpuTemperature ?? 0.0);
  }

  Stream<AndroidBatteryInfo> getBatteryInfoCallback() {
    return Stream.periodic(Duration(milliseconds: 100), (count) async {
      var batteryInfo = await BatteryInfoPlugin().androidBatteryInfo;
      if (batteryInfo != null) {
        return batteryInfo;
      } else {
        throw Exception('Failed to load battery info');
      }
    }).asyncMap((event) async {
      var batteryInfo = await BatteryInfoPlugin().androidBatteryInfo;
      if (batteryInfo != null) {
        return batteryInfo;
      } else {
        throw Exception('Failed to load battery info');
      }
    });
  }

  Stream<List<List<dynamic>>> getCsvDataCallback() {
    return Stream.periodic(Duration(seconds: 5), (count) async {
      // Fetch sensor data
      CpuInfo cpuInfo = await CpuReader.cpuInfo;
      double cpuTemperature = cpuInfo.cpuTemperature ?? 0.0;
      AndroidBatteryInfo? batteryInfo =
          await BatteryInfoPlugin().androidBatteryInfo;

      // Create a list representing a row of CSV data with CPU and battery temperature
      List<dynamic> row = [
        DateTime.now().toString(),
        cpuTemperature,
        batteryInfo?.temperature ??
            0.0, // Use null-aware operator to handle null case
      ];

      return [row]; // Wrap the row in another list
    }).asyncMap(
        (event) => Future.value(event)); // Use asyncMap to handle Futures
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      theme: MyTheme.lightTheme(context),
      darkTheme: MyTheme.lightTheme(context),
      debugShowCheckedModeBanner: false,
      initialRoute: MyRoutes.loginRoute,
      routes: {
        MyRoutes.loginRoute: (context) => LoginPage(
              toggleThermalStateCallback: _toggleThermalState,
              toggleLightSensorCallback: _toggleLightSensor,
              toggleCpuTemperatureCallback: _toggleCpuTemperature,
              toggleBatteryInfoCallback: _toggleBatteryInfo,
              toggleCsvDataCallback: _toggleCsvData,
            ),
        MyRoutes.homeRoute: (context) => HomePage(
              showThermalState: _showThermalState,
              showLightSensor: _showLightSensor,
              showCpuTemperature: _showCpuTemperature,
              showBatteryInfo: _showBatteryInfo,
              showCsvData: _showCsvData,
              toggleThermalStateCallback: _toggleThermalState,
              toggleLightSensorCallback: _toggleLightSensor,
              toggleCpuTemperatureCallback: _toggleCpuTemperature,
              toggleBatteryInfoCallback: _toggleBatteryInfo,
              toggleCsvDataCallback: _toggleCsvData,
              getThermalStateCallback: getThermalStatusCallback,
              getLightSensorCallback: getLightSensorCallback,
              getCpuTemperatureCallback: getCpuTemperatureCallback,
              getBatteryInfoCallback: getBatteryInfoCallback,
              getCsvDataCallback: getCsvDataCallback,
            ),
      },
    );
  }
}
