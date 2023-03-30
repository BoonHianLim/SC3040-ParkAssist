import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

///Controller class for map and location permissions
class MapController {
  ///Bool storing whether location permission is granted
  static bool locationAccessGranted = false;

  ///Current camera position stored in map controller
  static CameraPosition currentCameraPosition = const CameraPosition(
      target: LatLng(1.287953, 103.851784), zoom: 16, tilt: 0, bearing: 0);

  ///Camera position of current user location stored in map controller
  static CameraPosition currentUserLocation = const CameraPosition(
      target: LatLng(1.287953, 103.851784), zoom: 16, tilt: 0, bearing: 0);
  //getter functions
  ///Return bool on whether location access is granted
  static bool getLocationAccessGranted() {
    return MapController.locationAccessGranted;
  }

  ///Return current camera position stored in map controller
  static CameraPosition getCurrentCameraPosition() {
    return MapController.currentCameraPosition;
  }

  ///Return current user location stored in map controller
  static CameraPosition getCurrentUserLocation() {
    return MapController.currentUserLocation;
  }

  //setter functions
  ///Set location access granted bool
  static setLocationAccessGranted(bool locationAccessGranted) {
    MapController.locationAccessGranted = locationAccessGranted;
  }

  ///Set current camera position
  static setCurrentCameraPosition(CameraPosition newLocation) {
    MapController.currentCameraPosition = newLocation;
  }

  ///Set current user location
  static setCurrentUserLocation(CameraPosition userCurrentLocation) {
    MapController.currentUserLocation = userCurrentLocation;
  }

  ///Update if location access is granted
  static Future<void> updateLocationAccessPermission() async {
    await Permission.location.status.isGranted.then((value) {
      MapController.setLocationAccessGranted(value);
    });
  }

  ///Check if location permission is granted.
  ///If not, request location access from user.
  ///
  ///If user has permanently denied location permission, open app settings.
  static Future<void> requestLocationAccess() async {
    //check if location services is enabled on phone
    if (await Permission.location.serviceStatus.isEnabled) {
      //print("location service enabled");
      //print("requesting permission");
      //check if location permission is granted if not request permission
      var status = await Permission.location.status;
      if (status.isGranted) {
        //print("permission enabled");
      } else {
        //print("permission denied");
        PermissionStatus permissionStatus = await Permission.location.request();
        //print(permissionStatus);
        //check if location permission permanently denied
        if (permissionStatus.isPermanentlyDenied) {
          //print("permanent disabled");
          openAppSettings();
        }
      }
    } else {
      //print("location service not enabled");
    }
  }

  ///Returns a future of the current user position using geolocator
  static Future<Position> getCurrentLocation() {
    return Geolocator.getCurrentPosition();
  }

  ///Update the current user location stored in the map controller
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
