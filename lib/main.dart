import 'package:flutter/material.dart';
import 'package:parkassist/boundary/map_interface.dart';
import 'package:parkassist/control/history_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MapInterface(),
    );
  }
}
