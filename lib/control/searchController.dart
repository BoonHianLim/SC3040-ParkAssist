import 'package:parkassist/entity/carParkList.dart';
import 'package:parkassist/control/carParkController.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;


//function to get all carpark locations(development area)
class SearchController{
  static List<String> getCarparkDevelopments(CarParkList carParkList) {
  List<String> developments = [];
  carParkList.carparks?.forEach((carPark) {
    if (carPark.development != null) {
      developments.add(carPark.development!);
    }
  });
  return developments;
  }


}






