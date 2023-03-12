import 'package:parkassist/entity/carParkList.dart';
import 'package:parkassist/entity/favouritesEntity.dart';

class FavouritesController {
  List<CarPark> favList = FavouritesEntity.favouritesList;

  void addToFavourites(CarPark carpark) {
    // favList is NOT supposed to contain that carpark
    // and this function is only supposed to call itself when the carpark is NOT in favList
    // in the case where it isn't, run nothing
    // this function is here to prevent software from crashing
    if (!favList.contains(carpark)) {
      favList.add(carpark);
    }
  }

  void removeFromFavourites(CarPark carpark) {
    // favList is supposed to contain that carpark
    // and this function is only supposed to call itself when the carpark is in favList
    // in the case where it isn't, run nothing
    // this function is here to prevent software from crashing
    if (favList.contains(carpark)) {
      favList.remove(carpark);
    }
  }
}
