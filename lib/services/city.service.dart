import 'package:dio/dio.dart';

class CityService {
  final Dio _dio = Dio();

  Future<List<String>> fetchCities(String query) async {
    const String apiKey = 'f1e1905b57mshda5b56a4573d273p1f8323jsn8fec80a2f743';
    const String url = 'https://wft-geo-db.p.rapidapi.com/v1/geo/cities';

    try {
      final response = await _dio.get(url,
          queryParameters: {
            'namePrefix': query,
            'limit': 5,
          },
          options: Options(headers: {
            'x-rapidapi-key': apiKey,
            'x-rapidapi-host': 'wft-geo-db.p.rapidapi.com',
          }));

      List<dynamic> data = response.data['data'];
      return data.map((city) => city['name'] as String).toList();
    } catch (error) {
      throw Exception('Failed to load cities');
    }
  }
}
