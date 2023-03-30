/**
 * Testing module
 * ### Equivalence Class Testing
 * ### Boundary Class Testing
 * ### Control Flow Testing
 * 
 * Functions
 * - matrixTest(List<DateTime> x, List<DateTime> y, List<DateTime> expected)
 * - singleTest(DateTime x, DateTime y, DateTime expected)
 * 
 * Pseudocode
 * - Direct application to calculator page (via the CORRECT carpark)
 * - Testing module inputs the date and time to test
 * - App returns output
 * - If correct, (optional) show that it's correct
 * - If incorrect, show the test no, inputs, expected, returned
 */

import 'dart:developer';

import 'package:flutter_test/flutter_test.dart';
import 'package:parkassist/control/calculator_controller.dart';
import 'package:parkassist/entity/carpark_list.dart';
import 'package:parkassist/entity/carpark.dart';

void main() {
  // disable calculator logging because these tests will be ran many times
  CalculatorController.logging = false;

  group("Simple Test : \n", () {
    test("Testing simple function", () {
      int a = 1;
      expect(a, 1);
    });
  });

  group("Fetch From CalculatorController class Test : \n", () {
    CalculatorController.startDateTime = DateTime(2023, 3, 27, 9, 0, 0);
    CalculatorController.endDateTime = DateTime(2023, 3, 27, 10, 0, 0);
    CalculatorController.carpark = CarPark(
        carParkID: 'testing',
        area: 'BBB',
        development: '',
        location: '',
        availableLots: 0,
        lotType: '',
        agency: '');

    test("calculateParkingFee() Simple Test 1", () {
      expect(CalculatorController.calculateParkingFee(), 1.2);
    });

    test("calculateParkingFee() Simple Test 2", () {
      expect(CalculatorController.calculateParkingFee(), 1.2);
    });
  });

  log("--------------------------------------------------");
  log("         1. EQUIVALENCE CLASS TESTING");
  log("--------------------------------------------------");

  int counter = 1;
  List<DateTime> xHeader = [];
  List<DateTime> yHeader = [];
  List<List<double>> expectedAns = [[]];
  group("Set 1: Invalid input / Outside Central Area / Sunday", () {
    _singleTest(
        counter++,
        CalculatorController.calculateParkingFee as Function(void p1),
        false,
        DateTime(2023, 4, 3, 12, 0, 0),
        DateTime(2023, 4, 2, 12, 0, 0),
        -1);
    _singleTest(
        counter++,
        CalculatorController.calculateParkingFee as Function(void p1),
        false,
        DateTime(2023, 4, 3, 18, 0, 0),
        DateTime(2023, 4, 3, 21, 0, 0),
        3.6);
    _singleTest(
        counter++,
        CalculatorController.calculateParkingFee as Function(void p1),
        false,
        DateTime(2023, 4, 2, 12, 0, 0),
        DateTime(2023, 4, 2, 15, 0, 0),
        3.6);
  });

  group("Set 2: Central area & Same day parking & Non-Sunday", () {
    _singleTest(
        counter++,
        CalculatorController.calculateParkingFee as Function(void p1),
        true,
        DateTime(2023, 4, 3, 2, 0, 0),
        DateTime(2023, 4, 3, 5, 0, 0),
        3.6);
    _singleTest(
        counter++,
        CalculatorController.calculateParkingFee as Function(void p1),
        true,
        DateTime(2023, 4, 3, 6, 0, 0),
        DateTime(2023, 4, 3, 18, 0, 0),
        26.4);
    _singleTest(
        counter++,
        CalculatorController.calculateParkingFee as Function(void p1),
        true,
        DateTime(2023, 4, 3, 12, 0, 0),
        DateTime(2023, 4, 3, 15, 0, 0),
        7.2);
  });

  group(
      "Set 3: Central area & Start date and end date differs by one day & Start day is a Sunday",
      () {
    _singleTest(
        counter++,
        CalculatorController.calculateParkingFee as Function(void p1),
        true,
        DateTime(2023, 4, 2, 6, 0, 0),
        DateTime(2023, 4, 3, 3, 0, 0),
        -1); //!!
    _singleTest(
        counter++,
        CalculatorController.calculateParkingFee as Function(void p1),
        true,
        DateTime(2023, 4, 2, 12, 0, 0),
        DateTime(2023, 4, 3, 3, 0, 0),
        -1); //!!
    _singleTest(
        counter++,
        CalculatorController.calculateParkingFee as Function(void p1),
        true,
        DateTime(2023, 4, 2, 18, 0, 0),
        DateTime(2023, 4, 3, 3, 0, 0),
        -1); //!!
  });

  group(
      "Set 4: Central area & Start date and end date differs by one day & End day is a Sunday",
      () {
    _singleTest(
        counter++,
        CalculatorController.calculateParkingFee as Function(void p1),
        true,
        DateTime(2023, 4, 1, 12, 0, 0),
        DateTime(2023, 4, 2, 6, 0, 0),
        -1); //!!
    _singleTest(
        counter++,
        CalculatorController.calculateParkingFee as Function(void p1),
        true,
        DateTime(2023, 4, 1, 12, 0, 0),
        DateTime(2023, 4, 2, 12, 0, 0),
        -1); //!!
    _singleTest(
        counter++,
        CalculatorController.calculateParkingFee as Function(void p1),
        true,
        DateTime(2023, 4, 1, 12, 0, 0),
        DateTime(2023, 4, 2, 18, 0, 0),
        -1); //!!
  });

  group(
      "Set 5: Central area & Start date and end date differs by one day & None of the days are Sundays",
      () {
    xHeader = [
      DateTime(2022, 4, 3, 6, 0, 0),
      DateTime(2022, 4, 3, 12, 0, 0),
      DateTime(2022, 4, 3, 18, 0, 0)
    ];
    yHeader = [
      DateTime(2022, 4, 4, 6, 0, 0),
      DateTime(2022, 4, 4, 12, 0, 0),
      DateTime(2022, 4, 4, 18, 0, 0)
    ];
    expectedAns = [[]]; //!!

    _matrixTest(CalculatorController.calculateParkingFee() as Function(void p1),
        true, xHeader, yHeader, expectedAns);
  });

  group(
      "Set 6: Central area & Start date and end date differs by at least two days & None of the days are Sundays",
      () {
    xHeader = [
      DateTime(2022, 4, 3, 6, 0, 0),
      DateTime(2022, 4, 3, 12, 0, 0),
      DateTime(2022, 4, 3, 18, 0, 0)
    ];
    yHeader = [
      DateTime(2022, 4, 5, 6, 0, 0),
      DateTime(2022, 4, 5, 12, 0, 0),
      DateTime(2022, 4, 5, 18, 0, 0)
    ];
    expectedAns = [[]]; //!!

    _matrixTest(CalculatorController.calculateParkingFee() as Function(void p1),
        true, xHeader, yHeader, expectedAns);
  });

  group(
      "Set 7: Central area & Start date and end date differs by at least two days & The full parking day contains a Sunday",
      () {
    xHeader = [
      DateTime(2022, 4, 1, 6, 0, 0),
      DateTime(2022, 4, 1, 12, 0, 0),
      DateTime(2022, 4, 1, 18, 0, 0)
    ];
    yHeader = [
      DateTime(2022, 4, 3, 6, 0, 0),
      DateTime(2022, 4, 3, 12, 0, 0),
      DateTime(2022, 4, 3, 18, 0, 0)
    ];
    expectedAns = [[]]; //!!

    _matrixTest(CalculatorController.calculateParkingFee() as Function(void p1),
        true, xHeader, yHeader, expectedAns);
  });

  log("--------------------------------------------------");
  log("          2. BOUNDARY VALUE TESTING");
  log("--------------------------------------------------");

  counter = 1;
  xHeader = [];
  yHeader = [];
  expectedAns = [[]];

  group("Set 1: Invalid input / Outside Central Area / Sunday", () {
    _singleTest(
        counter++,
        CalculatorController.calculateParkingFee as Function(void p1),
        false,
        DateTime(2023, 4, 3, 12, 0, 0),
        DateTime(2023, 4, 2, 12, 0, 0),
        -1);
    _singleTest(
        counter++,
        CalculatorController.calculateParkingFee as Function(void p1),
        false,
        DateTime(2023, 4, 3, 18, 0, 0),
        DateTime(2023, 4, 3, 21, 0, 0),
        3.6);
    _singleTest(
        counter++,
        CalculatorController.calculateParkingFee as Function(void p1),
        false,
        DateTime(2023, 4, 2, 12, 0, 0),
        DateTime(2023, 4, 2, 15, 0, 0),
        3.6);
  });

  group("Set 2: Central area & Same day parking & Non-Sunday", () {
    xHeader = _generateMatrixHeaders(DateTime(2023, 4, 3), "x");
    yHeader = _generateMatrixHeaders(DateTime(2023, 4, 3), "y");
    expectedAns = [[]]; //!!

    _matrixTest(CalculatorController.calculateParkingFee() as Function(void p1),
        true, xHeader, yHeader, expectedAns);
  });

  group(
      "Set 3: Central area & Start date and end date differs by one day & Start day is a Sunday",
      () {
    xHeader = _generateMatrixHeaders(DateTime(2023, 4, 2), "x");
    DateTime endDate = DateTime(2023, 4, 3, 3, 0, 0);
    List<double> expected1DAns = []; //!!

    counter = 1;
    for (int i = 0; i < xHeader.length; i++) {
      _singleTest(
          counter++,
          CalculatorController.calculateParkingFee() as Function(void p1),
          true,
          xHeader[i],
          endDate,
          expected1DAns[i]);
    }
  });

  group(
      "Set 4: Central area & Start date and end date differs by one day & End day is a Sunday",
      () {
    DateTime startDate = DateTime(2023, 4, 3, 3, 0, 0);
    List<DateTime> yHeader = _generateMatrixHeaders(DateTime(2023, 4, 2), "y");
    List<double> expected1DAns = []; //!!

    counter = 1;
    for (int i = 0; i < xHeader.length; i++) {
      _singleTest(
          counter++,
          CalculatorController.calculateParkingFee() as Function(void p1),
          true,
          startDate,
          yHeader[i],
          expected1DAns[i]);
    }
  });

  group(
      "Set 5: Central area & Start date and end date differs by one day & None of the days are Sundays",
      () {
    xHeader = _generateMatrixHeaders(DateTime(2023, 4, 3), "x");
    yHeader = _generateMatrixHeaders(DateTime(2023, 4, 4), "y");
    expectedAns = [[]]; //!!

    _matrixTest(CalculatorController.calculateParkingFee() as Function(void p1),
        true, xHeader, yHeader, expectedAns);
  });

  group(
      "Set 6: Central area & Start date and end date differs by at least two days & None of the days are Sundays",
      () {
    xHeader = _generateMatrixHeaders(DateTime(2023, 4, 3), "x");
    yHeader = _generateMatrixHeaders(DateTime(2023, 4, 5), "y");
    expectedAns = [[]]; //!!

    _matrixTest(CalculatorController.calculateParkingFee() as Function(void p1),
        true, xHeader, yHeader, expectedAns);
  });

  group(
      "Set 7: Central area & Start date and end date differs by at least two days & The full parking day contains a Sunday",
      () {
    xHeader = _generateMatrixHeaders(DateTime(2023, 4, 1), "x");
    yHeader = _generateMatrixHeaders(DateTime(2023, 4, 3), "y");
    expectedAns = [[]]; //!!

    _matrixTest(CalculatorController.calculateParkingFee() as Function(void p1),
        true, xHeader, yHeader, expectedAns);
  });

  log("--------------------------------------------------");
  log("           3. CONTROL FLOW TESTING");
  log("--------------------------------------------------");

  group("Testing calculatorController.calculateParkingFees():", () {
    int counter = 1;
    _singleTest(
        counter++,
        CalculatorController.calculateParkingFee as Function(void p1),
        false,
        DateTime(2023, 4, 3, 12, 0, 0),
        DateTime(2023, 4, 2, 12, 0, 0),
        -1);
    _singleTest(
        counter++,
        CalculatorController.calculateParkingFee as Function(void p1),
        false,
        DateTime(2023, 4, 3, 18, 0, 0),
        DateTime(2023, 4, 3, 21, 0, 0),
        3.6);
    _singleTest(
        counter++,
        CalculatorController.calculateParkingFee as Function(void p1),
        false,
        DateTime(2023, 4, 3, 23, 0, 0),
        DateTime(2023, 4, 4, 2, 0, 0),
        -1);
    _singleTest(
        counter++,
        CalculatorController.calculateParkingFee as Function(void p1),
        true,
        DateTime(2023, 4, 3, 23, 0, 0),
        DateTime(2023, 4, 5, 2, 0, 0),
        44.4);
    _singleTest(
        counter++,
        CalculatorController.calculateParkingFee as Function(void p1),
        false,
        DateTime(2023, 4, 3, 23, 0, 0),
        DateTime(2023, 4, 4, 2, 0, 0),
        32.4);
  });

  group("Testing CalculatorController._calculateCentralCarpark():", () {
    int counter = 1;
    _singleTest(
        counter++,
        CalculatorController.calculateParkingFee as Function(void p1),
        false,
        DateTime(2023, 4, 3, 12, 0, 0),
        DateTime(2023, 4, 3, 15, 0, 0),
        3.6);
    _singleTest(
        counter++,
        CalculatorController.calculateParkingFee as Function(void p1),
        true,
        DateTime(2023, 4, 3, 18, 0, 0),
        DateTime(2023, 4, 3, 21, 0, 0),
        3.6);
    _singleTest(
        counter++,
        CalculatorController.calculateParkingFee as Function(void p1),
        true,
        DateTime(2023, 4, 3, 3, 0, 0),
        DateTime(2023, 4, 3, 6, 0, 0),
        3.6);
    _singleTest(
        counter++,
        CalculatorController.calculateParkingFee as Function(void p1),
        true,
        DateTime(2023, 4, 3, 5, 30, 0),
        DateTime(2023, 4, 3, 8, 30, 0),
        5.4);
    _singleTest(
        counter++,
        CalculatorController.calculateParkingFee as Function(void p1),
        true,
        DateTime(2023, 4, 3, 6, 0, 0),
        DateTime(2023, 4, 3, 18, 0, 0),
        26.4);
    _singleTest(
        counter++,
        CalculatorController.calculateParkingFee as Function(void p1),
        true,
        DateTime(2023, 4, 3, 12, 0, 0),
        DateTime(2023, 4, 3, 15, 0, 0),
        7.2);
    _singleTest(
        counter++,
        CalculatorController.calculateParkingFee as Function(void p1),
        false,
        DateTime(2023, 4, 3, 15, 30, 0),
        DateTime(2023, 4, 3, 18, 30, 0),
        5.4);
  });
}

