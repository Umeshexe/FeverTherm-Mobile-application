// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables

import 'package:fever_therm/widgets/csv.dart';
import 'dart:ui';
import 'package:thermal/thermal.dart';
import 'package:battery_info/model/android_battery_info.dart';
import 'package:flutter/material.dart';
import 'package:fever_therm/widgets/drawer.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:fever_therm/widgets/csv.dart';

class HomePage extends StatelessWidget {
  final bool showThermalState;
  final bool showLightSensor;
  final bool showCpuTemperature;
  final bool showBatteryInfo;
  final bool showCsvData;
  final Function getThermalStateCallback;
  final Function getLightSensorCallback;
  final Function getCpuTemperatureCallback;
  final Function getBatteryInfoCallback;
  final Function getCsvDataCallback; // Define the callback here
  final void Function(bool value) toggleThermalStateCallback;
  final Function toggleLightSensorCallback;
  final Function toggleCpuTemperatureCallback;
  final Function toggleBatteryInfoCallback;
  final Function toggleCsvDataCallback;

  HomePage({
    required this.showThermalState,
    required this.showLightSensor,
    required this.showCpuTemperature,
    required this.showBatteryInfo,
    required this.showCsvData,
    required this.getThermalStateCallback,
    required this.getLightSensorCallback,
    required this.getCpuTemperatureCallback,
    required this.getBatteryInfoCallback,
    required this.getCsvDataCallback,
    required this.toggleThermalStateCallback,
    required this.toggleLightSensorCallback,
    required this.toggleCpuTemperatureCallback,
    required this.toggleBatteryInfoCallback,
    required this.toggleCsvDataCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Thermistor App",
          style: TextStyle(color: const Color.fromARGB(255, 141, 0, 0)),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(2),
              child: Text("Here are your desired readings...,"),
            ),
            if (showThermalState)
              StreamBuilder<ThermalStatus>(
                stream: Thermal().onThermalStatusChanged,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CustomLoadingAnimation();
                  } else if (snapshot.hasData) {
                    final thermalStatus = snapshot.data;
                    return Card(
                      color: Color.fromARGB(255, 255, 98, 0),
                      margin: EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Live Thermal Status: ${thermalStatus.toString()}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            StreamBuilder<double>(
                              stream: Thermal().onBatteryTemperatureChanged,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CustomLoadingAnimation();
                                } else if (snapshot.hasData) {
                                  final batteryTemperature = snapshot.data;
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Live Battery Temperature: ${batteryTemperature?.toStringAsFixed(2) ?? 'N/A'} °C',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      // Additional battery information can be displayed here.
                                    ],
                                  );
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return SizedBox(); // Handle other cases as needed.
                                }
                              },
                            ),
                            // Add additional properties from ThermalStatus here if needed.
                          ],
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return SizedBox(); // Handle other cases as needed.
                  }
                },
              ),
            if (showLightSensor)
              StreamBuilder<double>(
                stream: getLightSensorCallback(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CustomLoadingAnimation();
                  } else if (snapshot.hasData) {
                    final light = snapshot.data ?? 0.0;
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      color: Colors.deepPurple,
                      margin: EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Current Light: ${light.toStringAsFixed(2)} Lux',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return SizedBox(); // Handle other cases as needed.
                  }
                },
              ),
            if (showCpuTemperature)
              StreamBuilder<double>(
                stream: getCpuTemperatureCallback(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CustomLoadingAnimation();
                  } else if (snapshot.hasData) {
                    final cpuTemp = snapshot.data ?? 0.0;
                    return Card(
                      color: const Color.fromARGB(255, 2, 164, 245),
                      margin: EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CPU Temperature: ${cpuTemp.toStringAsFixed(2)} °C',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return SizedBox(); // Handle other cases as needed.
                  }
                },
              ),
            if (showBatteryInfo)
              StreamBuilder<AndroidBatteryInfo>(
                stream: getBatteryInfoCallback(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CustomLoadingAnimation();
                  } else if (snapshot.hasData) {
                    final batteryInfo = snapshot.data;
                    final batteryTemperature = batteryInfo?.temperature ?? 0.0;
                    final formattedTemperature =
                        batteryTemperature.toStringAsFixed(2);
                    return Card(
                      color: Color.fromARGB(255, 235, 208, 4),
                      margin: EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Battery Level: ${batteryInfo?.batteryLevel} %',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'Battery Health: ${batteryInfo?.health}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'Battery Temperature: $formattedTemperature °C',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'Battery Voltage: ${batteryInfo?.voltage} Volts',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return SizedBox(); // Handle other cases as needed.
                  }
                },
              ),
            if (showCsvData)
              SingleChildScrollView(
                child: Scrollbar(
                  child: StreamBuilder<List<List<dynamic>>>(
                    stream: getCsvDataCallback(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CustomLoadingAnimation();
                      } else if (snapshot.hasData) {
                        final csvData = snapshot.data;
                        return CsvDataWidget(csvData: csvData);
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return SizedBox(); // Handle other cases as needed.
                      }
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
      drawer: MyDrawer(
        showThermalState: showThermalState,
        showLightSensor: showLightSensor,
        showCpuTemperature: showCpuTemperature,
        showBatteryInfo: showBatteryInfo,
        showCsvData: showCsvData, // Use the correct parameter
        toggleThermalStateCallback: toggleThermalStateCallback,
        toggleLightSensorCallback: toggleLightSensorCallback,
        toggleCpuTemperatureCallback: toggleCpuTemperatureCallback,
        toggleBatteryInfoCallback: toggleBatteryInfoCallback,
        toggleCsvDataCallback:
            toggleCsvDataCallback, // Use the correct parameter
      ),
    );
  }
}

class CustomLoadingAnimation extends StatelessWidget {
  const CustomLoadingAnimation({Key? key});

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.staggeredDotsWave(
      color: Color.fromARGB(255, 229, 187, 0),
      size: 75,
    );
  }
}
