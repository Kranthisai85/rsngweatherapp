import 'package:dio/dio.dart';
import 'package:rsngweatherapp/models/weather.model.dart';

class WeatherService {
  final Dio _dio = Dio();
  final String apiKey = '9cda260dc9efeed46cf87db3cda7ff5c';

  Future<Weather> fetchWeather(String city) async {
    const String url = 'https://api.openweathermap.org/data/2.5/weather';

    try {
      final response = await _dio.get(url, queryParameters: {
        'q': city,
        'appid': apiKey,
        'units': 'metric',
      });

      return Weather.fromJson(response.data);
    } catch (error) {
      throw Exception('Failed to load weather data');
    }
  }

  Future<String> getCityNameFromCoordinates(double lat, double lon) async {
    const String url = 'http://api.openweathermap.org/geo/1.0/reverse';

    try {
      final response = await _dio.get(url, queryParameters: {
        'lat': lat,
        'lon': lon,
        'appid': apiKey,
      });

      return response.data[0]['name'];
    } catch (error) {
      throw Exception('Failed to get city name');
    }
  }
}
