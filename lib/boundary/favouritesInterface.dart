import 'package:flutter/material.dart';

import 'package:parkassist/control/favouritesController.dart';
import 'package:parkassist/entity/carParkList.dart';

class FavouritesInterface extends StatefulWidget {
  const FavouritesInterface({super.key});

  @override
  State<FavouritesInterface> createState() => _FavouritesInterfaceState();
}

class _FavouritesInterfaceState extends State<FavouritesInterface> {
  static CarPark carparkdummy = CarPark(
    carParkID: "012",
    area: "JE",
    development: "HDB",
    location: "JE",
    availableLots: 10,
    lotType: "A",
    agency: "HDB",
  );

  // _ private to this class
  // the public class is the Future class
  // which will use 'await' to convert into the standard class
  List<CarPark> _favList = [];
  @override
  void initState() {
    _setup();
    super.initState();
  }

  // on initiating this interface
  // wait for favourites list to finish fetching from text file
  // then, call a change in state
  _setup() async {
    List<CarPark>? favList = await FavouritesController.fetchFavouritesList();

    setState(() {
      // if something went wrong, favList will be null
      // and the initial empty list remains
      if (favList != null) {
        _favList = favList;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_favList.isEmpty) {
      return Scaffold(
          // top bar contains back arrow and "Favourites"
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                size: 24,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text('Favourites'),
            backgroundColor: Colors.green,
          ),
          body: const Center(
            child: Text("You do not have any favourite carparks!"),
          ));
    } else {
      return Scaffold(
          // top bar contains back arrow and "Favourites"
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                size: 24,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text('Favourites'),
            backgroundColor: Colors.green,
          ),

          // the rest is a list of carparks that got added into favourites
          // builder iterates through all items in favList
          body: ListView.builder(
              itemCount: _favList.length,
              itemBuilder: (BuildContext context, index) {
                return ListTile(
                  // for now, print out the location of the carpark. can change later
                  title: Text(_favList[index].location!),
                  onTap: () {
                    // change below line of code
                    print("Back to map centred");
                  },
                );
              }));
    }
  }
}
