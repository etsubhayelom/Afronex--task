import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:weather/consts/consts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:weather/widgets/weather_item.dart';

const String apiKey = '566506d1a95956a4f04e3dfe71d69cbf';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _cityController = TextEditingController();
  String searchQuery = '';
  String cityName = '';
  int temprature = 0;
  int maxTemp = 0;
  String weatherStateName = 'Loading..';
  int humidity = 0;
  int windSpeed = 0;

  var currentDate = 'Loading..';
  String imageUrl = '';
  int woeid = 44418;
  String location = 'London';
  var selectedCities = City.getSelectedCities();
  List<String> cities = ['London'];
  List<dynamic> consolidateWeatherList = [];

  Future<void> fetchWeatherData(String location) async {
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$location&appid=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final weatherData = json.decode(response.body);
      var consolidatedWeather = weatherData['consolidated_weather'];

      setState(() {
        temprature = (weatherData['main']['temp'] - 273.15).round();
        maxTemp = (weatherData['main']['temp_max'] - 273.15).round();
        weatherStateName = weatherData['weather'][0]['main'];
        humidity = weatherData['main']['humidity'];
        windSpeed = weatherData['wind']['speed'].round();
        currentDate = DateTime.now().toString();
        imageUrl = determineImageUrl(weatherStateName);
      });
    } else {
      print('Error fetching weather data: ${response.statusCode}');
    }
  }

  String determineImageUrl(String weatherStateName) {
    imageUrl = weatherStateName.replaceAll(' ', '').toLowerCase();
    return imageUrl;
  }

  //Get the Where on earth id
  Future<void> fetchLocationData(String location) async {
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$location&appid=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final locationData = json.decode(response.body);
      setState(() {
        cityName = locationData['name'];

        temprature = (locationData['main']['temp'] - 273.15).round();
        maxTemp = (locationData['main']['temp_max'] - 273.15).round();
        weatherStateName = locationData['weather'][0]['main'];
        humidity = locationData['main']['humidity'];
        windSpeed = locationData['wind']['speed'].round();
        currentDate = DateTime.now().toString();
        imageUrl = determineImageUrl(weatherStateName);
      });
    } else {
      print('Error fetching location data: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    fetchLocationData(location).then((_) {
      fetchWeatherData(location);
    }).catchError((error) {
      print('Error fetching data: $error');
    });

    //For all the selected cities from our City model, extract the city and add it to our original cities list
    for (int i = 0; i < selectedCities.length; i++) {
      cities.add(selectedCities[i].city);
    }
    super.initState();
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  final Shader linearGradient = const LinearGradient(
    colors: <Color>[Color(0xffABCFF2), Color(0xff9AC6F3)],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    Size size = MediaQuery.of(context).size;
    print(consolidateWeatherList.length);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          titleSpacing: 0,
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            width: size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 4,
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton(
                      value: location,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: cities.map((String location) {
                        return DropdownMenuItem(
                            value: location, child: Text(location));
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          location = newValue!;
                          fetchLocationData(location);
                          fetchWeatherData(location);
                        });
                      }),
                )
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextField(
                  onChanged: (searchText) {
                    setState(() {
                      searchQuery = searchText;
                    });
                  },
                  onSubmitted: (searchText) {
                    setState(() {
                      searchQuery = searchText;
                    });
                    fetchLocationData(searchQuery);
                    fetchWeatherData(searchQuery);
                  },
                  controller: _cityController,
                  autofocus: true,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: primaryColor,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          _cityController.clear();
                          setState(() {
                            searchQuery = '';
                          });
                        },
                        child: Icon(
                          Icons.close,
                          color: primaryColor,
                        ),
                      ),
                      hintText: 'Search city',
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: primaryColor,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  cityName.isEmpty ? 'London' : cityName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                  ),
                ),
                Text(
                  currentDate,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(
                  height: 70,
                ),
                Container(
                  width: size.width,
                  height: 200,
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(.5),
                          offset: const Offset(0, 25),
                          blurRadius: 10,
                          spreadRadius: -12,
                        )
                      ]),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        top: -40,
                        left: 20,
                        child: imageUrl == ''
                            ? const Text('')
                            : Image.asset(
                                'assets/' + imageUrl + '.png',
                                width: 150,
                              ),
                      ),
                      Positioned(
                        bottom: 30,
                        left: 20,
                        child: Text(
                          weatherStateName.isEmpty
                              ? 'Clouds'
                              : weatherStateName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Positioned(
                          top: 20,
                          right: 20,
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    temprature.toString(),
                                    style: TextStyle(
                                      fontSize: 80,
                                      fontWeight: FontWeight.bold,
                                      foreground: Paint()
                                        ..shader = linearGradient,
                                    ),
                                  ),
                                ),
                                Text(
                                  'o',
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    foreground: Paint()
                                      ..shader = linearGradient,
                                  ),
                                )
                              ]))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      weatherItem(
                        text: 'Wind Speed',
                        value: windSpeed,
                        unit: 'km/h',
                        imageUrl: 'assets/windspeed.png',
                      ),
                      weatherItem(
                          text: 'Humidity',
                          value: humidity,
                          unit: '',
                          imageUrl: 'assets/humidity.png'),
                      weatherItem(
                        text: 'Wind Speed',
                        value: maxTemp,
                        unit: 'C',
                        imageUrl: 'assets/max-temp.png',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
