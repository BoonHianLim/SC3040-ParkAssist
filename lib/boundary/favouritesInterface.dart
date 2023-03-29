import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkassist/control/favouritesController.dart';
import 'package:parkassist/control/map_controller.dart';
import 'package:parkassist/entity/carParkList.dart';

///Interface to display favourites
class FavouritesInterface extends StatefulWidget {
  const FavouritesInterface({super.key});

  @override
  State<FavouritesInterface> createState() => _FavouritesInterfaceState();
}

class _FavouritesInterfaceState extends State<FavouritesInterface> {
  ///List of favourite carparks
  List<CarPark> _favList = [];
  @override
  void initState() {
    _setup();
    super.initState();
  }

  ///Get list of favourites from favourites controller then set state
  _setup() async {
    List<CarPark>? favList = await FavouritesController.fetchFavouritesList();

    setState(() {
      // if something went wrong, favList will be null
      // and the initial empty list remains
      _favList = favList;
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
                  title: Text(_favList[index].development!),
                  onTap: () {
                    String location = _favList[index].location!;
                    double lat = double.parse(location.split(" ")[0]);
                    double lng = double.parse(location.split(" ")[1]);
                    MapController.setCurrentCameraPosition(
                        CameraPosition(target: LatLng(lat, lng), zoom: 15, tilt: 0, bearing: 0));
                    print("Back to map centred");
                    Navigator.pop(context);
                  },
                );
              }));
    }
  }
}