void testThis(Function(void) targetMethod, bool testIsMatrix, bool isCentral,
    List<DateTime> args, List<double> expectedAns) {
  // Augment list before passing into testThis()
  // If testing method is SingleTest, then args will contain exactly 2 elements in the list
  // whereas expectedAns will contain exactly 1 element
  // If testing method is MatrixTest, then args will contain, in equal numbers, xHeader elements and yHeader elements
  // will split args exactly into half, first half for xHeader and second half for yHeader
  // whereas expectedAns will contain exactly half the size of args

  if (testIsMatrix) {
    // check if args format is correct or not

    List<DateTime> xHeader = [];
    List.copyRange(xHeader, 0, args, 0, (args.length / 2).floor());
    List<DateTime> yHeader = [];
    List.copyRange(
        yHeader, 0, args, (args.length / 2).floor() + 1, args.length);

    List<List<double>> formattedAns = [[]];
    List<double> row = [];
    int counter = 0;
    for (int i = 0; i < xHeader.length; i++) {
      row = [];
      for (int j = 0; j < yHeader.length; j++) {
        row.add(expectedAns[counter++]);
      }
      formattedAns[i] = row;
    }

    _matrixTest(targetMethod, isCentral, xHeader, yHeader, formattedAns);
  } else {
    // check if args format is correct or not

    DateTime start = args[0];
    DateTime end = args[1];
    double formattedAns = expectedAns[0];

    _singleTest(1, targetMethod, isCentral, start, end, formattedAns);
  }
}

