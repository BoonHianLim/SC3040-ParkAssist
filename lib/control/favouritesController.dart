import 'package:parkassist/entity/carParkList.dart';
import 'package:parkassist/entity/favouritesEntity.dart';

class FavouritesController {
  static Future<List<CarPark>> fetchFavouritesList() {
    return FavouritesEntity.fetchFavouritesList();
  }

  static List<CarPark> addToFavourites(List<CarPark> favList, CarPark carpark) {
    // favList is NOT supposed to contain that carpark
    // and this function is only supposed to call itself when the carpark is NOT in favList
    // in the case where it isn't, run nothing
    // this function is here to prevent software from crashing
    if (!favList.contains(carpark)) {
      favList.add(carpark);
    }

    // update the text file
    FavouritesEntity.updateFavouritesTxt(favList);

    // return to calling program for continuous use
    return favList;
  }

  static List<CarPark> removeFromFavourites(
      List<CarPark> favList, CarPark carpark) {
    // favList is supposed to contain that carpark
    // and this function is only supposed to call itself when the carpark is in favList
    // in the case where it isn't, run nothing
    // this function is here to prevent software from crashing
    if (favList.contains(carpark)) {
      favList.remove(carpark);
    }

    // update the text file
    FavouritesEntity.updateFavouritesTxt(favList);

    // return to calling program for continuous use
    return favList;
  }
}
