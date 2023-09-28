import 'package:flutter/material.dart';
import 'package:fever_therm/widgets/drawer.dart';

class HomePage extends StatelessWidget {
  final bool showTemperature;
  final bool showLightSensor;
  final Function getTemperatureCallback;
  final Function getLightSensorCallback;
  final Function toggleTemperatureCallback;
  final Function toggleLightSensorCallback;

  HomePage({
    required this.showTemperature,
    required this.showLightSensor,
    required this.getTemperatureCallback,
    required this.getLightSensorCallback,
    required this.toggleTemperatureCallback,
    required this.toggleLightSensorCallback,
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
            margin: EdgeInsets.all(16),
            child: Text("Here are your desired readings"),
          ),
          if (showTemperature)
            // Add the temperature section here
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
            // Add the light sensor section here
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
        ],
      ),
      drawer: MyDrawer(
        showTemperature: showTemperature,
        showLightSensor: showLightSensor,
        toggleTemperatureCallback: toggleTemperatureCallback,
        toggleLightSensorCallback: toggleLightSensorCallback,
      ),
    );
  }
}
