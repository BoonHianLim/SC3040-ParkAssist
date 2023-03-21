import 'package:flutter/material.dart';
import 'package:parkassist/boundary/map_interface.dart';
import 'package:parkassist/boundary/searchInterface.dart';

void main() {
  runApp(const MyApp());
}

/// Note from Wen Zhan (Made on 13th March 2023, 1.50am)
/// There may be a need to encase ChangeNotifierProvider around MyApp
///
/// Stateful Widget alone cannot live update the list of favourites
/// Only ChangeNotifierProvider can do so because the call to update does not
/// come from favouritesController
///
/// We can discuss this when we next meet up, I am not changing this yet
/// because main.dart affects everyone and I don't want to mess things up
///
/// Some other classes, for eg. carParkController, may also need to extend
/// ChangeProvider after importing provider dependency because this class
/// runs updateFavouritesList()

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SearchInterface(),
    );
  }
}
