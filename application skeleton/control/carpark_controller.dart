// This class implements the CarparkController with
// the attributes url and apikey
import '../entity/carpark.dart';

class CarparkController {
  // url to access the carpark availability api
  String url =
      'http://datamall2.mytransport.sg/ltaodataservice/CarParkAvailabilityv2';
  // apikey to access the carpark availability api
  Map<String, String> apikey = {'AccountKey': 'AYM2LIAeS5GGP+VYNd7Cdw=='};
  // get a carpark from list of all carparks using carparkID
  CarPark getCarpark(String carparkID) {
    return CarPark();
  }

  // get list of all carparks
  List<CarPark> getAllCarparks() {
    return [];
  }
}
