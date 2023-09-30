// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fever_therm/widgets/drawer.dart';

class HomePage extends StatelessWidget {
  final bool showTemperature;
  final bool showLightSensor;
  final bool showCpuTemperature;
  final bool showBatteryInfo;
  final Function getTemperatureCallback;
  final Function getLightSensorCallback;
  final Function getCpuTemperatureCallback;
  final Function getBatteryInfoCallback;
  final Function toggleTemperatureCallback;
  final Function toggleLightSensorCallback;
  final Function toggleCpuTemperatureCallback;
  final Function toggleBatteryInfoCallback;

  HomePage({
    required this.showTemperature,
    required this.showLightSensor,
    required this.showCpuTemperature,
    required this.showBatteryInfo,
    required this.getTemperatureCallback,
    required this.getLightSensorCallback,
    required this.getCpuTemperatureCallback,
    required this.getBatteryInfoCallback,
    required this.toggleTemperatureCallback,
    required this.toggleLightSensorCallback,
    required this.toggleCpuTemperatureCallback,
    required this.toggleBatteryInfoCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thermistor App"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.all(2),
            child: Text("Here are your desired readings...,"),
          ),
          if (showTemperature)
            FutureBuilder<double>(
              future: getTemperatureCallback(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final temperature = snapshot.data ?? 0.0;
                  return Text(
                    'The Current Temperature is: ${temperature.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 18),
                  );
                }
              },
            ),
          if (showLightSensor)
            StreamBuilder<double>(
              stream: getLightSensorCallback(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final light = snapshot.data ?? 0.0;
                  return Text(
                    'The Current Light is: ${light.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 18),
                  );
                }
              },
            ),
          if (showCpuTemperature)
            StreamBuilder<double>(
              stream: getCpuTemperatureCallback(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final cpuTemp = snapshot.data ?? 0.0;
                  return Text(
                    'The Current CPU Temperature is: ${cpuTemp.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 18),
                  );
                }
              },
            ),
          if (showBatteryInfo)
            StreamBuilder<double>(
              stream: getBatteryInfoCallback(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final batteryInfo = snapshot.data ?? 0.0;
                  return Text(
                    'The Current Battery Info is: ${batteryInfo.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 18),
                  );
                }
              },
            ),
        ],
      ),
      drawer: MyDrawer(
        showTemperature: showTemperature,
        showLightSensor: showLightSensor,
        showCpuTemperature: showCpuTemperature,
        showBatteryInfo: showBatteryInfo,
        toggleTemperatureCallback: toggleTemperatureCallback,
        toggleLightSensorCallback: toggleLightSensorCallback,
        toggleCpuTemperatureCallback: toggleCpuTemperatureCallback,
        toggleBatteryInfoCallback: toggleBatteryInfoCallback,
      ),
    );
  }
}
