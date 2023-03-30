import 'package:flutter/material.dart';
import 'package:parkassist/entity/carpark.dart';
import 'dart:developer';

///Controller class to manage parking fare calculator
class CalculatorController {
  ///Start date and time
  static DateTime startDateTime = DateTime(0000, 0, 0, 0, 0, 0, 0, 0);

  ///End date and time
  static DateTime endDateTime = DateTime(0000, 0, 0, 0, 0, 0, 0, 0);

  ///Price
  static String price = '';

  ///For debugging purposes
  ///
  ///If set to true console will log messages
  static bool logging = true;

  ///Currently selected carpark
  static CarPark carpark = CarPark(
      carParkID: '',
      area: '',
      development: '',
      location: '',
      availableLots: 0,
      lotType: '',
      agency: '');

  ///List of carpark codes in central area
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

  ///Reset start and end datetime
  static void resetDateTime() {
    setEndDateTime(DateTime(0, 0, 0, 0, 0, 0, 0, 0));
    setStartDateTime(DateTime(0, 0, 0, 0, 0, 0, 0, 0));
  }

  ///Set start datetime
  static void setStartDateTime(DateTime dateTime) {
    startDateTime = dateTime;
  }

  ///Set end datetime
  static void setEndDateTime(DateTime dateTime) {
    endDateTime = dateTime;
  }

  ///Set carpark info given a carpark
  static setCarparkInfo(CarPark cp) {
    carpark.carParkID = cp.carParkID;
    carpark.area = cp.area;
    carpark.development = cp.development;
    carpark.location = cp.location;
    carpark.availableLots = cp.availableLots;
    carpark.lotType = cp.lotType;
    carpark.agency = cp.agency;
  }

  ///Use datepicker to get user to choose a date
  ///
  ///Returns a future of selected date
  static Future<DateTime?> pickDate(BuildContext context) {
    return showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year),
        lastDate: DateTime(DateTime.now().year + 3));
  }

  ///Use timepicker to get user to choose a time
  ///
  ///Returns a future of selected time
  static Future<TimeOfDay?> pickTime(BuildContext context) {
    return showTimePicker(
        context: context,
        initialEntryMode: TimePickerEntryMode.input,
        initialTime: TimeOfDay(
            hour: DateTime.now().hour, minute: DateTime.now().minute));
  }

  ///Get total hours between start and end datetime and returns a Duration
  static Duration getTotalHours() {
    if (endDateTime.minute >= 0 && startDateTime.minute >= 0) {
      return endDateTime.difference(startDateTime);
    }
    throw (ex) {
      return const Duration(days: 0, hours: 0, minutes: 0, seconds: 0);
    };
  }

  ///Returns whether datetime given is valid
  static bool validTime() {
    if (getTotalHours().inMinutes > 0) {
      return true;
    } else {
      return false;
    }
  }

  ///Calculate parking cost and set price to it
  static void calculateParkingCost() {
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

  ///Returns a list of all dates between start to end date
  static List<DateTime> calculateDaysInterval(
      DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
  }

  ///Returns number of sundays in list of dates selected
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

  ///Calculate parking fare of a carpark not in central area
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
    // for debugging
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

  ///Return currently selected carpark
  static CarPark getCarparkInfo() {
    return carpark;
  }

  ///Calculate parking fare of a carpark in central area
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
    // for debugging
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
