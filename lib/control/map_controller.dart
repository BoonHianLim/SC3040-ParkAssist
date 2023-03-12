import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class MapController {
  //static variables
  static bool locationAccessGranted = false;
  static CameraPosition currentCameraPosition = const CameraPosition(
      target: LatLng(1.287953, 103.851784), zoom: 15, tilt: 0, bearing: 0);
  static CameraPosition currentUserLocation = const CameraPosition(
      target: LatLng(1.287953, 103.851784), zoom: 15, tilt: 0, bearing: 0);
  //getter functions
  static bool getLocationAccessGranted() {
    return MapController.locationAccessGranted;
  }

  static CameraPosition getCurrentCameraPosition() {
    return MapController.currentCameraPosition;
  }

  static CameraPosition getCurrentUserLocation() {
    return MapController.currentUserLocation;
  }

  //setter functions
  static setLocationAccessGranted(bool locationAccessGranted) {
    MapController.locationAccessGranted = locationAccessGranted;
  }

  static setCurrentCameraPosition(CameraPosition newLocation) {
    MapController.currentCameraPosition = newLocation;
  }

  static setCurrentUserLocation(CameraPosition userCurrentLocation) {
    MapController.currentUserLocation = userCurrentLocation;
  }

  //update if location access is granted
  static Future<void> updateLocationAccessPermission() async {
    await Permission.location.status.isGranted.then((value) {
      MapController.setLocationAccessGranted(value);
    });
  }

  //requests location access
  static Future<void> requestLocationAccess() async {
    //check if location services is enabled on phone
    if (await Permission.location.serviceStatus.isEnabled) {
      print("location service enabled");
      print("requesting permission");
      //check if location permission is granted if not request permission
      var status = await Permission.location.status;
      if (status.isGranted) {
        print("permission enabled");
      } else {
        print("permission denied");
        PermissionStatus permissionStatus = await Permission.location.request();
        print(permissionStatus);
        //check if location permission permanently denied
        if (permissionStatus.isPermanentlyDenied) {
          print("permanent disabled");
          openAppSettings();
        }
      }
    } else {
      print("location service not enabled");
    }
  }

  //get current user position using geolocator
  static Future<Position> getCurrentLocation() {
    return Geolocator.getCurrentPosition();
  }

  static Future<void> updateCurrentUserLocation() async {
    if (MapController.getLocationAccessGranted()) {
      await getCurrentLocation().then((value) {
        MapController.setCurrentUserLocation(CameraPosition(
            target: LatLng(value.latitude, value.longitude),
            zoom: 15,
            tilt: 0,
            bearing: 0));
      });
    }
  }
}
