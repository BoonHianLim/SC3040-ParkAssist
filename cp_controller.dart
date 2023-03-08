import 'dart:async';
import 'carpark.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CarparkEvent {}

class GetCarparks extends CarparkEvent {}

class Delete extends CarparkEvent {}

class CarparkController extends Bloc<CarparkEvent, List<CarparkData>> {
  static String url =
      'https://api.data.gov.sg/v1/transport/carpark-availability';
  CarparkController() : super([]) {
    on<GetCarparks>((event, emit) async {
      emit(await getCarparks());
      print('updated');
    });
    on<Delete>(
      (event, emit) {},
    );
  }
  Future<List<CarparkData>> getCarparks() async {
    var carparkList;
    var client = http.Client();
    try {
      var response = await client.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var jsonMap = json.decode(response.body);
        carparkList = CarparkList.fromJson(jsonMap);
      }
    } catch (Exception) {
      return carparkList.items[0].carparkData;
    }
    return carparkList.items[0].carparkData;
  }
}
