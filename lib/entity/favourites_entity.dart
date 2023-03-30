import 'dart:async';
import 'dart:io';

import 'package:parkassist/control/carpark_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:parkassist/entity/carpark.dart';

///Entity class for favourites to interface with text file as permanent data storage
///
///DATA STORAGE FORMAT:
///
///Text file in use: favouritesTxt.txt,
///Location of text file: (AppData)/favouritesTxt.txt
///
///Formatting of text file: ID1,ID2,ID3,ID4,...,IDn,
/// - Everything is written in ONE LINE, no newline will be inside the file
class FavouritesEntity {
  ///Get path name for the specified device and return it as a future
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  ///Get the exact file inside appdata of local device using path name and return it as a future
  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/favouritesTxt.txt');
  }

  ///Fetch favourites list from phone storage txt file and return it as a future
  static Future<List<CarPark>> fetchFavouritesList() async {
    late String contents;
    // 1. read the contents of the file into a string
    try {
      final file = await _localFile;

      // Read the file
      contents = await file.readAsString();
    } catch (e) {
      // If encountering an error, return 0
      List<CarPark> dummy = [];
      return dummy;
    }

    // 2. convert the string into a list of carParkIDs
    List<String> idList = contents.toString().split(',');
    // the file ends with a trailing comma
    // drop that line
    idList.removeLast();

    // 3. match carParkIDs against carParkList to obtain the full object CarPark
    List<CarPark> favouritesList = [];
    for (var id in idList) {
      CarPark target = CarParkController.getCarparkByID(id);
      favouritesList.add(target);
    }

    // 4. return favourites list
    return favouritesList;
  }

  ///Update favourites list txt file on phone storage
  static void updateFavouritesTxt(List<CarPark> favList) async {
    // 1. Retrieve only the carParkIDs from each CarPark
    // 2. convert list of carParkIDs into a string
    String idList = '';
    for (var item in favList) {
      idList += '${item.carParkID!},';
    }

    // 3. write the strings into the file
    final file = await _localFile;
    file.writeAsString(idList);
  }
}
