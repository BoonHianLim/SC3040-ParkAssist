class CarParkList {
  String? odataMetadata;
  List<CarPark>? carparks;

  CarParkList({this.odataMetadata, this.carparks});

  CarParkList.fromJson(Map<String, dynamic> json) {
    odataMetadata = json['odata.metadata'];
    if (json['value'] != null) {
      carparks = <CarPark>[];
      json['value'].forEach((v) {
        carparks!.add(new CarPark.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['odata.metadata'] = this.odataMetadata;
    if (this.carparks != null) {
      data['value'] = this.carparks!.map((v) => v.toJson()).toList();
    }
    return data;
  }



}
  



class CarPark {
  String? carParkID;
  String? area;
  String? development;
  String? location;
  int? availableLots;
  String? lotType;
  String? agency;

  CarPark(
      {this.carParkID,
      this.area,
      this.development,
      this.location,
      this.availableLots,
      this.lotType,
      this.agency});

  CarPark.fromJson(Map<String, dynamic> json) {
    carParkID = json['CarParkID'];
    area = json['Area'];
    development = json['Development'];
    location = json['Location'];
    availableLots = json['AvailableLots'];
    lotType = json['LotType'];
    agency = json['Agency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CarParkID'] = this.carParkID;
    data['Area'] = this.area;
    data['Development'] = this.development;
    data['Location'] = this.location;
    data['AvailableLots'] = this.availableLots;
    data['LotType'] = this.lotType;
    data['Agency'] = this.agency;
    return data;
  }
}
