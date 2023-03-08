import 'package:flutter_bloc/flutter_bloc.dart';
import 'cp_controller.dart';
import 'package:flutter/material.dart';
import 'mainpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'carpark',
      home: BlocProvider(
        create: (_) => CarparkController(),
        child: MainPage(),
      ),
    );
  }
}
