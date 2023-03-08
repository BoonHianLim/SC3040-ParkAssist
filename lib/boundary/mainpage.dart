import 'package:parkassist/entity/carpark.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import '../control/cp_controller.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    context.read<CarparkController>().add(GetCarparks());
    Timer.periodic(const Duration(minutes: 1), (timer) {
      context.read<CarparkController>().add(GetCarparks());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CarparkController, List<CarparkData>>(
        builder: (context, carparks) {
          if (carparks.isNotEmpty) {
            return ListView.builder(
                itemCount: carparks.length,
                itemBuilder: (context, index) {
                  var carpark = carparks[index];
                  return Container(
                      color:
                          (index % 2 == 0) ? Colors.lightGreen : Colors.white,
                      height: 100,
                      margin: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Text(carpark.carparkNumber),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                  carpark.carparkInfo[0].lotsAvailable + ' / '),
                              Text(carpark.carparkInfo[0].totalLots)
                            ],
                          )
                        ],
                      ));
                });
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
