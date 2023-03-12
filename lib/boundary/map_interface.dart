import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkassist/control/carParkController.dart';
import 'package:parkassist/control/map_controller.dart';
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
  @override
  void initState() {
    initMapController();
    super.initState();
  }

  //initialise map controller by requesing location access then updating user location
  initMapController() async {
    //now clicking on go to user location has a ~2sec delay
    await MapController.requestLocationAccess();
    await MapController.updateLocationAccessPermission();
    await MapController.updateCurrentUserLocation();

    //testing
    // CarParkController cpcontroller = CarParkController();
    // cpcontroller.getAllCarparks().then((value) {
    //   for (var element in value) {
    //     print(element.toJson());
    //   }
    //   print(CarParkList(carparks: value).toJson());
    // });
    MapController.setCurrentCameraPosition(
        MapController.getCurrentUserLocation());
    setState(() {
      status = 'ready';
      print("map ready");
    });
    // do i really need every second update of current user location?
    // timer = Timer.periodic(const Duration(seconds: 1), (Timer t) async {
    //   await MapController.updateCurrentUserLocation();
    //   print("updating current user location");
    // });
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
          title: const Text(
            "PARK ASSIST",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
          ),
          elevation: 0,
          backgroundColor: const Color(0xFF00E640),
          foregroundColor: Colors.black,
          actions: [
            IconButton(
                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                onPressed: () {
                  print("favourites pressed");
                },
                icon: const Icon(
                  Icons.star,
                  size: 36,
                ))
          ],
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "PARK ASSIST",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
          ),
          elevation: 0,
          backgroundColor: const Color(0xFF00E640),
          foregroundColor: Colors.black,
          actions: [
            IconButton(
                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                onPressed: () {
                  print("favourites pressed");
                },
                icon: const Icon(
                  Icons.star,
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
              markers: markers,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: Colors.black),
                  onPressed: () async {
                    if (MapController.getLocationAccessGranted()) {
                      await MapController.updateCurrentUserLocation();
                      mapController!.animateCamera(
                          CameraUpdate.newCameraPosition(
                              MapController.getCurrentUserLocation()));
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

//for testing
var markers = {
  Marker(
      markerId: const MarkerId("marker1"),
      position: const LatLng(1.287953, 103.851784),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)),
  Marker(
      markerId: const MarkerId("marker2"),
      position: const LatLng(1.294444, 103.846947),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)),
  Marker(
      markerId: const MarkerId("marker3"),
      position: const LatLng(1.282375, 103.864273),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      infoWindow: InfoWindow(
        title: "10 / 29 lots available",
        snippet: "click for more info",
        onTap: () {
          print("tapped");
        },
      ))
};

//for now no custom marker widget, so its just a generic yellow/red/green pin
//then when click will open infowindow showing available lots

