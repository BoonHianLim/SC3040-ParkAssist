import 'dart:async';
import 'dart:io';

import 'package:parkassist/control/carParkController.dart';
import 'package:path_provider/path_provider.dart';

import 'package:parkassist/entity/carParkList.dart';

class FavouritesEntity {
  /// DATA STORAGE FORMAT:
  /// Text file in use: favouritesTxt.txt
  /// Location of text file: (AppData)/favouritesTxt.txt
  ///
  /// Formatting of text file: ID1,ID2,ID3,ID4,...,IDn,
  /// - Everything is written in ONE LINE, no newline will be inside the file

  static List<CarPark> favouritesList = [];

  // get path name for the specified device
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  // get the exact file inside appdata of local device using path name
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/favouritesTxt.txt');
  }

  // this function will run during initialization
  // fetch the full list of favourites list from favouritesTxt and store into List<CarPark>
  void fetchFavouritesList() async {
    late String contents;

    // 1. read the contents of the file into a string
    try {
      final file = await _localFile;
      contents = await file.readAsString();
    } catch (e) {
      // If encountering an error, terminate the function
      return null;
    }

    // 2. convert the string into a list of carParkIDs
    List<String> idList = contents.toString().split(',');

    // 3. match carParkIDs against carParkList to obtain the full object CarPark
    favouritesList.clear(); //reset the list of carparks
    for (var item in idList) {
      CarPark target = await CarParkController().getCarpark(item);
      favouritesList.add(target);
    }
  }

  // this function will run whenever favouritesList got added into or removed from
  // update the txt file with the updates favouritesList
  void updateFavouritesTxt() async {
    // 1. Retrieve only the carParkIDs from each CarPark
    // 2. convert list of carParkIDs into a string
    String idList = '';
    for (var item in favouritesList) {
      idList += '${item.carParkID!},';
    }

    // 3. write the strings into the file
    final file = await _localFile;
    file.writeAsString(idList);
  }
}
