// weather_model.dart
class Weather {
  final String description;
  final double temperature;
  final double windSpeed;
  final int humidity;
  final String icon;

  Weather({
    required this.description,
    required this.temperature,
    required this.windSpeed,
    required this.humidity,
    required this.icon,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      description: json['weather'][0]['description'],
      temperature: json['main']['temp'],
      windSpeed: json['wind']['speed'],
      humidity: json['main']['humidity'],
      icon: json['weather'][0]['icon'],
    );
  }
}

class HourlyForecast {
  final String time;
  final double temperature;
  final String icon;

  HourlyForecast({
    required this.time,
    required this.temperature,
    required this.icon,
  });

  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    return HourlyForecast(
      time: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000)
          .toLocal()
          .toString()
          .substring(0, 10),
      temperature: json['main']['temp'],
      icon: json['weather'][0]['icon'],
    );
  }
}

class DailyForecast {
  final String date;
  final double maxTemp;
  final double minTemp;
  final String icon;

  DailyForecast({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.icon,
  });

  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    return DailyForecast(
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000)
          .toLocal()
          .toString()
          .substring(0, 10),
      maxTemp: json['temp']['max'],
      minTemp: json['temp']['min'],
      icon: json['weather'][0]['icon'],
    );
  }
}
