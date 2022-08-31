// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import '../model/earthquake_model.dart';

class EarthquakeProvider extends ChangeNotifier{
  EarthquakeModel? earthquakeModel;

  String? startTime;
  String? endTime;
  double minmagnitude = 0.0;

  setNewValue({required String st, required String et, required double mt}) {
    startTime = st;
    endTime = et;
    minmagnitude = mt;
  }

  getEarthquakeData() async {
    final uri = Uri.parse(
        'https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime=$startTime&endtime=$endTime&minmagnitude=$minmagnitude&orderby=time&orderby=magnitude');
    try {
      final response = await get(uri);
      final map = json.decode(response.body);
      if (response.statusCode == 200) {
        earthquakeModel = EarthquakeModel.fromJson(map);
        print(earthquakeModel!.features!.length);
        notifyListeners();
      } else {
        print('else block exicute');
      }
    } catch (error) {
      print('Error $error');
    }
  }
}