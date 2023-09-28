import 'package:flutter/material.dart';
import 'package:fever_therm/pages/home_page.dart';
import 'package:fever_therm/pages/login_page.dart';
import 'package:fever_therm/utils/routes.dart';
import 'package:fever_therm/widgets/themes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:environment_sensors/environment_sensors.dart';

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
  bool _showTemperature = false;
  bool _showLightSensor = false;

  // Create an instance of the EnvironmentSensors class
  final environmentSensors = EnvironmentSensors();

  void _toggleTemperature(bool value) {
    setState(() {
      _showTemperature = value;
    });
  }

  void _toggleLightSensor(bool value) {
    setState(() {
      _showLightSensor = value;
    });
  }

  Future<double> getTemperatureCallback() async {
    var temperatureSensor = environmentSensors.temperature;
    var temperatureReading = await temperatureSensor.first;
    return temperatureReading;
  }

  Stream<double> getLightSensorCallback() {
    return environmentSensors.light;
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
              toggleTemperatureCallback: _toggleTemperature,
              toggleLightSensorCallback: _toggleLightSensor,
            ),
        MyRoutes.homeRoute: (context) => HomePage(
              showTemperature: _showTemperature,
              showLightSensor: _showLightSensor,
              toggleTemperatureCallback: _toggleTemperature,
              toggleLightSensorCallback: _toggleLightSensor,
              getTemperatureCallback: getTemperatureCallback,
              getLightSensorCallback: getLightSensorCallback,
            ),
      },
    );
  }
}
