import 'package:parkassist/control/calculator_controller.dart';
import 'package:flutter/material.dart';

class CalculatorInterface extends StatefulWidget {
  const CalculatorInterface({super.key});

  @override
  State<CalculatorInterface> createState() => _CalculatorInterfaceState();
}

class _CalculatorInterfaceState extends State<CalculatorInterface> {
  @override
  void initState() {
    super.initState();
    CalculatorController.resetDateTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: FittedBox(
            child:
                Text('${CalculatorController.getCarparkInfo().development}')),
        backgroundColor: const Color(0xFF00E640),
        foregroundColor: Colors.black,
        elevation: 0,
        // filler to center title
        actions: [
          IconButton(
            color: const Color(0xFF00E640),
            icon: const Icon(Icons.abc),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            flex: 2,
            child: Container(
              color: Colors.grey.shade400,
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              child: RichText(
                  text: TextSpan(
                      text: 'Available Lots: ',
                      style: const TextStyle(color: Colors.black),
                      children: <TextSpan>[
                    TextSpan(
                        text: CalculatorController.getCarparkInfo()
                            .availableLots
                            .toString(),
                        style: const TextStyle(color: Colors.blue))
                  ])),
            ),
          ),
          Flexible(
            flex: 14,
            child: Container(
              color: const Color.fromARGB(255, 200, 244, 88),
              width: double.infinity,
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 80,
                    width: double.infinity,
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(5),
                    child: const Text(
                      "Start Date and Time",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    width: 280,
                    padding: const EdgeInsets.all(5),
                    child: ElevatedButton(
                        onPressed: () async {
                          if (!mounted) return;
                          final date =
                              await CalculatorController.pickDate(context);
                          if (date == null) return;
                          if (!mounted) return;
                          final time =
                              await CalculatorController.pickTime(context);
                          if (time == null) return;
                          setState(() {
                            CalculatorController.setStartDateTime(DateTime(
                                date.year,
                                date.month,
                                date.day,
                                time.hour,
                                time.minute));
                          });
                        },
                        child: (CalculatorController.startDateTime.year >= 0)
                            ? Text(
                                '${CalculatorController.startDateTime.day}/${CalculatorController.startDateTime.month}/${CalculatorController.startDateTime.year}\t:\t${CalculatorController.startDateTime.hour.toString().padLeft(2, '0')}:${CalculatorController.startDateTime.minute.toString().padLeft(2, '0')}',
                                style: const TextStyle(fontSize: 24),
                              )
                            : const Text(
                                "Set Date and Time",
                                style: TextStyle(fontSize: 24),
                              )),
                  ),
                  const SizedBox(
                    height: 20,
                    width: double.infinity,
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(5),
                    child: const Text(
                      "End Date and Time",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    width: 280,
                    padding: const EdgeInsets.all(5),
                    child: ElevatedButton(
                        onPressed: () async {
                          if (!mounted) return;
                          final date =
                              await CalculatorController.pickDate(context);
                          if (date == null) return;
                          if (!mounted) return;
                          final time =
                              await CalculatorController.pickTime(context);
                          if (time == null) return;
                          setState(() {
                            CalculatorController.setEndDateTime(DateTime(
                                date.year,
                                date.month,
                                date.day,
                                time.hour,
                                time.minute));
                          });
                        },
                        child: (CalculatorController.endDateTime.year >= 0)
                            ? Text(
                                '${CalculatorController.endDateTime.day}/${CalculatorController.endDateTime.month}/${CalculatorController.endDateTime.year}\t:\t${CalculatorController.endDateTime.hour.toString().padLeft(2, '0')}:${CalculatorController.endDateTime.minute.toString().padLeft(2, '0')}',
                                style: const TextStyle(fontSize: 24),
                              )
                            : const Text(
                                "Set Date and Time",
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              )),
                  ),
                  const SizedBox(
                    height: 60,
                    width: double.infinity,
                  ),
                  Container(
                      width: 380,
                      padding: const EdgeInsets.all(5),
                      child: FloatingActionButton.large(
                        onPressed: () {
                          setState(() {
                            CalculatorController.calculateParkingCost();
                          });
                          showModalBottomSheet(
                              backgroundColor:
                                  const Color.fromARGB(255, 206, 255, 157),
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20))),
                              isScrollControlled: false,
                              isDismissible: true,
                              context: context,
                              builder: (_) {
                                return SizedBox(
                                  height: 250,
                                  width: double.infinity,
                                  child: Stack(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 250,
                                        width: double.infinity,
                                        child: Center(
                                          child: Text(
                                            CalculatorController.price,
                                            style: const TextStyle(
                                                fontSize: 40,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 250,
                                        width: double.infinity,
                                        child: GestureDetector(
                                          onTap: (() =>
                                              Navigator.of(context).pop()),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              });
                        },
                        child: const Icon(Icons.calculate_sharp),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
