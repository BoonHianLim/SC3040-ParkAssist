import 'package:parkassist/entity/carpark.dart';

///Entity class for CarParkList, contains a list of car parks
class CarParkList {
  String? odataMetadata;
  List<CarPark>? carparks;

  CarParkList({this.odataMetadata, this.carparks});

  CarParkList.fromJson(Map<String, dynamic> json) {
    odataMetadata = json['odata.metadata'];
    if (json['value'] != null) {
      carparks = <CarPark>[];
      json['value'].forEach((v) {
        carparks!.add(CarPark.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['odata.metadata'] = odataMetadata;
    if (carparks != null) {
      data['value'] = carparks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
