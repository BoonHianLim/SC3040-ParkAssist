import 'package:parkassist/boundary/favouritesInterface.dart';
import 'package:parkassist/control/pricing_controller.dart';
import 'package:flutter/material.dart';
import 'package:parkassist/control/carParkController.dart';
import 'package:parkassist/entity/carParkList.dart';
import 'package:parkassist/entity/pricing.dart';

//takes carParkID string of the carpark object as parameter
class InfoInterface extends StatefulWidget {
  final String carParkID;
  const InfoInterface({super.key, required this.carParkID});

  @override
  State<InfoInterface> createState() => _InfoInterfaceState();
}

class _InfoInterfaceState extends State<InfoInterface> {
  late Future<CarPark> carparkFuture;

  @override
  void initState() {
    //uses getCarpark() to get carpark object as a future
    carparkFuture = CarParkController().getCarpark(widget.carParkID);
    super.initState();
  }

  Widget build(BuildContext context) {
    return FutureBuilder<CarPark>(
        future: carparkFuture,
        builder: (context, carpark) {
          if (carpark.hasData) {
            return Scaffold(
              //carpark development name as appbar
              appBar: AppBar(
                title: Text('${carpark.data!.development}'),
                backgroundColor: Colors.green,
                //favorites button. please add navigation
                actions: [
                  IconButton(
                      icon: const Icon(Icons.star),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const FavouritesInterface()));
                      })
                ],
              ),
              body: Column(
                children: [
                  //available lots text
                  Container(
                    color: Colors.grey.shade400,
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    child: RichText(
                        text: TextSpan(
                            text: 'Available Lots: ',
                            style: const TextStyle(color: Colors.black),
                            children: <TextSpan>[
                          TextSpan(
                              text: '${carpark.data!.availableLots}',
                              style: const TextStyle(color: Colors.blue))
                        ])),
                  ),
                  Expanded(
                      child: FutureBuilder<Records>(
                    future:
                        //use carpark object with getPricingStrings to get pricing string. person doing calculatorcontroller can replace
                        PricingController().getPricingStrings(carpark.data!),
                    builder: (context, pricing) {
                      if (pricing.hasData) {
                        var children2 = <Widget>[
                          //hdb pricing text
                          if (pricing.data!.weekdaysRate1 != null &&
                              pricing.data!.category == 'HDB')
                            Wrap(children: [
                              Container(
                                height: 50,
                                color: Colors.grey.shade700,
                                child: const Center(
                                  child: Text('Parking Rates',
                                      style: TextStyle(
                                        color: Colors.white,
                                      )),
                                ),
                              ),
                              Container(
                                height: 50,
                                color: Colors.grey.shade400,
                                child: Center(
                                    child:
                                        Text('${pricing.data!.weekdaysRate1}')),
                              ),
                              if (pricing.data!.weekdaysRate2 != null)
                                Container(
                                  height: 50,
                                  color: Colors.grey.shade400,
                                  child: Center(
                                      child: Text(
                                          '${pricing.data!.weekdaysRate2}')),
                                ),
                              Container(
                                height: 50,
                              ),
                            ]),
                          //weekday pricing text
                          if (pricing.data!.weekdaysRate1 != null &&
                              pricing.data!.category != 'HDB')
                            Wrap(children: [
                              Container(
                                height: 50,
                                color: Colors.grey.shade700,
                                child: const Center(
                                    child: Text('Weekday Rate',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ))),
                              ),
                              Container(
                                height: 50,
                                color: Colors.grey.shade400,
                                child: Center(
                                    child:
                                        Text('${pricing.data!.weekdaysRate1}')),
                              ),
                              if (pricing.data!.weekdaysRate2 != null)
                                Container(
                                  height: 50,
                                  color: Colors.grey.shade400,
                                  child: Center(
                                      child: Text(
                                          '${pricing.data!.weekdaysRate2}')),
                                ),
                              Container(
                                height: 50,
                              ),
                            ]),
                          //saturday pricing text
                          if (pricing.data!.saturdayRate != null)
                            Wrap(children: [
                              Container(
                                height: 50,
                                color: Colors.grey.shade700,
                                child: const Center(
                                    child: Text('Saturday Rate',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ))),
                              ),
                              Container(
                                height: 50,
                                color: Colors.grey.shade400,
                                child: Center(
                                    child:
                                        Text('${pricing.data!.saturdayRate}')),
                              ),
                              Container(
                                height: 50,
                              ),
                            ]),
                          //sunday pricing text
                          if (pricing.data!.sundayPublicholidayRate != null)
                            Wrap(children: [
                              Container(
                                height: 50,
                                color: Colors.grey.shade700,
                                child: const Center(
                                    child: Text('Sunday & Public Holidays Rate',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ))),
                              ),
                              Container(
                                height: 50,
                                color: Colors.grey.shade400,
                                child: Center(
                                    child: Text(
                                        '${pricing.data!.sundayPublicholidayRate}')),
                              ),
                              Container(
                                height: 50,
                              ),
                            ]),
                        ];
                        return ListView(
                          padding: const EdgeInsets.all(8),
                          children: children2,
                        );
                      } else if (pricing.hasError) {
                        return Text('${pricing.error}');
                      }
                      //when pricing info still loading/ doesnt load:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  )),
                  //calculator button. please add navigation
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    child: const ElevatedButton(
                        onPressed: null, child: Text('Parking Fee Calculator')),
                  ),
                ],
              ),
            );
          } else if (carpark.hasError) {
            return Text('${carpark.error}');
          }
          //when carpark info loading:
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
