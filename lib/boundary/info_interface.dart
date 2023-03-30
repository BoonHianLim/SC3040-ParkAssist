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
  late CarPark carpark;
  bool inFav = false;
  String status = 'loading';
  var HDBCentralAreaList = [
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
    //uses getCarparkByID() to get carpark object
    carpark = CarParkController.getCarparkByID(widget.carParkID);
    print(carpark);
    fetchFavStatus(carpark, inFav);
    super.initState();
  }

  ///Get favourite status from favourites controller
  void fetchFavStatus(CarPark carpark, bool setFav) async {
    bool temp = await FavouritesController.inFavourites(carpark);
    print("carpark in fav: $temp");
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
          title: Text('${carpark.development}'),
          backgroundColor: Colors.green,
          //favorites button. please add navigation
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
              (HDBCentralAreaList.contains(carpark.carParkID))
                  ? (Container(
                      height: 50,
                      color: Colors.grey.shade400,
                      child: const Center(
                          child: Text(
                              r'$1.20 per half-hour (7:00am to 5:00pm, Mondays to Saturdays), $0.60 per half hour (Other hours)')),
                    ))
                  : Container(
                      height: 50,
                      color: Colors.grey.shade400,
                      child: const Center(child: Text(r'$0.60 per half-hour')),
                    ),
            ])),
            //calculator button. please add navigation
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
