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
import 'package:parkassist/entity/carParkList.dart';

void main() {
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

  log("--------------------------------------------------");
  log("          2. BOUNDARY VALUE TESTING");
  log("--------------------------------------------------");

  log("--------------------------------------------------");
  log("           3. CONTROL FLOW TESTING");
  log("--------------------------------------------------");
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

    matrixTest(
        targetMethod, testIsMatrix, isCentral, xHeader, yHeader, formattedAns);
  } else {
    // check if args format is correct or not

    DateTime start = args[0];
    DateTime end = args[1];
    double formattedAns = expectedAns[0];

    singleTest(targetMethod, testIsMatrix, isCentral, start, end, formattedAns);
  }
}

void matrixTest(
    Function(void) targetMethod,
    bool testIsMatrix,
    bool isCentral,
    List<DateTime> xHeader,
    List<DateTime> yHeader,
    List<List<double>> expectedAns) {
  if (isCentral) {
    CalculatorController.carpark.area = "BBB";
  } else {
    CalculatorController.carpark.area = "";
  }

  test("Matrix Test \t x=? y=? \t Start date time: \t End date time:", () {
    expect(Function.apply(targetMethod, []), 9999999999999);
  });

  // Loop check
  if (xHeader.length != expectedAns.length) {
    log("Number of elements in the x-axis does not match the expected list!");
  }
  if (yHeader.length != expectedAns[0].length) {
    log("Number of elements in the y-axis does not match the expected list!");
  }

  for (int i = 0; i < xHeader.length; i++) {
    for (int j = 0; j < yHeader.length; j++) {
      CalculatorController.setStartDateTime(xHeader[i]);
      CalculatorController.setEndDateTime(yHeader[j]);
      test(
          "Start: (x=$i) ${xHeader[i].toString()} \t End: (y=$j) ${yHeader[i].toString()} \t Expected: ${expectedAns[i][j]}",
          () {
        expect(Function.apply(targetMethod, []), expectedAns[i][j]);
      });
    }
  }
}

void singleTest(Function(void) targetMethod, bool testIsMatrix, bool isCentral,
    DateTime start, DateTime end, double expectedAns) {
  if (isCentral) {
    CalculatorController.carpark.area = "BBB";
  } else {
    CalculatorController.carpark.area = "";
  }
  CalculatorController.setStartDateTime(start);
  CalculatorController.setEndDateTime(end);

  test("Start: $start \t End: $end \t Expected: $expectedAns", () {
    expect(Function.apply(targetMethod, []), expectedAns);
  });
}
