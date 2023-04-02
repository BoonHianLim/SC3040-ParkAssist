import 'dart:async';
import '../entity/carpark_list.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:parkassist/entity/carpark.dart';

///Controller class for getting information on car parks from the API
class CarParkController {
  ///URL of API
  static String url =
      'http://datamall2.mytransport.sg/ltaodataservice/CarParkAvailabilityv2';

  ///API key to access the API
  static Map<String, String> apikey = {
    'AccountKey': 'AYM2LIAeS5GGP+VYNd7Cdw=='
  };

  ///List of carparks obtained from the API
  static List<CarPark> carparkList = [];

  ///Returns list of carparks
  static List<CarPark> getCarparkList() {
    return carparkList;
  }

  ///Update carpark list by calling API
  static Future<void> updateCarparkList() async {
    carparkList = await getAllCarparks();
    //print("carpark list updated");
  }

  ///Gets a carpark from current list using id
  static getCarparkByID(String id) {
    for (var i = 0; i < carparkList.length; i++) {
      if (carparkList[i].carParkID == id) {
        return carparkList[i];
      }
    }
  }

  ///Calls the API, filter out non hdb and non type c carparks, then returns list of carparks as future
  static Future<List<CarPark>> getAllCarparks() async {
    List<CarPark> carparkList = [];
    var client = Client();
    try {
      for (var apipage = 0; apipage < 5; apipage++) {
        String pageUrl;
        if (apipage == 0) {
          pageUrl = url;
        } else {
          pageUrl = url + r"?$skip=" + (apipage * 500).toString();
        }
        var response = await client.get(Uri.parse(pageUrl), headers: apikey);
        if (response.statusCode == 200) {
          var jsonMap = json.decode(response.body);
          var list = CarParkList.fromJson(jsonMap);
          for (var i = 0; i < list.carparks!.length; i++) {
            CarPark cp = list.carparks![i];
            if (cp.agency == "HDB" && cp.lotType == "C") {
              carparkList.add(cp);
            }
          }
        }
      }
    } catch (e) {
      return carparkList;
    }
    return carparkList;
  }
}
