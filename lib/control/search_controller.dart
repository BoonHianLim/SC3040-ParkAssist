import 'package:parkassist/control/carpark_controller.dart';
import 'package:parkassist/entity/carpark.dart';

///Controller class for search
class SearchController {
  ///Returns list of carpark names
  static List<String> getDevString() {
    List<String> developments = [];
    List<CarPark> carparkList = CarParkController.getCarparkList();
    for (var i = 0; i < carparkList.length; i++) {
      var development = carparkList[i].development;
      if (development != null && development.isNotEmpty) {
        developments.add(development);
      }
    }
    return developments;
  }
}
