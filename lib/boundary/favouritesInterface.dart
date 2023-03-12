import 'package:flutter/material.dart';

import 'package:parkassist/entity/favouritesEntity.dart';

class FavouritesInterface extends StatelessWidget {
  const FavouritesInterface({super.key});

/*   CarPark carparkdummy = CarPark(
    carParkID: "012",
    area: "JE",
    development: "HDB",
    location: "JE",
    availableLots: 10,
    lotType: "A",
    agency: "HDB",
  ); */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // top bar contains back arrow and "Favourites"
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              size: 24,
            ),
            onPressed: () {
              // change below line
              print("Back to map interface");
            },
          ),
          title: const Text('Favourites'),
          backgroundColor: Colors.green,
        ),

        // the rest is a list of carparks that got added into favourites
        // builder iterates through all items in favList
        body: ListView.builder(
            itemCount: FavouritesEntity.fetchFavouritesList().length,
            itemBuilder: (BuildContext context, index) {
              return ListTile(
                // for now, print out the location of the carpark. can change later
                title: Text(
                    FavouritesEntity.fetchFavouritesList()[index].location!),
                onTap: () {
                  // change below line of code
                  print("Back to map centred");
                },
              );
            }));
  }
}
