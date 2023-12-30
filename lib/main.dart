import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/getLocation.dart';
import 'package:weather_app/getWeather.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Weather App',
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  late GetLocation getLocation;
  late GetWeather getWeather;

  @override
  void initState() {
    super.initState();
    getLocation = Get.put(GetLocation());
    getWeather = Get.put(GetWeather());
    getLocation.checkLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GetWeather>(
      init: GetWeather(),
      builder: (getWeather) {
        return Scaffold(
          backgroundColor: Colors.grey.shade900,
          body: FutureBuilder(
            future: getWeather.getWeather(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 35,
                      ),
                      Text(
                        "Loading...",
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 19),
                      ),
                    ],
                  ),
                );
              } else {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final weatherData = snapshot.data;
                  final mainCondition = weatherData!['weather'][0]['main'];
                  final temperature = weatherData['main']['temp'];

                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_on_sharp,
                              color: Colors.grey.shade300,
                              size: 35,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${weatherData['name']}',
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                            ),
                          ],
                        ),
                        LottieBuilder.asset(
                            getWeather.getAnimationPath(mainCondition)),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${temperature.toString()}°',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade300,
                            ),
                          ),
                        ),
                        Text(
                          "Developer : @hosivay",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        )
                      ],
                    ),
                  );
                }
              }
            },
          ),
        );
      },
    );
  }
}
