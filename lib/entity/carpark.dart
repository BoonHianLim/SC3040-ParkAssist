///Entity class for car park, contains all relevant information
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CarParkID'] = carParkID;
    data['Area'] = area;
    data['Development'] = development;
    data['Location'] = location;
    data['AvailableLots'] = availableLots;
    data['LotType'] = lotType;
    data['Agency'] = agency;
    return data;
  }

  @override
  String toString() {
    return "id:$carParkID,area:$area,development:$development,location:$location,available lots:$availableLots,lotType:$lotType,agency:$agency";
  }
}
