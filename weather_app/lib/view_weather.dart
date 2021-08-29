import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'package:weather_app/model/getWeather.dart';
import 'package:weather_app/model/model_data_weather.dart';

class WeatherApp extends StatefulWidget {
  const WeatherApp({Key? key}) : super(key: key);

  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  final translator = GoogleTranslator();
  ModelWeather _modelWeather = ModelWeather();
  ModelWeather? _data;

  String txtCity = "";
  String? cityName;
  var weatherMain;
  var temp;
  var windSpeed;
  var humidity;
  var sunRise, sunSet;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Thời tiết hôm nay"),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          child: Column(
            children: [
              showDataWeather(width: size.width),
              inputCity(width: size.width),
              submitCity(),
            ],
          ),
        ),
      ),
    );
  }

  Widget showDataWeather({width}) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      width: width * 0.9,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 3,
            offset: Offset(1, 1), // Shadow position
          ),
        ],
      ),
      child: Column(
        children: [
          topOfDataWeather(),
          bottomOfDataWeather(width: (width * 0.9)),
        ],
      ),
    );
  }

  Widget inputCity({width}) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      width: width * 0.7,
      child: TextFormField(
        cursorColor: Colors.blueAccent,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
          hintText: "Nhập tên thành phố",
        ),
        onChanged: (value) {
          setState(() {
            txtCity = value.trim();
          });
        },
      ),
    );
  }

  Widget submitCity() {
    DataWeather weather = DataWeather();
    return Container(
      child: TextButton(
          onPressed: () async {
            EasyLoading.show(
              status: "Đang tải.....",
              maskType: EasyLoadingMaskType.black,
            );

            try{
              _modelWeather = await weather.getDataWeather(txtCity);
              EasyLoading.showSuccess("Thành công",  maskType: EasyLoadingMaskType.black, duration: Duration(seconds: 1));
            }catch(_){
              EasyLoading.showError("Lỗi tải dữ liệu",  maskType: EasyLoadingMaskType.black, duration: Duration(seconds: 2));
            }

            setState(() {
              _data = _modelWeather;
              cityName = _data!.name;
              weatherMain =
              "${_data?.weather?.first.description!.substring(0, 1).toUpperCase()}"
                  "${_data?.weather?.first.description!.substring(1)}";
              temp = "${_data!.main!.temp}";
              windSpeed = _data!.wind!.speed;
              humidity = _data!.main!.humidity;
              sunRise = converterTime("${_data!.sys!.sunrise}");
              sunSet = converterTime("${_data!.sys!.sunset}");
              // _translate();
            });
          },
          child: Text("Tìm kiếm")),
    );
  }

  converterTime(data) {
    int? dataInt = int.tryParse("$data");
    final fDay = new DateFormat('HH:mm');
    return fDay.format(DateTime.fromMillisecondsSinceEpoch(dataInt! * 1000));
  }

  Widget topOfDataWeather() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 0),
              child: Text(
                "${cityName == null ? "----" : cityName}",
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 0),
              child: Container(
                height: 30,
                child: Row(
                  children: [
                    Text(
                      "${temp == null ? "----" : temp}",
                      style: TextStyle(fontSize: 20),
                    ),
                    Container(
                        alignment: Alignment.topCenter,
                        child: Text(
                          " o",
                          style: TextStyle(fontSize: 13),
                        )),
                    Text(
                      "C",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, right: 10),
          child: Text(
            "${weatherMain == "nullnull" ? "----" : weatherMain}",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }

  Widget bottomOfDataWeather({width}) {
    return Container(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 20),
            child: Text(
              "Độ ẩm: ${humidity == null ? "----" : humidity}",
              style: TextStyle(fontSize: 17),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 20),
            child: Text(
              "Sức gió: ${windSpeed == null ? "----" : windSpeed} m/s",
              style: TextStyle(fontSize: 17),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 20),
            child: Text(
              "Bình minh: ${sunRise == null ? "----" : sunRise}",
              style: TextStyle(fontSize: 17),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 20),
            child: Text(
              "Hoàng hôn: ${sunSet == null ? "----" : sunSet}",
              style: TextStyle(fontSize: 17),
            ),
          ),
        ],
      ),
    );
  }
}
