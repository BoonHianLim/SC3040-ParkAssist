import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkassist/boundary/infoInterface.dart';
import 'package:parkassist/boundary/searchInterface.dart';
import 'package:parkassist/control/carParkController.dart';
import 'package:parkassist/control/map_controller.dart';
import 'package:parkassist/boundary/favouritesInterface.dart';
import 'package:parkassist/entity/carParkList.dart';

class MapInterface extends StatefulWidget {
  const MapInterface({super.key});

  @override
  State<MapInterface> createState() => _MapInterfaceState();
}

class _MapInterfaceState extends State<MapInterface> {
  GoogleMapController? mapController;
  Timer? timer;
  String status = 'waiting';
  Set<Marker> markersList = {};
  @override
  void initState() {
    initMap();
    super.initState();
  }

  //initialise map controller by requesing location access then updating user location
  initMap() async {
    //now clicking on go to user location has a ~2sec delay
    await MapController.requestLocationAccess();
    await MapController.updateLocationAccessPermission();
    await MapController.updateCurrentUserLocation();
    await buildMarkers();

    //set camera position to userlocation
    MapController.setCurrentCameraPosition(MapController.getCurrentUserLocation());
    setState(() {
      status = 'ready';
      print("map ready");
    });
    // do i need every second update of current user location? probably not
    // now is only updated when user clicks on the button
    // timer = Timer.periodic(const Duration(seconds: 1), (Timer t) async {
    //   await MapController.updateCurrentUserLocation();
    //   print("updating current user location");
    // });
  }

  buildMarkers() async {
    await CarParkController.updateCarparkList();
    //create markers based on carpark then add to markersList
    Set<Marker> markers = {};
    List<CarPark> carparkList = CarParkController.getCarparkList();
    for (var carpark in carparkList) {
      // ignore: use_build_context_synchronously
      Marker marker = createMarker(carpark, context);
      markers.add(marker);
    }
    setState(() {
      markersList = markers;
    });
  }

  Marker createMarker(CarPark cp, BuildContext context) {
    final Map cpMap = cp.toJson();
    final String id = cpMap["CarParkID"];
    final double latitude = double.parse((cpMap["Location"] as String).split(" ")[0]);
    final double longitude = double.parse((cpMap["Location"] as String).split(" ")[1]);

    final LatLng latlng = LatLng(latitude, longitude);
    final int availableLots = cpMap["AvailableLots"];

    final hue = availableLots == 0
        ? BitmapDescriptor.hueRed
        : availableLots < 10
            ? BitmapDescriptor.hueYellow
            : BitmapDescriptor.hueGreen;

    return Marker(
        markerId: MarkerId(id),
        position: latlng,
        icon: BitmapDescriptor.defaultMarkerWithHue(hue),
        infoWindow: InfoWindow(
          title: "$availableLots lots available",
          snippet: "click for more info",
          onTap: () async {
            print("tapped $id");
            await Navigator.push(
                context, MaterialPageRoute(builder: (context) => InfoInterface(carParkID: id)));
            await buildMarkers();
          },
        ));
  }

  //to define GoogleMapController
  onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (status == 'waiting') {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const SearchInterface()));
              },
              icon: const Icon(
                Icons.search,
                size: 36,
              )),
          title: const Text(
            "PARK ASSIST",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: const Color(0xFF00E640),
          foregroundColor: Colors.black,
          actions: [
            IconButton(
                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const FavouritesInterface()));
                },
                icon: const Icon(
                  Icons.stars,
                  size: 36,
                ))
          ],
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              onPressed: () async {
                await Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const SearchInterface()));
                await buildMarkers();
              },
              icon: const Icon(
                Icons.search,
                size: 36,
              )),
          title: const Text(
            "PARK ASSIST",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: const Color(0xFF00E640),
          foregroundColor: Colors.black,
          actions: [
            IconButton(
                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                onPressed: () async {
                  await Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const FavouritesInterface()));
                  await buildMarkers();
                  mapController!.animateCamera(
                      CameraUpdate.newCameraPosition(MapController.getCurrentCameraPosition()));
                },
                icon: const Icon(
                  Icons.stars,
                  size: 36,
                ))
          ],
        ),
        body: Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            GoogleMap(
              onMapCreated: onMapCreated,
              initialCameraPosition: MapController.getCurrentCameraPosition(),
              myLocationEnabled:
                  false, //set to isLocationAccessGranted, is set to false for now cos its flooding debug console
              myLocationButtonEnabled: false,
              markers: markersList,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(), backgroundColor: Colors.black),
                  onPressed: () async {
                    if (MapController.getLocationAccessGranted()) {
                      await MapController.updateCurrentUserLocation();
                      mapController!.animateCamera(
                          CameraUpdate.newCameraPosition(MapController.getCurrentUserLocation()));
                    } else {
                      await MapController.requestLocationAccess().then((value) {
                        MapController.updateLocationAccessPermission();
                      });
                    }
                  },
                  child: const Icon(
                    Icons.flag_circle_rounded,
                    color: Color(0xFF00E640),
                    size: 80,
                  )),
            )
          ],
        ),
      );
    }
  }
}

//example of carpark toJson
//{CarParkID: Y75M, Area: , Development: BLOCK 674 YISHUN AVENUE 4, 
//Location: 1.420176401 103.8430835, AvailableLots: 327, LotType: C, Agency: HDB}