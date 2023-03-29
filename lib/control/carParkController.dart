import 'dart:async';
import '../entity/carParkList.dart';
import '../control/favouritesController.dart';
import 'package:http/http.dart';
import 'dart:convert';

///Controller class for getting information on car parks from the API
class CarParkController {
  ///URL of API
  static String url = 'http://datamall2.mytransport.sg/ltaodataservice/CarParkAvailabilityv2';

  ///API key to access the API
  static Map<String, String> apikey = {'AccountKey': 'AYM2LIAeS5GGP+VYNd7Cdw=='};

  ///List of carparks obtained from the API
  static List<CarPark> carparkList = [];

  ///Returns list of carparks
  static List<CarPark> getCarparkList() {
    return carparkList;
  }

  ///Update carpark list by calling API
  static Future<void> updateCarparkList() async {
    carparkList = await getAllCarparks();
    print("carpark list updated");
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
      print(e.toString());
      return carparkList;
    }
    return carparkList;
  }
}
/*
  //will be commented out
  //return single carpark object based on carparkid as future
  Future<CarPark> getCarpark(carParkID) async {
    var carparkList;
    var client = Client();
    try {
      //around 2500 carparks but each api call returns 500 results only. iterate through all api pages <2500 / 500 = 5
      for (var apipage = 0; apipage < 5; apipage++) {
        var pageUrl;
        if (apipage == 0) {
          pageUrl = url;
        } else {
          pageUrl = url + r"?$skip=" + (apipage * 500).toString();
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

  //return list of all carpark objects as future, replaced by function above
  // Future<List<CarPark>> getAllCarparks() async {
  //   List<CarPark> carparkList = [];
  //   var client = http.Client();
  //   try {
  //     for (var apipage = 0; apipage < 5; apipage++) {
  //       String pageUrl;
  //       if (apipage == 0) {
  //         pageUrl = url;
  //       } else {
  //         pageUrl = url + r"?$skip=" + (apipage * 500).toString();
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

// for testing
// Future<void> main() async {
//   await CarParkController.updateCarparkList();
//   CarParkController.getCarparkList().forEach((element) {
//     print(
//         "name: ${element.development}, available lots: ${element.availableLots}, agency:${element.agency}");
//   });
// }
*/