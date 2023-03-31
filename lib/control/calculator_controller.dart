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
    setEndDateTime(DateTime.now());
    setStartDateTime(DateTime.now());
  }

  ///Return currently selected carpark
  static CarPark getCarparkInfo() {
    return carpark;
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

  ///Use datepicker to get user to choose a start date
  ///
  ///Initial date shown is previously selected date, or current date if there were no previous selections
  ///
  ///Returns a future of selected date
  static Future<DateTime?> pickStartDate(BuildContext context) {
    return showDatePicker(
        context: context,
        initialDate: startDateTime,
        firstDate: DateTime(DateTime.now().year),
        lastDate: DateTime(DateTime.now().year + 3));
  }

  ///Use datepicker to get user to choose a end date
  ///
  ///Initial date shown is previously selected date, or current date if there were no previous selections
  ///
  ///Returns a future of selected date
  static Future<DateTime?> pickEndDate(BuildContext context) {
    return showDatePicker(
        context: context,
        initialDate: endDateTime,
        firstDate: DateTime(DateTime.now().year),
        lastDate: DateTime(DateTime.now().year + 3));
  }

  ///Use timepicker to get user to choose a start time
  ///
  ///Initial time shown is previously selected time, or current time if there were no previous selections
  ///
  ///Returns a future of selected time
  static Future<TimeOfDay?> pickStartTime(BuildContext context) {
    return showTimePicker(
        context: context,
        initialEntryMode: TimePickerEntryMode.input,
        initialTime:
            TimeOfDay(hour: startDateTime.hour, minute: startDateTime.minute));
  }

  ///Use timepicker to get user to choose a end time
  ///
  ///Initial time shown is previously selected time, or current time if there were no previous selections
  ///
  ///Returns a future of selected time
  static Future<TimeOfDay?> pickEndTime(BuildContext context) {
    return showTimePicker(
        context: context,
        initialEntryMode: TimePickerEntryMode.input,
        initialTime:
            TimeOfDay(hour: endDateTime.hour, minute: endDateTime.minute));
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

  static double calculateParkingFee() {
    if (logging) print('ran calculateParkingFee');
    DateTime start = startDateTime;
    DateTime end = endDateTime;
    double price = 0;
    if (start.isAtSameMomentAs(end)) {
      return 0;
    }
    if (!validTime()) {
      return -1;
    }

    List<DateTime> temp = splitDays(start, end);
    for (int i = 0; i < temp.length; i += 2) {
      DateTime s = temp[i];
      DateTime e = temp[i + 1];
      price += calculateCostSingleDate(s, e);
      if (logging) print('$s $e $price');
    }
    return price;
  }

  static double calculateCostSingleDate(DateTime start, DateTime end) {
    if (logging) print('ran calculateCostSingleDay');
    int peakDuration = 0;
    int nonPeakDuration = 0;
    double peakCost = 0;
    double nonPeakCost = 0;
    if (hdbCentralAreaList.contains(getCarparkInfo().carParkID)) {
      //central carpark
      //same date
      if (end.difference(start).inDays == 0) {
        //sunday
        if (start.weekday == DateTime.sunday) {
          nonPeakDuration = end.difference(start).inMinutes;
        }
        //not sunday
        else {
          DateTime startOfPeak =
              DateTime(start.year, start.month, start.day, 7, 0);
          DateTime endOfPeak =
              DateTime(start.year, start.month, start.day, 17, 0);
          end.difference(endOfPeak); //1700 to end
          startOfPeak.difference(start); //start to 0700
          //6 cases
          //start 0000-0700 end 0700-1700
          if (start.isBefore(startOfPeak.add(const Duration(seconds: 1))) &&
              end.isBefore(endOfPeak.add(const Duration(seconds: 1))) &&
              end.isAfter(startOfPeak.subtract(const Duration(seconds: 1)))) {
            if (logging) print('case1');
            nonPeakDuration += startOfPeak.difference(start).inMinutes;
            peakDuration += end.difference(startOfPeak).inMinutes;
          }
          //start 0700-1700 end 0700-1700
          else if (start
                  .isAfter(startOfPeak.subtract(const Duration(seconds: 1))) &&
              start.isBefore(endOfPeak.add(const Duration(seconds: 1))) &&
              end.isAfter(startOfPeak.subtract(const Duration(seconds: 1))) &&
              end.isBefore(endOfPeak.add(const Duration(seconds: 1)))) {
            if (logging) print('case2');
            peakDuration += end.difference(start).inMinutes;
          }
          //start 0700-1700 end 1700-2359
          else if (start
                  .isAfter(startOfPeak.subtract(const Duration(seconds: 1))) &&
              start.isBefore(endOfPeak.add(const Duration(seconds: 1))) &&
              end.isAfter(endOfPeak.subtract(const Duration(seconds: 1)))) {
            if (logging) print('case3');
            peakDuration += endOfPeak.difference(start).inMinutes;
            nonPeakDuration += end.difference(endOfPeak).inMinutes;
          }
          //start 0000-0700 end 0000-0700
          else if (start
                  .isBefore(startOfPeak.add(const Duration(seconds: 1))) &&
              end.isBefore(startOfPeak.add(const Duration(seconds: 1)))) {
            if (logging) print('case4');
            nonPeakDuration += end.difference(start).inMinutes;
          }
          //start 0000-0700 end 1700-2359
          else if (start
                  .isBefore(startOfPeak.add(const Duration(seconds: 1))) &&
              end.isAfter(endOfPeak.subtract(const Duration(seconds: 1)))) {
            if (logging) print('case5');
            peakDuration += endOfPeak.difference(startOfPeak).inMinutes;
            nonPeakDuration += startOfPeak.difference(start).inMinutes +
                end.difference(endOfPeak).inMinutes;
          }
          //start 1700-2359 end 1700-2359
          else if (start
                  .isAfter(endOfPeak.subtract(const Duration(seconds: 1))) &&
              end.isAfter(endOfPeak.subtract(const Duration(seconds: 1)))) {
            if (logging) print('case6');
            nonPeakDuration += end.difference(start).inMinutes;
          } else {
            if (logging) print('wtf');
          }
        }
      }
      //different date means 24hrs
      else {
        //if sunday
        if (start.weekday == DateTime.sunday) {
          nonPeakDuration = end.difference(start).inMinutes;
        }
        //not sunday
        else {
          nonPeakDuration += 840;
          peakDuration += 600;
        }
      }
    }
    //non central carpark
    else {
      if (logging) print("non central carpark");
      nonPeakDuration = end.difference(start).inMinutes;
    }
    peakCost = peakDuration ~/ 30 * 1.2;
    nonPeakCost = nonPeakDuration ~/ 30 * 0.6;
    if (peakDuration % 30 != 0) {
      peakCost += 1.2;
    }
    if (nonPeakDuration % 30 != 0) {
      nonPeakCost += 0.6;
    }
    return peakCost + nonPeakCost;
  }

  static List<DateTime> splitDays(DateTime start, DateTime end) {
    if (logging) print('ran splitDays');
    List<DateTime> list = [];
    list.add(start);
    int counter = 0;
    DateTime temp = start;
    while (end.difference(temp).inDays != 0) {
      list.add(DateTime(temp.year, temp.month, temp.day + 1, 0, 0));
      list.add(DateTime(temp.year, temp.month, temp.day + 1, 0, 0));
      temp = temp.add(const Duration(days: 1));
      counter++;
      if (counter > 10) break;
    }
    //if within 24hrs but not on same date
    if (end.day != temp.day) {
      list.add(DateTime(temp.year, temp.month, temp.day + 1, 0, 0));
      list.add(DateTime(temp.year, temp.month, temp.day + 1, 0, 0));
    }
    list.add(end);
    if (logging) print(list);
    return list;
  }

  // ///Calculate parking fare of a carpark not in central area
  // static double calculateParkingFee() {
  //   double totalCost = 0;
  //   double firstday = 0;
  //   double secondday = 0;
  //   double betweendays = 0;

  //   DateTime dummyStart =
  //       DateTime(endDateTime.year, endDateTime.month, endDateTime.day, 0, 0);
  //   DateTime temp = DateTime(
  //       startDateTime.year, startDateTime.month, startDateTime.day, 0, 0);
  //   DateTime dummyEnd = temp.add(const Duration(days: 1));

  //   int numOfSunday = isSunday();
  //   if (!validTime()) {
  //     return -1;
  //   }
  //   if (startDateTime.day == endDateTime.day) {
  //     totalCost = _calculateCentralCarpark(startDateTime, endDateTime);
  //   } else if (startDateTime.day != endDateTime.day &&
  //       endDateTime.difference(startDateTime).inHours <= 24) {
  //     totalCost = _calculateCentralCarpark(startDateTime, dummyEnd) +
  //         _calculateCentralCarpark(dummyStart, endDateTime);
  //   } else {
  //     if (startDateTime.day != endDateTime.day &&
  //         endDateTime.difference(startDateTime).inHours > 24) {
  //       firstday = _calculateCentralCarpark(startDateTime, dummyEnd);
  //       secondday = _calculateCentralCarpark(dummyStart, endDateTime);
  //       if (hdbCentralAreaList.contains(carpark.carParkID)) {
  //         betweendays = (((endDateTime.difference(startDateTime).inMinutes -
  //                         dummyEnd.difference(startDateTime).inMinutes -
  //                         endDateTime.difference(dummyStart).inMinutes) /
  //                     1440) *
  //                 40.8 -
  //             numOfSunday * 40.8 +
  //             numOfSunday * 28.8);
  //       } else {
  //         betweendays = (((endDateTime.difference(startDateTime).inMinutes -
  //                     dummyEnd.difference(startDateTime).inMinutes -
  //                     endDateTime.difference(dummyStart).inMinutes) /
  //                 1440) *
  //             28.8);
  //       }

  //       totalCost = firstday + secondday + betweendays;
  //     }
  //   }
  //   // for debugging
  //   if (logging) {
  //     log("--------------- calculateParkingFee Method------------------- ");
  //     log('no of sunday : $numOfSunday');
  //     log('temp: $temp');
  //     log('dummynd: $dummyEnd');
  //     log('dummy end -startdate: ${dummyEnd.difference(startDateTime)}');

  //     log('first: $firstday');
  //     log('second: $secondday');
  //     log('between: $betweendays');

  //     log('total duration datetime: ${endDateTime.difference(startDateTime).inMinutes}');
  //     log('first day minutes: ${dummyEnd.difference(startDateTime).inMinutes}');
  //     log('second day minutes: ${endDateTime.difference(dummyStart).inMinutes}');
  //     log('total: $totalCost');
  //   }
  //   return totalCost;
  // }

  // ///Calculate parking fare of a carpark in central area
  // static double _calculateCentralCarpark(DateTime start, DateTime end) {
  //   DateTime startrange = DateTime(start.year, start.month, start.day, 7, 0);
  //   DateTime endrange = DateTime(start.year, start.month, start.day, 17, 0);

  //   int surgeduration = 0;
  //   int normalduration = 0;
  //   int surgeDurationCost = 0;
  //   int normalDurationCost = 0;
  //   if (hdbCentralAreaList.contains(getCarparkInfo().carParkID) &&
  //       start.weekday != DateTime.sunday) {
  //     if (start.isBefore(startrange)) {
  //       if (end.isBefore(startrange)) {
  //         normalduration = end.difference(start).inMinutes;
  //       } else if ((end.isAfter(startrange) ||
  //               end.isAtSameMomentAs(startrange)) &&
  //           (end.isBefore(endrange) || end.isAtSameMomentAs(endrange))) {
  //         surgeduration = end.difference(startrange).inMinutes;
  //         normalduration = startrange.difference(start).inMinutes;
  //       } else {
  //         surgeduration = endrange.difference(startrange).inMinutes;
  //         normalduration = end.difference(start).inMinutes - surgeduration;
  //       }
  //     } else if ((start.isAfter(startrange) ||
  //             start.isAtSameMomentAs(startrange)) &&
  //         (start.isBefore(endrange) || start.isAtSameMomentAs(endrange))) {
  //       if ((end.isAfter(startrange) || end.isAtSameMomentAs(startrange)) &&
  //           (end.isBefore(endrange) || end.isAtSameMomentAs(endrange))) {
  //         surgeduration = end.difference(start).inMinutes;
  //       } else {
  //         normalduration = end.difference(endrange).inMinutes;
  //         surgeduration = endrange.difference(start).inMinutes;
  //       }
  //     } else if (start.isAfter(endrange)) {
  //       normalduration = end.difference(start).inMinutes;
  //     }
  //   } else {
  //     normalduration = end.difference(start).inMinutes;
  //   }
  //   surgeDurationCost = surgeduration ~/ 30;
  //   normalDurationCost = normalduration ~/ 30;

  //   if (surgeduration % 30 != 0) {
  //     surgeDurationCost += 1;
  //   }
  //   if (normalduration % 30 != 0) {
  //     normalDurationCost += 1;
  //   }
  //   // for debugging
  //   if (logging) {
  //     log("--------------- calculateCentralCarpark Method------------------- ");
  //     log('surge: $surgeduration');
  //     log('normal: $normalduration');
  //     log('surgeCost: $surgeDurationCost');
  //     log('normalCost: $normalDurationCost');
  //     log('total cost: ${surgeDurationCost * 1.20 + normalDurationCost * 0.60}');
  //   }

  //   return (surgeduration + normalduration > 15)
  //       ? (surgeDurationCost * 1.20 + normalDurationCost * 0.60)
  //       : 0.00;
  // }
}

// void main(List<String> args) {
//   CalculatorController.carpark.carParkID = "BBB";
//   CalculatorController.setStartDateTime(DateTime(2023, 4, 2, 12, 0, 0));
//   CalculatorController.setEndDateTime(
//     DateTime(2023, 4, 3, 16, 0, 0),
//   );
//   print(CalculatorController.calculateParkingFee());
//   return;
// }