void _matrixTest(
    Function(void) targetMethod,
    bool isCentral,
    List<DateTime> xHeader,
    List<DateTime> yHeader,
    List<List<double>> expectedAns) {
  if (isCentral) {
    CalculatorController.carpark.area = "BBB";
  } else {
    CalculatorController.carpark.area = "";
  }

  // Loop check
  if (xHeader.length != expectedAns.length) {
    log("Number of elements in the x-axis does not match the expected list!");
  }
  if (yHeader.length != expectedAns[0].length) {
    log("Number of elements in the y-axis does not match the expected list!");
  }

  int counter = 1;
  for (int i = 0; i < xHeader.length; i++) {
    for (int j = 0; j < yHeader.length; j++) {
      CalculatorController.setStartDateTime(xHeader[i]);
      CalculatorController.setEndDateTime(yHeader[j]);
      test(
          "${counter++} Start: (x=$i) ${xHeader[i].toString()} \t End: (y=$j) ${yHeader[i].toString()} \t Expected: ${expectedAns[i][j]}",
          () {
        expect(Function.apply(targetMethod, []), expectedAns[i][j]);
      });
    }
  }
}

void _singleTest(int counter, Function(void) targetMethod, bool isCentral,
    DateTime start, DateTime end, double expectedAns) {
  if (isCentral) {
    CalculatorController.carpark.area = "BBB";
  } else {
    CalculatorController.carpark.area = "";
  }
  CalculatorController.setStartDateTime(start);
  CalculatorController.setEndDateTime(end);

  test("${counter++} Start: $start \t End: $end \t Expected: $expectedAns", () {
    expect(Function.apply(targetMethod, []), expectedAns);
  });
}

