import 'package:parkassist/boundary/calculator_interface.dart';
import 'package:flutter/material.dart';
import 'package:parkassist/control/calculator_controller.dart';
import 'package:parkassist/control/carpark_controller.dart';
import 'package:parkassist/control/favourites_controller.dart';
import 'package:parkassist/entity/carpark.dart';
import 'package:parkassist/entity/favourites_entity.dart';

///Interface to display information on the selected car park
class InfoInterface extends StatefulWidget {
  final String carParkID;
  const InfoInterface({super.key, required this.carParkID});

  @override
  State<InfoInterface> createState() => _InfoInterfaceState();
}

class _InfoInterfaceState extends State<InfoInterface> {
  ///Carpark to display info on
  late CarPark carpark;

  ///Whether carpark is in favourites list
  bool inFav = false;

  ///Loading status
  String status = 'loading';

  ///List of carpark codes in central area
  var hdbCentralAreaList = [
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

  @override
  void initState() {
    // uses getCarparkByID() to get carpark object
    carpark = CarParkController.getCarparkByID(widget.carParkID);
    fetchFavStatus(carpark, inFav);
    super.initState();
  }

  ///Get favourite status from favourites controller
  void fetchFavStatus(CarPark carpark, bool setFav) async {
    bool temp = await FavouritesController.inFavourites(carpark);
    setState(() {
      inFav = temp;
      status = 'ready';
    });
  }

  ///Change favourite status
  void favStatusChange(bool setFav) {
    setState(() {
      inFav = setFav;
    });
  }

  @override
  Widget build(BuildContext context) {
    CalculatorController.setCarparkInfo(carpark);
    Future<List<CarPark>> favList = FavouritesEntity.fetchFavouritesList();
    if (status == 'ready') {
      return Scaffold(
        //carpark development name as appbar
        appBar: AppBar(
          centerTitle: true,
          title: FittedBox(child: Text('${carpark.development}')),
          backgroundColor: const Color(0xFF00E640),
          foregroundColor: Colors.black,
          elevation: 0,
          //favorites button
          actions: [
            IconButton(
                icon: inFav
                    ? const Icon(Icons.star)
                    : const Icon(Icons.star_border),
                onPressed: () {
                  favList.then((value) {
                    if (!inFav) {
                      FavouritesController.addToFavourites(value, carpark);
                      favStatusChange(true);
                    } else {
                      FavouritesController.removeFromFavourites(value, carpark);
                      favStatusChange(false);
                    }
                  });
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
                        text: '${carpark.availableLots}',
                        style: const TextStyle(color: Colors.blue))
                  ])),
            ),
            Expanded(
                child: Wrap(children: [
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
              (hdbCentralAreaList.contains(carpark.carParkID))
                  ? (Container(
                      height: 70,
                      color: Colors.grey.shade400,
                      child: const Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                            Text(r'$1.20 per half-hour'),
                            Text(r'(7:00am to 5:00pm, Mondays to Saturdays)'),
                            Text(r'$0.60 per half hour (Other hours)'),
                          ]))))
                  : Container(
                      height: 50,
                      color: Colors.grey.shade400,
                      child: const Center(child: Text(r'$0.60 per half-hour')),
                    ),
            ])),
            //calculator button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CalculatorInterface()));
                  },
                  child: const Text('Parking Fee Calculator')),
            ),
          ],
        ),
      );
    } else {
      //when carpark info loading:
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
