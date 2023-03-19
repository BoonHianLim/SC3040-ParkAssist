import 'package:flutter/material.dart';
import 'package:parkassist/boundary/infoInterface.dart';
import 'package:parkassist/boundary/map_interface.dart';
import 'package:parkassist/control/searchController.dart';
import 'package:parkassist/entity/carParkList.dart';
import 'package:parkassist/control/carParkController.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//function to get all carpark locations(development area)


class SearchController{
  // static List<String> getCarparkDevelopments1(Future<List<CarPark>> carParkList) {
  //   List<String> developments = [];
  //   carParkList.carparks?.forEach((carPark) {
  //     if (carPark.development != null) {
  //       developments.add(carPark.development!);
  //     }
  //   });
  //   return developments;
  // }

  List<String> getCarparkDevelopments(){
    Future<List<CarPark>> developments = CarParkController().getAllCarparks();
    developments.then;{
      List<String> carparkdevelopment = CarPark.map((carPark) => carPark.development!).toList(); 
      print(carparkdevelopment);
      return carparkdevelopment;
    };
  }
   

}






