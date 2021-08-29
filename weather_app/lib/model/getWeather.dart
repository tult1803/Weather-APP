import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app/model/model_data_weather.dart';

class DataWeather{

  getDataWeather(String city) async{
    /// api.openweathermap.org/data/2.5/weather?q={city name}&appid={API key}
    String apiKey = "3b4640a3be671dbd216527b798a1a0de";
    final response = await http.get(
      Uri.https("api.openweathermap.org", "data/2.5/weather", {"q": city, "units" : "metric", "lang" : "vi", "appid": apiKey})
    );
    print('Status API Weather: ${response.statusCode}');
    return ModelWeather.fromJson(jsonDecode(response.body));
  }
}