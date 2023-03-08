import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkassist/control/map_controller.dart';

class MapInterface extends StatefulWidget {
  const MapInterface({super.key});

  @override
  State<MapInterface> createState() => _MapInterfaceState();
}

class _MapInterfaceState extends State<MapInterface> {
  bool isLocationAccessGranted = false;
  CameraPosition currentLocation = const CameraPosition(
      target: LatLng(1.287953, 103.851784), zoom: 15, tilt: 0, bearing: 0);
  GoogleMapController? mapController;
  @override
  void initState() {
    checkLocationPermission();
    super.initState();
  }

  checkLocationPermission() async {
    await MapController.isLocationAccessGranted().then((value) {
      setState(() {
        isLocationAccessGranted = value;
      });
    });
  }

  onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLocationAccessGranted) {
      MapController.getCurrentLocation().then((value) {
        setState(() {
          currentLocation = CameraPosition(
              target: LatLng(value.latitude, value.longitude),
              zoom: 15,
              tilt: 0,
              bearing: 0);
        });
      });
    }

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
        children: [
          GoogleMap(
            onMapCreated: onMapCreated,
            initialCameraPosition: currentLocation,
            myLocationEnabled:
                false, //set to isLocationAccessGranted, is set to false for now cos its flooding debug console
            myLocationButtonEnabled: false,
          ),
          IconButton(
              //move to bottom left of screen and add circular border and fill
              color: Colors.black,
              onPressed: () async {
                if (isLocationAccessGranted) {
                  mapController!.animateCamera(
                      CameraUpdate.newCameraPosition(currentLocation));
                } else {
                  await MapController.requestLocationAccess()
                      .then((value) => checkLocationPermission());
                }
              },
              icon: const Icon(Icons.pin_drop)),
        ],
      ),
    );
  }
}
