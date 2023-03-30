import 'package:flutter/material.dart';
import 'package:parkassist/entity/carpark.dart';
import 'dart:developer';

class CalculatorController {
  static DateTime startDateTime = DateTime(0000, 0, 0, 0, 0, 0, 0, 0);
  static DateTime endDateTime = DateTime(0000, 0, 0, 0, 0, 0, 0, 0);
  static String price = '';
  static bool logging = true;
  static CarPark carpark = CarPark(
      carParkID: '',
      area: '',
      development: '',
      location: '',
      availableLots: 0,
      lotType: '',
      agency: '');

  static final List<String> hdbCentralAreaList = [
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

  static resetDateTime() {
    setEndDateTime(DateTime(0, 0, 0, 0, 0, 0, 0, 0));
    setStartDateTime(DateTime(0, 0, 0, 0, 0, 0, 0, 0));
  }

  static setStartDateTime(DateTime dateTime) {
    startDateTime = dateTime;
  }

  static setEndDateTime(DateTime dateTime) {
    endDateTime = dateTime;
  }

  static setCarparkInfo(CarPark info) {
    carpark.carParkID = info.carParkID;
    carpark.area = info.area;
    carpark.development = info.development;
    carpark.location = info.location;
    carpark.availableLots = info.availableLots;
    carpark.lotType = info.lotType;
    carpark.agency = info.agency;
  }

  static Future<DateTime?> pickDate(BuildContext context) {
    return showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year),
        lastDate: DateTime(DateTime.now().year + 3));
  }

  static Future<TimeOfDay?> pickTime(BuildContext context) {
    return showTimePicker(
        context: context,
        initialEntryMode: TimePickerEntryMode.input,
        initialTime: TimeOfDay(
            hour: DateTime.now().hour, minute: DateTime.now().minute));
  }

  static Duration getTotalHours() {
    if (endDateTime.minute >= 0 && startDateTime.minute >= 0) {
      return endDateTime.difference(startDateTime);
    }
    throw (ex) {
      return const Duration(days: 0, hours: 0, minutes: 0, seconds: 0);
    };
  }

  static bool validTime() {
    if (getTotalHours().inMinutes > 0) {
      return true;
    } else {
      return false;
    }
  }

  static calculateParkingCost() {
    double tempPrice = calculateParkingFee();
    if (!validTime()) {
      price = 'Set End Date & Time to be after Start Date & Time';
    } else {
      if (tempPrice > 0) {
        price = '\$ ${tempPrice.toStringAsFixed(2)}';
      } else {
        price = 'First 15 minutes is free';
      }
    }
  }

  static List<DateTime> calculateDaysInterval(
      DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
  }

  static int isSunday() {
    List<DateTime> test = calculateDaysInterval(startDateTime, endDateTime);
    int sunday = 0;
    for (int i = 1; i < test.length - 1; i++) {
      if (test.elementAt(i).weekday == DateTime.sunday) {
        sunday += 1;
      }
    }
    return sunday;
  }

  static double calculateParkingFee() {
    double totalCost = 0;
    double firtsday = 0;
    double secondday = 0;
    double betweendays = 0;

    DateTime dummyStart =
        DateTime(endDateTime.year, endDateTime.month, endDateTime.day, 0, 0);
    DateTime temp = DateTime(
        startDateTime.year, startDateTime.month, startDateTime.day, 0, 0);
    DateTime dummyEnd = temp.add(const Duration(days: 1));

    int numOfSunday = isSunday();

    if (startDateTime.day == endDateTime.day) {
      totalCost = _calculateCentralCarpark(startDateTime, endDateTime);
    } else if (startDateTime.day != endDateTime.day &&
        endDateTime.difference(startDateTime).inHours <= 24) {
      totalCost = _calculateCentralCarpark(startDateTime, dummyEnd) +
          _calculateCentralCarpark(dummyStart, endDateTime);
    } else {
      if (startDateTime.day != endDateTime.day &&
          endDateTime.difference(startDateTime).inHours > 24) {
        firtsday = _calculateCentralCarpark(startDateTime, dummyEnd);
        secondday = _calculateCentralCarpark(dummyStart, endDateTime);
        if (hdbCentralAreaList.contains(carpark.carParkID)) {
          betweendays = (((endDateTime.difference(startDateTime).inMinutes -
                          dummyEnd.difference(startDateTime).inMinutes -
                          endDateTime.difference(dummyStart).inMinutes) /
                      1440) *
                  40.8 -
              numOfSunday * 40.8 +
              numOfSunday * 28.8);
        } else {
          betweendays = (((endDateTime.difference(startDateTime).inMinutes -
                      dummyEnd.difference(startDateTime).inMinutes -
                      endDateTime.difference(dummyStart).inMinutes) /
                  1440) *
              28.8);
        }

        totalCost = firtsday + secondday + betweendays;
      }
    }
    if (logging) {
      log("--------------- calculateParkingFee Method------------------- ");
      log('no of sunday : $numOfSunday');
      log('temp: $temp');
      log('dummynd: $dummyEnd');
      log('dummy end -startdate: ${dummyEnd.difference(startDateTime)}');

      log('first: $firtsday');
      log('second: $secondday');
      log('between: $betweendays');

      log('total duration datetime: ${endDateTime.difference(startDateTime).inMinutes}');
      log('first day minutes: ${dummyEnd.difference(startDateTime).inMinutes}');
      log('second day minutes: ${endDateTime.difference(dummyStart).inMinutes}');
      log('total: $totalCost');
    }
    return totalCost;
  }

  static CarPark getCarparkInfo() {
    return carpark;
  }

  static double _calculateCentralCarpark(DateTime start, DateTime end) {
    DateTime startrange = DateTime(start.year, start.month, start.day, 7, 0);
    DateTime endrange = DateTime(start.year, start.month, start.day, 17, 0);

    int surgeduration = 0;
    int normalduration = 0;
    int surgeDurationCost = 0;
    int normalDurationCost = 0;
    if (hdbCentralAreaList.contains(getCarparkInfo().carParkID) &&
        start.weekday != DateTime.sunday) {
      if (start.isBefore(startrange)) {
        if (end.isBefore(startrange)) {
          normalduration = end.difference(start).inMinutes;
        } else if ((end.isAfter(startrange) ||
                end.isAtSameMomentAs(startrange)) &&
            (end.isBefore(endrange) || end.isAtSameMomentAs(endrange))) {
          surgeduration = end.difference(startrange).inMinutes;
          normalduration = startrange.difference(start).inMinutes;
        } else {
          surgeduration = endrange.difference(startrange).inMinutes;
          normalduration = end.difference(start).inMinutes - surgeduration;
        }
      } else if ((start.isAfter(startrange) ||
              start.isAtSameMomentAs(startrange)) &&
          (start.isBefore(endrange) || start.isAtSameMomentAs(endrange))) {
        if ((end.isAfter(startrange) || end.isAtSameMomentAs(startrange)) &&
            (end.isBefore(endrange) || end.isAtSameMomentAs(endrange))) {
          surgeduration = end.difference(start).inMinutes;
        } else {
          normalduration = end.difference(endrange).inMinutes;
          surgeduration = endrange.difference(start).inMinutes;
        }
      } else if (start.isAfter(endrange)) {
        normalduration = end.difference(start).inMinutes;
      }
    } else {
      normalduration = end.difference(start).inMinutes;
    }
    surgeDurationCost = surgeduration ~/ 30;
    normalDurationCost = normalduration ~/ 30;

    if (surgeduration % 30 != 0) {
      surgeDurationCost += 1;
    }
    if (normalduration % 30 != 0) {
      normalDurationCost += 1;
    }

    if (logging) {
      log("--------------- calculateCentralCarpark Method------------------- ");
      log('surge: $surgeduration');
      log('normal: $normalduration');
      log('surgeCost: $surgeDurationCost');
      log('normalCost: $normalDurationCost');
      log('total cost: ${surgeDurationCost * 1.20 + normalDurationCost * 0.60}');
    }

    return (surgeduration + normalduration > 15)
        ? (surgeDurationCost * 1.20 + normalDurationCost * 0.60)
        : 0.00;
  }
}
