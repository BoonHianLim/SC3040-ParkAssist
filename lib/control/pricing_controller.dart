import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:parkassist/entity/pricing.dart';
import 'package:parkassist/entity/carParkList.dart';

//dummy calculatorcontroller for infoInterface's pricing text for now.
//hdb fee hardcoded from website, others from data.gov.sg. only tested for hdb as ltamall api only got hdb
class PricingController {
  static String Url =
      'https://data.gov.sg/api/action/datastore_search?resource_id=85207289-6ae7-4a56-9066-e6090a3684a5';

  Future<Records> getPricingStrings(CarPark carpark) async {
    var HDBCentralAreaList = [
      'ACB',
      'BBB',
      'BRB1',
      'CY',
      'DUXM',
      'HLM',
      'KAB',
      'KAS',
      'KAM',
      'PRM',
      'SLS',
      'SR1',
      'SR2',
      'TPM',
      'UCS',
      'WCB'
    ];
    if (carpark.agency == 'HDB') {
      if (HDBCentralAreaList.contains(carpark.carParkID)) {
        return Records(
          category: 'HDB',
          weekdaysRate1:
              r'$1.20 per half-hour (7:00am to 5:00pm, Mondays to Saturdays)',
          weekdaysRate2: r'$0.60 per half hour (Other hours)',
        );
      } else {
        return Records(
          category: 'HDB',
          weekdaysRate1: r'$0.60 per half-hour',
        );
      }
    } else {
      var pricing;
      var client = http.Client();
      try {
        Url = Url + '&q=' + carpark.development!.split(' ')[0];
        var response = await client.get(Uri.parse(Url));
        if (response.statusCode == 200) {
          var jsonMap = json.decode(response.body);
          pricing = Pricing.fromJson(jsonMap);
          for (var i = 0; i < pricing.result.records.length; i++) {
            if (pricing.result.records[i].carpark == carpark.development) {
              return pricing.result.records[i];
            }
          }
        }
      } catch (Exception) {
        return Records();
      }
      return Records();
    }
  }
}
