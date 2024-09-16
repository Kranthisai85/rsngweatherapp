import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsngweatherapp/providers/weather.provider.dart';
import 'package:rsngweatherapp/screens/weather.screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WeatherProvider(),
      child: MaterialApp(
        title: 'Flutter Weather App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: WeatherScreen(),
      ),
    );
  }
}
