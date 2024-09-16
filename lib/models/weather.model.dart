class Weather {
  final String description;
  final double temperature;
  final double feelsLike;
  final int humidity;

  Weather({
    required this.description,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      description: json['weather'][0]['description'],
      temperature: json['main']['temp'],
      feelsLike: json['main']['feels_like'],
      humidity: json['main']['humidity'],
    );
  }
}
