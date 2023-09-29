import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  final bool showTemperature;
  final bool showLightSensor;
  final bool showCpuTemperature;
  final Function toggleTemperatureCallback;
  final Function toggleLightSensorCallback;
  final Function toggleCpuTemperatureCallback;

  MyDrawer({
    required this.showTemperature,
    required this.showLightSensor,
    required this.showCpuTemperature,
    required this.toggleTemperatureCallback,
    required this.toggleLightSensorCallback,
    required this.toggleCpuTemperatureCallback,
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
                "Temperature",
                textScaleFactor: 1.2,
                style: TextStyle(color: Colors.white),
              ),
              trailing: CustomSwitch(
                value: showTemperature,
                onChanged: (value) {
                  toggleTemperatureCallback(value);
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
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoSwitch(
      value: _value,
      activeColor: Colors.green,
      trackColor: Colors.grey,
      onChanged: (value) {
        setState(() {
          _value = value;
        });
        widget.onChanged(value);
      },
    );
  }
}
