import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:parkassist/entity/carParkList.dart';
import 'package:parkassist/entity/favouritesEntity.dart';

class FavouritesInterface extends StatelessWidget {
  CarPark carparkdummy = CarPark(
    carParkID: "012",
    area: "JE",
    development: "HDB",
    location: "JE",
    availableLots: 10,
    lotType: "A",
    agency: "HDB",
  );
  List<CarPark> favList = FavouritesEntity.favouritesList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // top bar contains back arrow and "Favourites"
      appBar: AppBar(
        leading: const Icon(
          Icons.arrow_back_ios_rounded,
          size: 24,
        );
        title: Text('Favourites'),
        backgroundColor: Colors.green,
      ),

      // the rest is a list of carparks that got added into favourites
      // builder iterates through all items in favList
      body: ListView.builder(
        itemCount: favList.length,
        itemBuilder: (BuildContext context, index) {
          return ListTile(
            // for now, print out the location of the carpark. can change later
            title: Text(favList[index].location!),
          );
        }
      )
    );
  }
}
