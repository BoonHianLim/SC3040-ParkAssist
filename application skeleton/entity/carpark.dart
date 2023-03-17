// This class implements the Carpark entity with
// the attributes carparkID, area, development, location, availableLots, lotType and agency
class CarPark {
  // id of carpark
  String? carParkID;
  // area of carpark
  String? area;
  // name of carpark
  String? development;
  // coordinates of carpark
  String? location;
  // number of available lots
  int? availableLots;
  // type of lot available
  String? lotType;
  // agency carpark is associated with
  String? agency;

  // constructor
  CarPark(
      {this.carParkID,
      this.area,
      this.development,
      this.location,
      this.availableLots,
      this.lotType,
      this.agency});
}
