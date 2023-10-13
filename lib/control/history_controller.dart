import 'dart:io';

import 'package:parkassist/control/carpark_controller.dart';
import 'package:parkassist/entity/carpark.dart';
import 'package:parkassist/entity/history_entity.dart';
import 'package:path_provider/path_provider.dart';

///Controller class for editing favourites list
class HistoryController {
  ///Fetch current list of favourites
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  ///Get the exact file inside appdata of local device using path name and return it as a future
  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/historyTxt.txt');
  }

  ///Fetch favourites list from phone storage txt file and return it as a future
  static Future<void> fetchHistoryList() async {
    late String contents;
    // 1. read the contents of the file into a string
    try {
      final file = await _localFile;

      // Read the file
      contents = await file.readAsString();
    } catch (e) {
      // If encountering an error, change nothing and return
      return;
    }

    // 2. convert the string into a list of carParkIDs
    List<String> idList = contents.toString().split(',');
    // the file ends with a trailing comma
    // drop that line
    idList.removeLast();

    // 3. match carParkIDs against carParkList to obtain the full object CarPark
    List<CarPark> historyList = [];
    for (var id in idList) {
      CarPark target = CarParkController.getCarparkByID(id);
      historyList.add(target);
    }

    // 4. import history list into history entity
    historyEntity.addHistoryList(carparkList: historyList);
  }

  ///Update favourites list txt file on phone storage
  static void updateFavouritesTxt() async {
    // 1. Retrieve only the carParkIDs from each CarPark
    // 2. convert list of carParkIDs into a string
    String idList = '';
    for (var item in historyEntity.historyList) {
      idList += '${item.carParkID!},';
    }

    // 3. write the strings into the file
    final file = await _localFile;
    file.writeAsString(idList);
  }

  static void addHistory({
    required CarPark carpark,
  }) {
    historyEntity.addHistory(carpark: carpark);
    updateFavouritesTxt();
  }

}
