import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/apiKey.dart';
import 'package:weather_app/getLocation.dart';

class GetWeather extends GetxController {
  final GetLocation _getLocation = Get.put(GetLocation());

  Future<Map<String, dynamic>> getWeather() async {
    // ignore: unnecessary_null_comparison
    if (_getLocation.currentPosition == null) {
      await _getLocation.getCurrentLocation();
      update();
    }

    final String apiUrl =
        'https://api.openweathermap.org/data/2.5/weather?lat=${_getLocation.currentPosition!.latitude}&lon=${_getLocation.currentPosition!.longitude}&units=metric&appid=$apiKey';

    final http.Response response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  String getAnimationPath(String mainCondition) {
    switch (mainCondition) {
      case "Clouds":
      case "mist":
      case "smoke":
      case "haze":
      case "dust":
      case "fog":
        return "lib/assets/cloud.json";
      case "rain":
      case "drizzle":
      case "shower rain":
        return "lib/assets/rain.json";
      case "thunderstorm":
        return "lib/assets/thunder.json";
      case "clear":
        return "lib/assets/sunny.json";
      default:
        return "lib/assets/sunny.json";
    }
  }
}
