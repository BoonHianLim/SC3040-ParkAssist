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

void testThis(bool testIsMatrix, Function(void) targetMethod,
    List<DateTime> args, List<double> expectedAns) {
  if (testIsMatrix) {
    matrixTest(targetMethod, args, args, expectedAns);
  } else {
    singleTest(targetMethod, args[0], args[0], expectedAns[0]);
  }
}

void matrixTest(Function(void) targetMethod, List<DateTime> xHeader,
    List<DateTime> yHeader, List<double> expectedAns) {
  test("Matrix Test \t x=? y=? \t Start date time: \t End date time:", () {
    expect(Function.apply(targetMethod, []), 99999999999999999);
  });
}

void singleTest(Function(void) targetMethod, DateTime start, DateTime end,
    double expectedAns) {
  test("Single Test \t \t Start date time: \t End date time:", () {
    expect(Function.apply(targetMethod, []), 99999999999999999);
  });
}
