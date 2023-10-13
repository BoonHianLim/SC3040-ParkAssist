import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkassist/boundary/info_interface.dart';
import 'package:parkassist/boundary/search_interface.dart';
import 'package:parkassist/control/carpark_controller.dart';
import 'package:parkassist/control/history_controller.dart';
import 'package:parkassist/control/map_controller.dart';
import 'package:parkassist/boundary/favourites_interface.dart';
import 'package:parkassist/control/my_vehicle_controller.dart';
import 'package:parkassist/entity/carpark.dart';
import 'package:url_launcher/url_launcher.dart';

///Interface to display main page which contains the map
class MapInterface extends StatefulWidget {
  const MapInterface({super.key});

  @override
  State<MapInterface> createState() => _MapInterfaceState();
}

class _MapInterfaceState extends State<MapInterface> {
  ///Google maps controller, for animating movement of map
  GoogleMapController? mapController;

  ///Load status of page
  String status = 'waiting';

  ///List of markers to be displayed on map
  Set<Marker> markersList = {};

  @override
  void initState() {
    initMap();
    super.initState();
  }

  ///Initialise map by requesing location access then updating user location and updating markers
  initMap() async {
    await MapController.requestLocationAccess();
    await MapController.updateLocationAccessPermission();
    await MapController.updateCurrentUserLocation();
    await buildMarkers();
    await MyVehicleController.init(markersList, setState);
    await HistoryController.fetchHistoryList();

    //set camera position to userlocation
    MapController.setCurrentCameraPosition(
        MapController.getCurrentUserLocation());
    setState(() {
      status = 'ready';
    });
  }

  ///Update list of markers
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

  ///Returns a google maps marker given a carpark
  Marker createMarker(CarPark cp, BuildContext context) {
    final Map cpMap = cp.toJson();
    final String id = cpMap["CarParkID"];
    final double latitude =
        double.parse((cpMap["Location"] as String).split(" ")[0]);
    final double longitude =
        double.parse((cpMap["Location"] as String).split(" ")[1]);

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
            //print("tapped $id");
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => InfoInterface(carParkID: id)));
            await buildMarkers();
          },
        ));
  }

  ///Initialise google map controller
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
              onPressed: () {},
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
                onPressed: () {},
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
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SearchInterface()));
                await buildMarkers();
                mapController!.animateCamera(CameraUpdate.newCameraPosition(
                    MapController.getCurrentCameraPosition()));
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
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FavouritesInterface()));
                  await buildMarkers();
                  mapController!.animateCamera(CameraUpdate.newCameraPosition(
                      MapController.getCurrentCameraPosition()));
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
              onLongPress: (LatLng latLng) {
                Marker? previousMarker;
                Marker? backupMarker;
                print(markersList
                    .where((element) => element.markerId.value == 'my_vehicle')
                    .length);
                try {
                  previousMarker = markersList.firstWhere(
                      (marker) => marker.markerId.value == 'my_vehicle');
                } catch (e) {}

                if ((previousMarker != null)) {
                  backupMarker = MyVehicleController.myVehicleMarker(
                      previousMarker.position, markersList, setState);
                  setState(() {
                    markersList.remove(previousMarker);
                  });
                }

                setState(() {
                  markersList.add(MyVehicleController.myVehicleMarker(latLng, markersList, setState));
                });
                mapController!.animateCamera(CameraUpdate.newCameraPosition(
                    MyVehicleController.getTempCurrentVehicleLocation(latLng)));

                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    content: const Text(
                        'Are you sure you want to set your vehicle to a new location?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          setState(() {
                            previousMarker = markersList.firstWhere((marker) =>
                                marker.markerId.value == 'my_vehicle');
                            markersList.remove(previousMarker);
                            if (backupMarker != null) {
                              markersList.add(backupMarker);
                            }
                          });
                          Navigator.pop(context, 'Cancel');
                          return;
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, 'OK');
                          MyVehicleController.setLatLng(latLng);
                          setState(() {});
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              onCameraMove: (position) {
                MapController.setCurrentCameraPosition(position);
              },
              onMapCreated: onMapCreated,
              initialCameraPosition: MapController.getCurrentCameraPosition(),
              myLocationEnabled:
                  true, //set to isLocationAccessGranted, is set to false for now cos its flooding debug console
              myLocationButtonEnabled: false,
              markers: markersList,
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (MyVehicleController.isExist())
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(
                                side: BorderSide(
                                  color: Colors.black,
                                  width: 7.0,
                                ),
                              ),
                              backgroundColor: Color(0xFF00E640)),
                          onPressed: () async {
                            if (MapController.getLocationAccessGranted()) {
                              await MapController.updateCurrentUserLocation();
                              mapController!.animateCamera(
                                  CameraUpdate.newCameraPosition(
                                      MyVehicleController
                                          .getCurrentVehicleLocation()));
                            } else {
                              await MapController.requestLocationAccess()
                                  .then((value) {
                                MapController.updateLocationAccessPermission();
                              });
                            }
                          },
                          child: const Icon(
                            Icons.directions_car_rounded,
                            color: Colors.black,
                            size: 80,
                          )),
                    const SizedBox(
                      height: 10.0,
                    ),
                    ElevatedButton(
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
                            await MapController.requestLocationAccess()
                                .then((value) {
                              MapController.updateLocationAccessPermission();
                            });
                          }
                        },
                        child: const Icon(
                          Icons.flag_circle_rounded,
                          color: Color(0xFF00E640),
                          size: 80,
                        )),
                  ],
                ))
          ],
        ),
      );
    }
  }
}
