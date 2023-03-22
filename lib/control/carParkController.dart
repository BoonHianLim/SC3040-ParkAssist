import 'dart:async';
import '../entity/carParkList.dart';
import '../control/favouritesController.dart';
import 'package:http/http.dart';
import 'dart:convert';

class CarParkController {
  static String Url = 'http://datamall2.mytransport.sg/ltaodataservice/CarParkAvailabilityv2';
  static Map<String, String> apikey = {'AccountKey': 'AYM2LIAeS5GGP+VYNd7Cdw=='};
  static List<CarPark> carparkList = [];

  static List<CarPark> getCarparkList() {
    return carparkList;
  }

  static Future<void> updateCarparkList() async {
    await getAllCarparks().then((value) {
      carparkList = value;
    });
    print("carpark list updated");
  }

  static getCarparkByID(String id) {
    for (var i = 0; i < carparkList.length; i++) {
      if (carparkList[i].carParkID == id) {
        return carparkList[i];
      }
    }
  }

  //return list of all carpark objects as future, filter out non hdb carparks
  static Future<List<CarPark>> getAllCarparks() async {
    List<CarPark> carparkList = [];
    var client = Client();
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
      print("e");
      return carparkList;
    }
    return carparkList;
  }

  //return single carpark object based on carparkid as future
  Future<CarPark> getCarpark(carParkID) async {
    var carparkList;
    var client = Client();
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
  // Future<List<CarPark>> getAllCarparks() async {
  //   List<CarPark> carparkList = [];
  //   var client = http.Client();
  //   try {
  //     for (var apipage = 0; apipage < 5; apipage++) {
  //       String pageUrl;
  //       if (apipage == 0) {
  //         pageUrl = Url;
  //       } else {
  //         pageUrl = Url + r"?$skip=" + (apipage * 500).toString();
  //       }
  //       var response = await client.get(Uri.parse(pageUrl), headers: apikey);
  //       if (response.statusCode == 200) {
  //         var jsonMap = json.decode(response.body);
  //         carparkList += CarParkList.fromJson(jsonMap).carparks!;
  //       }
  //     }
  //   } catch (Exception) {
  //     return carparkList;
  //   }
  //   return carparkList;
  // }

  static List<CarPark> addToFavourites(List<CarPark> favList, CarPark carpark) {
    return FavouritesController.addToFavourites(favList, carpark);
  }
}

// Future<void> main() async {
//   await CarParkController.updateCarparkList();
//   CarParkController.getCarparkList().forEach((element) {
//     print(
//         "name: ${element.development}, available lots: ${element.availableLots}, agency:${element.agency}");
//   });
// }
