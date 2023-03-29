import 'package:parkassist/entity/carParkList.dart';
import 'package:parkassist/entity/favouritesEntity.dart';

///Controller class for editing favourites list
class FavouritesController {
  ///Fetch current list of favourites
  static Future<List<CarPark>> fetchFavouritesList() {
    return FavouritesEntity.fetchFavouritesList();
  }

  ///Check whether a carpark is in favourites list and returns a future
  static Future<bool> inFavourites(CarPark carpark) async {
    List<CarPark> favList = await fetchFavouritesList();
    return favList.contains(carpark);
  }

  ///Add a carpark to list of favourites
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

  ///Remove a carpark from list of favourites
  static List<CarPark> removeFromFavourites(List<CarPark> favList, CarPark carpark) {
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

  ///Clear list of favourites, mainly for testing purposes
  static void clearFavList() {
    FavouritesEntity.updateFavouritesTxt([]);
  }
}
