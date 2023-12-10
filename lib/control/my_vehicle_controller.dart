import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class MyVehicleController {
  static BitmapDescriptor? myVehicleIcon;
  static late LatLng latlng;
  static late SharedPreferences prefs;
  static bool _isExist = false;
  static bool _isInit = false;

  static bool isExist() {
    if (!_isInit) {
      throw Exception("MyVehicleController not initialized");
    }
    return _isExist;
  }

  static Future<void> init(
      Set<Marker> markersList, Function(Function()) setState) async {
    Uint8List data = await _getBytesFromAsset('assets/marker2.png', 250);
    myVehicleIcon = BitmapDescriptor.fromBytes(data);
    prefs = await SharedPreferences.getInstance();
    _isInit = true;
    createMarker(markersList, setState);
  }

  static Future<void> createMarker(Set<Marker> markersList, Function(Function()) setState) async{
    await _fetchMyVehicleLocation();
    if (isExist()) {
      markersList.add(myVehicleMarker(latlng, markersList, setState));
    }
  }

  static Future<Uint8List> _getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  static void setLatLng(LatLng latlng) {
    _isExist = true;
    MyVehicleController.latlng = latlng;
    _updateMyVehicleLocation();
  }

  static void removeLatLng() {
    _isExist = false;
    _removeMyVehicleLocation();
  }

  static CameraPosition getTempCurrentVehicleLocation(LatLng latlng) {
    return CameraPosition(
        target: LatLng(latlng.latitude - 0.002, latlng.longitude),
        zoom: 16,
        tilt: 0,
        bearing: 0);
  }

  static Marker myVehicleMarker(
    LatLng latlng,
    Set<Marker> markersList,
    Function(Function()) setState,
  ) {
    Marker? marker;
    marker = Marker(
        markerId: MarkerId('my_vehicle'),
        position: latlng,
        icon: myVehicleIcon ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
        infoWindow: InfoWindow(
          title: "Your Vehicle Last Location",
          snippet: "Click to Navigate",
          onTap: () async {
            //print("tapped $id");
            String googleUrl =
                'https://www.google.com/maps/dir/?api=1&destination=${latlng.latitude},${latlng.longitude}&travelmode=walking';
            launchUrl(Uri.parse(googleUrl));
            setState(() {
              markersList.remove(marker);
              removeLatLng();
            });
          },
        ));
    return marker;
  }

  static CameraPosition getCurrentVehicleLocation() {
    return CameraPosition(target: latlng, zoom: 16, tilt: 0, bearing: 0);
  }

  static Future<void> _fetchMyVehicleLocation() async {
    double? latitude = prefs.getDouble('myVehicleLat');
    double? longtitude = prefs.getDouble('myVehicleLng');
    if (latitude != null && longtitude != null) {
      latlng = LatLng(latitude, longtitude);
      _isExist = true;
    }
  }

  static void _updateMyVehicleLocation() async {
    prefs.setDouble('myVehicleLat', latlng.latitude);
    prefs.setDouble('myVehicleLng', latlng.longitude);
  }

  static void _removeMyVehicleLocation() async {
    await prefs.remove('myVehicleLat');
    await prefs.remove('myVehicleLng');
  }
}
