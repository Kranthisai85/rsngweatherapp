import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rsngweatherapp/models/weather.model.dart';
import 'package:rsngweatherapp/services/weather.service.dart';

class WeatherProvider with ChangeNotifier {
  Weather? _weather;
  bool _isLoading = false;
  String _error = '';
  final WeatherService _weatherService = WeatherService();

  Weather? get weather => _weather;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchWeatherByCity(String city) async {
    _isLoading = true;
    notifyListeners();

    try {
      _weather = await _weatherService.fetchWeather(city);
      _error = '';
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchWeatherByLocation() async {
    _isLoading = true;
    notifyListeners();

    try {
      PermissionStatus permission =
          await Permission.locationWhenInUse.request();
      if (permission.isGranted) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        String city = await _weatherService.getCityNameFromCoordinates(
            position.latitude, position.longitude);
        await fetchWeatherByCity(city);
      } else {
        _error = 'Location permission not granted';
      }
    } catch (e) {
      _error = 'Failed to get location: ${e.toString()}';
    }

    _isLoading = false;
    notifyListeners();
  }
}
