import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkassist/control/map_controller.dart';
import 'package:parkassist/entity/carpark.dart';
import 'package:parkassist/control/carpark_controller.dart';

class SearchInterface extends StatefulWidget {
  const SearchInterface({super.key});

  @override
  State<SearchInterface> createState() => _SearchInterfaceState();
}

class _SearchInterfaceState extends State<SearchInterface> {
  @override
  Widget build(BuildContext context) {
    List<CarPark> carparkList = CarParkController.getCarparkList();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Search'),
          backgroundColor: const Color(0xFF00E640),
          foregroundColor: Colors.black,
          actions: [
            IconButton(
                icon: const Icon(Icons.search),
                tooltip: 'Search',
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: CustomSearchDelegate(),
                  );
                }),
          ],
        ),
        body: ListView.builder(
            itemCount: carparkList.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                  onTap: () {
                    String location = carparkList[index].location!;
                    double lat = double.parse(location.split(" ")[0]);
                    double lng = double.parse(location.split(" ")[1]);
                    MapController.setCurrentCameraPosition(CameraPosition(
                        target: LatLng(lat, lng),
                        zoom: 18,
                        tilt: 0,
                        bearing: 0));
                    print("Back to map centred");
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 75,
                    color: Colors.white,
                    child: Center(
                      child: Text(carparkList[index].development!),
                    ),
                  ));
            }));
  }
}

class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        //icon: Icon(Icons.close)
        //clear query on press
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.close),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //leave and close search bar
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<CarPark> matchQuery = [];
    List<CarPark> carparkList = CarParkController.getCarparkList();
    for (var carpark in carparkList) {
      if (carpark.development!.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(carpark);
      }
    }

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        return GestureDetector(
            onTap: () {
              String location = matchQuery[index].location!;
              double lat = double.parse(location.split(" ")[0]);
              double lng = double.parse(location.split(" ")[1]);
              MapController.setCurrentCameraPosition(CameraPosition(
                  target: LatLng(lat, lng), zoom: 18, tilt: 0, bearing: 0));
              print("Back to map centred");
              // pop once to initial search screen then once more to map
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Container(
              height: 75,
              color: Colors.white,
              child: Center(
                child: Text(matchQuery[index].development!),
              ),
            ));
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<CarPark> matchQuery = [];
    List<CarPark> carparkList = CarParkController.getCarparkList();
    for (var carpark in carparkList) {
      if (carpark.development!.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(carpark);
      }
    }

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        return GestureDetector(
            onTap: () {
              String location = matchQuery[index].location!;
              double lat = double.parse(location.split(" ")[0]);
              double lng = double.parse(location.split(" ")[1]);
              MapController.setCurrentCameraPosition(CameraPosition(
                  target: LatLng(lat, lng), zoom: 18, tilt: 0, bearing: 0));
              print("Back to map centred");
              // pop once to initial search screen then once more to map
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Container(
              height: 75,
              color: Colors.white,
              child: Center(
                child: Text(matchQuery[index].development!),
              ),
            ));
      },
    );
  }
}
