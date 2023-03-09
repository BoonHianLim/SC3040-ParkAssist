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
        alignment: AlignmentDirectional.bottomStart,
        children: [
          GoogleMap(
            onMapCreated: onMapCreated,
            initialCameraPosition: currentLocation,
            myLocationEnabled:
                false, //set to isLocationAccessGranted, is set to false for now cos its flooding debug console
            myLocationButtonEnabled: false,
            markers: markers,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(), backgroundColor: Colors.black),
                onPressed: () async {
                  if (isLocationAccessGranted) {
                    mapController!.animateCamera(
                        CameraUpdate.newCameraPosition(currentLocation));
                  } else {
                    await MapController.requestLocationAccess()
                        .then((value) => checkLocationPermission());
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

//TODO make custom marker widget? dk how