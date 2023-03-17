// This class implements the MapController with
// the attributes locationAccessGranted and currentCameraPosition
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapController {
  // whether user has granted location access
  bool locationAccessGranted;
  // current camera position on the map
  CameraPosition currentCameraPosition;
  // constructor
  MapController(
      {required this.locationAccessGranted,
      required this.currentCameraPosition});

  // update whether user has granted location access
  void updateLocationAccessPermission() {}
  // request location access from user
  void requestLocationAccess() {}
  // get current position of user
  CameraPosition getCurrentPosition() {
    return const CameraPosition(target: LatLng(0, 0));
  }

  // update current position of user
  void updateCurrentUserLocation() {}
}
