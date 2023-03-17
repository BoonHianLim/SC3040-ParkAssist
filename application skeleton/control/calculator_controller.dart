import 'package:flutter/material.dart';
import '../entity/carpark.dart';
// This class implements the CalculatorController with
// the attributes startDateTime, endDateTime, price and hdbCentralAreaList

class CalculatorController {
  // time to start calculating parking fare from
  late DateTime startDateTime;
  // time to calculate parking fare till
  late DateTime endDateTime;
  // price calculated
  late String price;
  // list of hdb carparks in central area
  List<String> hdbCentralAreaList = [];
  // reset startDateTime and endDateTime to default values
  void resetDateTime() {}
  // method for user to pick date
  DateTime pickDate() {
    return DateTime(2023);
  }

  // method for user to pick time
  TimeOfDay pickTime() {
    return const TimeOfDay(hour: 0, minute: 0);
  }

  // calculate parking fee given startTime and endTime has been selected
  double calculateParkingFee() {
    return 0;
  }

  // calculate parking fee for a central carpark given startTime and endTime has been selected
  double calculateCentralCarpark() {
    return 0;
  }

  // get list of days if duration selected by user exceeds a day
  List<DateTime> calculateDaysInterval() {
    return [];
  }

  // get info of carpark
  CarPark getCarparkInfo() {
    return CarPark();
  }
}
