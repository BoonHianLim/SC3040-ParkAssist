import 'package:flutter_test/flutter_test.dart';
import 'package:parkassist/control/calculator_controller.dart';

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
    _singleTest(0, CalculatorController.calculateParkingFee, true,
        DateTime(2023, 4, 3, 6, 0, 0), DateTime(2023, 4, 4, 6, 0, 0), 40.8);
  });

  //--------------------------------------------------
  //         1. EQUIVALENCE CLASS TESTING
  //--------------------------------------------------

  int counter = 1;
  List<DateTime> xHeader = [];
  List<DateTime> yHeader = [];
  List<List<double>> expectedAns = [
    [40.8, 54, 67.2],
    [27.6, 40.8, 54],
    [14.4, 27.6, 40.8]
  ];

  group("ECT Set 1: Invalid input / Outside Central Area / Sunday \n", () {
    _singleTest(counter++, CalculatorController.calculateParkingFee, false,
        DateTime(2023, 4, 3, 12, 0, 0), DateTime(2023, 4, 2, 12, 0, 0), -1);
    _singleTest(counter++, CalculatorController.calculateParkingFee, false,
        DateTime(2023, 4, 3, 18, 0, 0), DateTime(2023, 4, 3, 21, 0, 0), 3.6);
    _singleTest(counter++, CalculatorController.calculateParkingFee, false,
        DateTime(2023, 4, 2, 12, 0, 0), DateTime(2023, 4, 2, 15, 0, 0), 3.6);
  });

  group("ECT Set 2: Central area & Same day parking & Non-Sunday \n", () {
    _singleTest(counter++, CalculatorController.calculateParkingFee, true,
        DateTime(2023, 4, 3, 2, 0, 0), DateTime(2023, 4, 3, 5, 0, 0), 3.6);
    _singleTest(counter++, CalculatorController.calculateParkingFee, true,
        DateTime(2023, 4, 3, 6, 0, 0), DateTime(2023, 4, 3, 18, 0, 0), 26.4);
    _singleTest(counter++, CalculatorController.calculateParkingFee, true,
        DateTime(2023, 4, 3, 12, 0, 0), DateTime(2023, 4, 3, 15, 0, 0), 7.2);
  });

  group(
      "ECT Set 3: Central area & Start date and end date differs by one day & Start day is a Sunday \n",
      () {
    _singleTest(counter++, CalculatorController.calculateParkingFee, true,
        DateTime(2023, 4, 2, 12, 0, 0), DateTime(2023, 4, 3, 6, 0, 0), 21.6);
    _singleTest(counter++, CalculatorController.calculateParkingFee, true,
        DateTime(2023, 4, 2, 12, 0, 0), DateTime(2023, 4, 3, 12, 0, 0), 34.8);
    _singleTest(counter++, CalculatorController.calculateParkingFee, true,
        DateTime(2023, 4, 2, 12, 0, 0), DateTime(2023, 4, 3, 18, 0, 0), 48);
  });

  group(
      "ECT Set 4: Central area & Start date and end date differs by one day & End day is a Sunday \n",
      () {
    _singleTest(counter++, CalculatorController.calculateParkingFee, true,
        DateTime(2023, 4, 1, 6, 0, 0), DateTime(2023, 4, 2, 12, 0, 0), 48);
    _singleTest(counter++, CalculatorController.calculateParkingFee, true,
        DateTime(2023, 4, 1, 12, 0, 0), DateTime(2023, 4, 2, 12, 0, 0), 34.8);
    _singleTest(counter++, CalculatorController.calculateParkingFee, true,
        DateTime(2023, 4, 1, 18, 0, 0), DateTime(2023, 4, 2, 12, 0, 0), 21.6);
  });

  group(
      "ECT Set 5: Central area & Start date and end date differs by one day & None of the days are Sundays \n",
      () {
    xHeader = [
      DateTime(2023, 4, 3, 6, 0, 0),
      DateTime(2023, 4, 3, 12, 0, 0),
      DateTime(2023, 4, 3, 18, 0, 0)
    ];
    yHeader = [
      DateTime(2023, 4, 4, 6, 0, 0),
      DateTime(2023, 4, 4, 12, 0, 0),
      DateTime(2023, 4, 4, 18, 0, 0)
    ];
    expectedAns = expectedAns;

    _matrixTest(CalculatorController.calculateParkingFee, true, xHeader,
        yHeader, expectedAns);
  });

  group(
      "ECT Set 6: Central area & Start date and end date differs by at least two days & None of the days are Sundays \n",
      () {
    xHeader = [
      DateTime(2023, 4, 3, 6, 0, 0),
      DateTime(2023, 4, 3, 12, 0, 0),
      DateTime(2023, 4, 3, 18, 0, 0)
    ];
    yHeader = [
      DateTime(2023, 4, 5, 6, 0, 0),
      DateTime(2023, 4, 5, 12, 0, 0),
      DateTime(2023, 4, 5, 18, 0, 0)
    ];
    List<List<double>> expectedAnsSet6 = [[]];
    double fullNonSunday = 40.8;
    for (int i = 0; i < expectedAns.length; i++) {
      expectedAnsSet6.add([]);
      for (int j = 0; j < expectedAns[0].length; j++) {
        double calculated = expectedAns[i][j] + fullNonSunday;
        double rounded = double.parse(calculated.toStringAsFixed(1));
        expectedAnsSet6[i].add(rounded);
      }
    }

    _matrixTest(CalculatorController.calculateParkingFee, true, xHeader,
        yHeader, expectedAnsSet6);
  });

  group(
      "ECT Set 7: Central area & Start date and end date differs by at least two days & The full parking day contains a Sunday \n",
      () {
    xHeader = [
      DateTime(2023, 4, 1, 6, 0, 0),
      DateTime(2023, 4, 1, 12, 0, 0),
      DateTime(2023, 4, 1, 18, 0, 0)
    ];
    yHeader = [
      DateTime(2023, 4, 3, 6, 0, 0),
      DateTime(2023, 4, 3, 12, 0, 0),
      DateTime(2023, 4, 3, 18, 0, 0)
    ];
    List<List<double>> expectedAnsSet7 = [[]];
    double fullSunday = 28.8;
    for (int i = 0; i < expectedAns.length; i++) {
      expectedAnsSet7.add([]);
      for (int j = 0; j < expectedAns[0].length; j++) {
        double calculated = expectedAns[i][j] + fullSunday;
        double rounded = double.parse(calculated.toStringAsFixed(1));
        expectedAnsSet7[i].add(rounded);
      }
    }

    _matrixTest(CalculatorController.calculateParkingFee, true, xHeader,
        yHeader, expectedAnsSet7);
  });

  //--------------------------------------------------
  //          2. BOUNDARY VALUE TESTING
  //--------------------------------------------------

  counter = 1;
  xHeader = [];
  yHeader = [];
  /*expectedAns = [
    [7.2, 6, 0, -1, -1, -1, -1, -1],
    [8.4, 7.2, 1.2, 0, -1, -1, -1, -1],
    [10.8, 9.6, 3.6, 2.4, 0, -1, -1, -1],
    [30, 28.8, 22.8, 21.6, 19.2, 0, -1, -1],
    [32.4, 31.2, 25.2, 24, 21.6, 2.4, 0, -1],
    [33.6, 32.4, 26.4, 25.2, 22.8, 3.6, 1.2, 0],
    [39.6, 38.4, 32.4, 31.2, 28.8, 9.6, 7.2, 6],
    [40.8, 39.6, 33.6, 32.4, 30, 10.8, 8.4, 7.2]
  ];*/
  expectedAns = [
    [7.2, 8.4, 10.8, 30, 32.4, 33.6, 39.6, 40.8],
    [6, 7.2, 9.6, 28.8, 31.2, 32.4, 38.4, 39.6],
    [0, 1.2, 3.6, 22.8, 25.2, 26.4, 32.4, 33.6],
    [-1.2, 0, 2.4, 21.6, 24, 25.2, 31.2, 32.4],
    [-3.6, -2.4, 0, 19.2, 21.6, 22.8, 28.8, 30],
    [-22.8, -21.6, -19.2, 0, 2.4, 3.6, 9.6, 10.8],
    [-25.2, -24, -21.6, -2.4, 0, 1.2, 7.2, 8.4],
    [-26.4, -25.2, -22.8, -3.6, -1.2, 0, 6, 7.2]
  ];

  group("BVT Set 1: Invalid input / Outside Central Area / Sunday \n", () {
    _singleTest(counter++, CalculatorController.calculateParkingFee, false,
        DateTime(2023, 4, 3, 12, 0, 0), DateTime(2023, 4, 2, 12, 0, 0), -1);
    _singleTest(counter++, CalculatorController.calculateParkingFee, false,
        DateTime(2023, 4, 3, 18, 0, 0), DateTime(2023, 4, 3, 21, 0, 0), 3.6);
    _singleTest(counter++, CalculatorController.calculateParkingFee, false,
        DateTime(2023, 4, 2, 12, 0, 0), DateTime(2023, 4, 2, 15, 0, 0), 3.6);
  });

  group("BVT Set 2: Central area & Same day parking & Non-Sunday \n", () {
    xHeader = _generateMatrixHeaders(DateTime(2023, 4, 3), "x");
    yHeader = _generateMatrixHeaders(DateTime(2023, 4, 3), "y");
    List<List<double>> expectedAnsSet2 = [[]];
    for (int i = 0; i < expectedAns.length; i++) {
      expectedAnsSet2.add([]);
      for (int j = 0; j < expectedAns[0].length; j++) {
        if (expectedAns[i][j] >= 0) {
          expectedAnsSet2[i].add(expectedAns[i][j]);
        } else {
          expectedAnsSet2[i].add(-1);
        }
      }
    }

    _matrixTest(CalculatorController.calculateParkingFee, true, xHeader,
        yHeader, expectedAnsSet2);
  });

  group(
      "BVT Set 3: Central area & Start date and end date differs by one day & Start day is a Sunday \n",
      () {
    DateTime startDate = DateTime(2023, 4, 2, 12, 0, 0);
    List<DateTime> yHeader = _generateMatrixHeaders(DateTime(2023, 4, 3), "y");
    List<double> expected1DAns = [21.6, 22.8, 25.2, 44.4, 46.8, 48, 54, 55.2];

    counter = 1;
    for (int i = 0; i < xHeader.length; i++) {
      _singleTest(counter++, CalculatorController.calculateParkingFee, true,
          startDate, yHeader[i], expected1DAns[i]);
    }
  });

  group(
      "BVT Set 4: Central area & Start date and end date differs by one day & End day is a Sunday \n",
      () {
    xHeader = _generateMatrixHeaders(DateTime(2023, 4, 1), "x");
    DateTime endDate = DateTime(2023, 4, 2, 12, 0, 0);
    List<double> expected1DAns = [55.2, 54, 48, 46.8, 44.4, 25.2, 22.8, 21.6];

    counter = 1;
    for (int i = 0; i < xHeader.length; i++) {
      _singleTest(counter++, CalculatorController.calculateParkingFee, true,
          xHeader[i], endDate, expected1DAns[i]);
    }
  });

  group(
      "BVT Set 5: Central area & Start date and end date differs by one day & None of the days are Sundays \n",
      () {
    xHeader = _generateMatrixHeaders(DateTime(2023, 4, 3), "x");
    yHeader = _generateMatrixHeaders(DateTime(2023, 4, 4), "y");
    List<List<double>> expectedAnsSet5 = [[]];
    double fullNonSunday = 40.8;
    for (int i = 0; i < expectedAns.length; i++) {
      expectedAnsSet5.add([]);
      for (int j = 0; j < expectedAns[0].length; j++) {
        double calculated = expectedAns[i][j] + fullNonSunday;
        double rounded = double.parse(calculated.toStringAsFixed(1));
        expectedAnsSet5[i].add(rounded);
      }
    }

    _matrixTest(CalculatorController.calculateParkingFee, true, xHeader,
        yHeader, expectedAnsSet5);
  });

  group(
      "BVT Set 6: Central area & Start date and end date differs by at least two days & None of the days are Sundays \n",
      () {
    xHeader = _generateMatrixHeaders(DateTime(2023, 4, 3), "x");
    yHeader = _generateMatrixHeaders(DateTime(2023, 4, 5), "y");
    List<List<double>> expectedAnsSet6 = [[]];
    double fullNonSunday = 40.8;
    for (int i = 0; i < expectedAns.length; i++) {
      expectedAnsSet6.add([]);
      for (int j = 0; j < expectedAns[0].length; j++) {
        double calculated = expectedAns[i][j] + 2 * fullNonSunday;
        double rounded = double.parse(calculated.toStringAsFixed(1));
        expectedAnsSet6[i].add(rounded);
      }
    }

    _matrixTest(CalculatorController.calculateParkingFee, true, xHeader,
        yHeader, expectedAnsSet6);
  });

  group(
      "BVT Set 7: Central area & Start date and end date differs by at least two days & The full parking day contains a Sunday \n",
      () {
    xHeader = _generateMatrixHeaders(DateTime(2023, 4, 1), "x");
    yHeader = _generateMatrixHeaders(DateTime(2023, 4, 3), "y");
    List<List<double>> expectedAnsSet7 = [[]];
    double fullSunday = 28.8;
    double fullNonSunday = 40.8;
    for (int i = 0; i < expectedAns.length; i++) {
      expectedAnsSet7.add([]);
      for (int j = 0; j < expectedAns[0].length; j++) {
        double calculated = expectedAns[i][j] + fullNonSunday + fullSunday;
        double rounded = double.parse(calculated.toStringAsFixed(1));
        expectedAnsSet7[i].add(rounded);
      }
    }

    _matrixTest(CalculatorController.calculateParkingFee, true, xHeader,
        yHeader, expectedAnsSet7);
  });

  // --------------------------------------------------
  //           3. CONTROL FLOW TESTING
  //--------------------------------------------------

  group("CFT Testing calculatorController.calculateParkingFees(): \n", () {
    int counter = 1;
    _singleTest(counter++, CalculatorController.calculateParkingFee, false,
        DateTime(2023, 4, 3, 12, 0, 0), DateTime(2023, 4, 2, 12, 0, 0), -1);
    _singleTest(counter++, CalculatorController.calculateParkingFee, false,
        DateTime(2023, 4, 3, 18, 0, 0), DateTime(2023, 4, 3, 21, 0, 0), 3.6);
    _singleTest(counter++, CalculatorController.calculateParkingFee, false,
        DateTime(2023, 4, 3, 23, 0, 0), DateTime(2023, 4, 4, 2, 0, 0), 3.6);
    _singleTest(counter++, CalculatorController.calculateParkingFee, false,
        DateTime(2023, 4, 3, 23, 0, 0), DateTime(2023, 4, 5, 2, 0, 0), 32.4);
    _singleTest(counter++, CalculatorController.calculateParkingFee, true,
        DateTime(2023, 4, 1, 23, 0, 0), DateTime(2023, 4, 3, 2, 0, 0), 32.4);
    _singleTest(counter++, CalculatorController.calculateParkingFee, true,
        DateTime(2023, 4, 3, 23, 0, 0), DateTime(2023, 4, 5, 2, 0, 0), 44.4);
  });

  group("CFT Testing CalculatorController._calculateCentralCarpark(): \n", () {
    int counter = 1;
    _singleTest(counter++, CalculatorController.calculateParkingFee, false,
        DateTime(2023, 4, 3, 12, 0, 0), DateTime(2023, 4, 3, 15, 0, 0), 3.6);
    _singleTest(counter++, CalculatorController.calculateParkingFee, true,
        DateTime(2023, 4, 3, 18, 0, 0), DateTime(2023, 4, 3, 21, 0, 0), 3.6);
    _singleTest(counter++, CalculatorController.calculateParkingFee, true,
        DateTime(2023, 4, 3, 3, 0, 0), DateTime(2023, 4, 3, 6, 0, 0), 3.6);
    _singleTest(counter++, CalculatorController.calculateParkingFee, true,
        DateTime(2023, 4, 3, 5, 30, 0), DateTime(2023, 4, 3, 8, 30, 0), 5.4);
    _singleTest(counter++, CalculatorController.calculateParkingFee, true,
        DateTime(2023, 4, 3, 6, 0, 0), DateTime(2023, 4, 3, 18, 0, 0), 26.4);
    _singleTest(counter++, CalculatorController.calculateParkingFee, true,
        DateTime(2023, 4, 3, 12, 0, 0), DateTime(2023, 4, 3, 15, 0, 0), 7.2);
    _singleTest(counter++, CalculatorController.calculateParkingFee, true,
        DateTime(2023, 4, 3, 15, 30, 0), DateTime(2023, 4, 3, 18, 30, 0), 5.4);
  });
}

