// ignore_for_file: unused_import

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
import 'package:battery_info/model/iso_battery_info.dart';
import 'package:thermal/thermal.dart';

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
  bool _showBatteryInfo = false; // Add this line

  final environmentSensors = EnvironmentSensors();

  void _toggleThermalState(bool value) {
    // Add this method
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
    // Add this method
    setState(() {
      _showBatteryInfo = value;
    });
  }

  Stream<ThermalStatus> getThermalStatusCallback() {
    // Add this method
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
              toggleBatteryInfoCallback: _toggleBatteryInfo, // Add this line
            ),
        MyRoutes.homeRoute: (context) => HomePage(
              showThermalState: _showThermalState,
              showLightSensor: _showLightSensor,
              showCpuTemperature: _showCpuTemperature,
              showBatteryInfo: _showBatteryInfo, // Add this line
              toggleThermalStateCallback: _toggleThermalState,
              toggleLightSensorCallback: _toggleLightSensor,
              toggleCpuTemperatureCallback: _toggleCpuTemperature,
              toggleBatteryInfoCallback: _toggleBatteryInfo,
              getThermalStateCallback:
                  getThermalStatusCallback, // Remove parentheses
              getLightSensorCallback: getLightSensorCallback,
              getCpuTemperatureCallback: getCpuTemperatureCallback,
              getBatteryInfoCallback: getBatteryInfoCallback, // Add this line
            ),
      },
    );
  }
}
