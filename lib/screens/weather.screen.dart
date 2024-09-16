import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:rsngweatherapp/models/weather.model.dart';
import 'package:rsngweatherapp/providers/weather.provider.dart';
import 'package:rsngweatherapp/services/city.service.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final CityService _cityService = CityService();
  final TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<WeatherProvider>(context, listen: false)
        .fetchWeatherByLocation();
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('RSNG Weather App'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TypeAheadField(
                emptyBuilder: (context) {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      'Enter Your Location',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  );
                },
                builder: (context, controller, focusNode) {
                  return SizedBox(
                    height: 45,
                    child: TextFormField(
                      decoration: InputDecoration(
                          hintText: "Search Location",
                          hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontWeight: FontWeight.w300),
                          // labelText: 'Current Location',
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14.0, vertical: 8),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 250, 244, 253),
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(15)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(20)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(20))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your location';
                        }
                        return null;
                      },
                      controller: controller,
                      focusNode: focusNode,
                      autofocus: false,
                    ),
                  );
                },
                hideOnUnfocus: true,
                hideWithKeyboard: false,
                onSelected: (value) {
                  _cityController.text = value.toString();
                  weatherProvider.fetchWeatherByCity(value.toString());
                },
                suggestionsCallback: (pattern) async {
                  return await _cityService.fetchCities(pattern);
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text(suggestion.toString(),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    trailing: Icon(Icons.arrow_forward_ios),
                  );
                },
                // textFieldConfiguration: TextFieldConfiguration(
                //   decoration:
                //   inputStyle: TextStyle(fontSize: 16),
                // ),
                // suggestionsTextStyle: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              if (weatherProvider.isLoading) const CircularProgressIndicator(),
              if (weatherProvider.weather != null)
                WeatherDisplay(weather: weatherProvider.weather!),
              if (weatherProvider.error.isNotEmpty)
                Text('Error: ${weatherProvider.error}',
                    style: const TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ),
    );
  }
}

class WeatherDisplay extends StatelessWidget {
  final Weather weather;

  const WeatherDisplay({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.cloud, size: 100, color: Colors.blueAccent),
          const SizedBox(height: 16),
          Text(
            weather.description,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '${weather.temperature}°C',
            style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent),
          ),
          const SizedBox(height: 16),
          Text(
            weather.description,
            style: const TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 16),
          Text(
            'Feels like: ${weather.feelsLike}°C',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 16),
          Text(
            'Humidity: ${weather.humidity}%',
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
