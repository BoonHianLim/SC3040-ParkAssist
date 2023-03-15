import 'dart:async';
import '../entity/carParkList.dart';
import '../control/favouritesController.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CarParkController {
  //somehow only got hdb info even though api doc says got hdb, ura, lta:
  static String Url =
      'http://datamall2.mytransport.sg/ltaodataservice/CarParkAvailabilityv2';
  Map<String, String> apikey = {'AccountKey': 'AYM2LIAeS5GGP+VYNd7Cdw=='};

  //return single carpark object based on carparkid as future
  Future<CarPark> getCarpark(carParkID) async {
    var carparkList;
    var client = http.Client();
    try {
      //around 2500 carparks but each api call returns 500 results only. iterate through all api pages <2500 / 500 = 5
      for (var apipage = 0; apipage < 5; apipage++) {
        var pageUrl;
        if (apipage == 0) {
          pageUrl = Url;
        } else {
          pageUrl = Url + r"?$skip=" + (apipage * 500).toString();
        }
        var response = await client.get(Uri.parse(pageUrl), headers: apikey);
        if (response.statusCode == 200) {
          var jsonMap = json.decode(response.body);
          carparkList = CarParkList.fromJson(jsonMap);
          for (var i = 0; i < carparkList.carparks.length; i++) {
            if (carparkList.carparks[i].carParkID == carParkID) {
              return carparkList.carparks[i];
            }
          }
        }
      }
    } catch (Exception) {
      print(Exception);
      return CarPark();
    }
    return CarPark();
  }

  //return list of all carpark objects as future
  Future<List<CarPark>> getAllCarparks() async {
    List<CarPark> carparkList = [];
    var client = http.Client();
    try {
      for (var apipage = 0; apipage < 5; apipage++) {
        String pageUrl;
        if (apipage == 0) {
          pageUrl = Url;
        } else {
          pageUrl = Url + r"?$skip=" + (apipage * 500).toString();
        }
        var response = await client.get(Uri.parse(pageUrl), headers: apikey);
        if (response.statusCode == 200) {
          var jsonMap = json.decode(response.body);
          carparkList += CarParkList.fromJson(jsonMap).carparks!;
        }
      }
    } catch (Exception) {
      return carparkList;
    }
    return carparkList;
  }

  static List<CarPark> addToFavourites(List<CarPark> favList, CarPark carpark) {
    return FavouritesController.addToFavourites(favList, carpark);
  }
}