void _matrixTest(Function targetMethod, bool isCentral, List<DateTime> xHeader,
    List<DateTime> yHeader, List<List<double>> expectedAns) {
  if (isCentral) {
    CalculatorController.carpark.carParkID = "BBB";
  } else {
    CalculatorController.carpark.carParkID = "AAA";
  }

  int counter = 1;
  for (int i = 0; i < xHeader.length; i++) {
    for (int j = 0; j < yHeader.length; j++) {
      CalculatorController.setStartDateTime(xHeader[i]);
      CalculatorController.setEndDateTime(yHeader[j]);
      test(
          "${counter++}. Start: (x=$i) ${xHeader[i].toString()} \t End: (y=$j) ${yHeader[j].toString()} \t Expected: ${expectedAns[i][j]} Calculated: ${CalculatorController.calculateParkingFee()}",
          () {
        CalculatorController.setStartDateTime(xHeader[i]);
        CalculatorController.setEndDateTime(yHeader[j]);
        if (isCentral) {
          CalculatorController.carpark.carParkID = "BBB";
        } else {
          CalculatorController.carpark.carParkID = "AAA";
        }

        double result = Function.apply(targetMethod, []);
        double result1dp = double.parse(result.toStringAsFixed(1));
        expect(result1dp, expectedAns[i][j]);
      });
    }
  }
}

void _singleTest(int counter, Function targetMethod, bool isCentral,
    DateTime start, DateTime end, double expectedAns) {
  if (isCentral) {
    CalculatorController.carpark.carParkID = "BBB";
  } else {
    CalculatorController.carpark.carParkID = "AAA";
  }
  CalculatorController.setStartDateTime(start);
  CalculatorController.setEndDateTime(end);

  test(
      "${counter++}. Start: $start \t End: $end \t Expected: $expectedAns Calculated: ${CalculatorController.calculateParkingFee()}",
      () {
    if (isCentral) {
      CalculatorController.carpark.carParkID = "BBB";
    } else {
      CalculatorController.carpark.carParkID = "AAA";
    }
    CalculatorController.setStartDateTime(start);
    CalculatorController.setEndDateTime(end);

    double result = Function.apply(targetMethod, []);
    double result1dp = double.parse(result.toStringAsFixed(1));
    expect(result1dp, expectedAns);
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
