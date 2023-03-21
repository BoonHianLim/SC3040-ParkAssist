import 'package:flutter/material.dart';
import 'package:parkassist/entity/carParkList.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;



class SearchController{

  static String urlList ='http://datamall2.mytransport.sg/ltaodataservice/CarParkAvailabilityv2';
  Map<String, String> apikey = {'AccountKey': 'AYM2LIAeS5GGP+VYNd7Cdw=='};
  var data = [];
  List<CarPark> results = [];

  Future<List<CarPark>> getDevList({String? query}) async {
    try {
      for (var apipage = 0; apipage < 5; apipage++) {
        var pageUrl;
          if (apipage == 0) {
            pageUrl = urlList;
          } else {
          pageUrl = urlList + r"?$skip=" + (apipage * 500).toString();
          }

        var response = await http.get(Uri.parse(pageUrl), headers: apikey);
        if (response.statusCode == 200) {
          data = json.decode(response.body);
          results = data.map((e) => CarPark.fromJson(e)).toList();
          if (query!= null){
            results = results.where((element) => element.development!.toLowerCase().contains((query.toLowerCase()))).toList();
          }
        } else {
          print("fetch error");
        }
      }
    } on Exception catch (e) {
      print('error: $e');
    }
    return results;
  }
}
   
// Future<Developments> getDevelopments(CarPark carpark) async {
//     if (carpark.development != null) {
      
//       }
 
//       } catch (Exception) {
//         return Developments();
//       }
//       return Developments();
//     }
  
  
//   class Developments {
//     String? development;
//     String? carParkID;
//     int? availableLots;

//     Developments(
//         {this.development,
//         this.availableLots,
//         this.carParkID});

//     Developments.fromJson(Map<String, dynamic> json) {
//       development = json['Development'];
//       availableLots = json['AvailableLots'];
//       carParkID = json['CarParkID'];
//     }

//     Map<String, dynamic> toJson() {
//       final Map<String, dynamic> data = new Map<String, dynamic>();
//       data['CarParkID'] = this.carParkID;
//       data['Development'] = this.development;
//       data['AvailableLots'] = this.availableLots;
//       return data;
//     }

//   }
  








