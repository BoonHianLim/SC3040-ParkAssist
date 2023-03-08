import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class MapController {
  //check if location access is granted
  static Future<bool> isLocationAccessGranted() {
    return Permission.location.status.isGranted;
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

  static Future<Position> getCurrentLocation() {
    return Geolocator.getCurrentPosition();
  }
}
