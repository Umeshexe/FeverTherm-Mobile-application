// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  final bool showLightSensor;
  final bool showCpuTemperature;
  final bool showBatteryInfo;
  final bool showThermalState;
  final bool showCsvData;
  final Function toggleLightSensorCallback;
  final Function toggleCpuTemperatureCallback;
  final Function toggleBatteryInfoCallback;
  final Function toggleThermalStateCallback;
  final Function toggleCsvDataCallback;

  MyDrawer({
    required this.showLightSensor,
    required this.showCpuTemperature,
    required this.showBatteryInfo,
    required this.showThermalState,
    required this.showCsvData,
    required this.toggleLightSensorCallback,
    required this.toggleCpuTemperatureCallback,
    required this.toggleBatteryInfoCallback,
    required this.toggleThermalStateCallback,
    required this.toggleCsvDataCallback,
  });

  @override
  Widget build(BuildContext context) {
    const imageUrl =
        "https://avatars.githubusercontent.com/u/98090092?s=400&u=f1135f41d3c2b5db0fbb0bacc2c1936846bfa246&v=4";
    return Drawer(
      child: Container(
        color: Colors.deepPurple,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              child: UserAccountsDrawerHeader(
                margin: EdgeInsets.zero,
                accountName: Text(
                  "Umesh Chandra",
                  style: TextStyle(color: Colors.white),
                ),
                accountEmail: Text(
                  "kadaliumeshchandra@gmail.com",
                  style: TextStyle(color: Colors.white),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(imageUrl),
                ),
              ),
            ),
            ListTile(
              title: Text(
                "Thermal State",
                textScaleFactor: 1.2,
                style: TextStyle(color: Colors.white),
              ),
              trailing: CustomSwitch(
                value: showThermalState,
                onChanged: (value) {
                  toggleThermalStateCallback(value);
                },
              ),
            ),
            ListTile(
              title: Text(
                "Ambient light sensor",
                textScaleFactor: 1.2,
                style: TextStyle(color: Colors.white),
              ),
              trailing: CustomSwitch(
                value: showLightSensor,
                onChanged: (value) {
                  toggleLightSensorCallback(value);
                },
              ),
            ),
            ListTile(
              title: Text(
                "CPU Temperature",
                textScaleFactor: 1.2,
                style: TextStyle(color: Colors.white),
              ),
              trailing: CustomSwitch(
                value: showCpuTemperature,
                onChanged: (value) {
                  toggleCpuTemperatureCallback(value);
                },
              ),
            ),
            ListTile(
              title: Text(
                "Battery Info",
                textScaleFactor: 1.2,
                style: TextStyle(color: Colors.white),
              ),
              trailing: CustomSwitch(
                value: showBatteryInfo,
                onChanged: (value) {
                  toggleBatteryInfoCallback(value);
                },
              ),
            ),
            ListTile(
              title: Text(
                "CSV data",
                textScaleFactor: 1.2,
                style: TextStyle(color: Colors.white),
              ),
              trailing: CustomSwitch(
                value: showCsvData,
                onChanged: (value) {
                  toggleCsvDataCallback(value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  CustomSwitch({
    required this.value,
    required this.onChanged,
  });

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value; // Initialize _value in the initState method
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoSwitch(
      value: _value, // Use the local _value variable
      activeColor: Colors.green,
      trackColor: Colors.grey,
      onChanged: (value) {
        setState(() {
          _value = value; // Update the local _value variable
        });
        widget.onChanged(value); // Notify the parent widget about the change
      },
    );
  }
}