List<DateTime> _generateMatrixHeaders(DateTime date, String axis) {
  List<DateTime> headerList = [];

  if (axis == 'x') {
    headerList.add(DateTime(date.year, date.month, date.day, 0, 0, 0));
    headerList.add(DateTime(date.year, date.month, date.day, 1, 0, 0));
    headerList.add(DateTime(date.year, date.month, date.day, 6, 0, 0));
    headerList.add(DateTime(date.year, date.month, date.day, 7, 0, 0));
    headerList.add(DateTime(date.year, date.month, date.day, 8, 0, 0));
    headerList.add(DateTime(date.year, date.month, date.day, 16, 0, 0));
    headerList.add(DateTime(date.year, date.month, date.day, 17, 0, 0));
    headerList.add(DateTime(date.year, date.month, date.day, 18, 0, 0));
  } else if (axis == 'y') {
    headerList.add(DateTime(date.year, date.month, date.day, 6, 0, 0));
    headerList.add(DateTime(date.year, date.month, date.day, 7, 0, 0));
    headerList.add(DateTime(date.year, date.month, date.day, 8, 0, 0));
    headerList.add(DateTime(date.year, date.month, date.day, 16, 0, 0));
    headerList.add(DateTime(date.year, date.month, date.day, 17, 0, 0));
    headerList.add(DateTime(date.year, date.month, date.day, 18, 0, 0));
    headerList.add(DateTime(date.year, date.month, date.day, 23, 0, 0));
    headerList.add(DateTime(date.year, date.month, date.day + 1, 0, 0, 0));
  }

  return headerList;
}
