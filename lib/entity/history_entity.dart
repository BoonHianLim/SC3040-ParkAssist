import 'dart:async';
import 'dart:collection';
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
class HistoryEntity {
  ///Get path name for the specified device and return it as a future
  static int MAX_HISTORY = 5;
  ListQueue<CarPark> historyList = ListQueue();

  void addHistory({
    required CarPark carpark,
  }) {
    //check if carpark is already in history, if yes, move it to the front, return
    if (historyList.contains(carpark)) {
      historyList.remove(carpark);
      historyList.addFirst(carpark);
      return;
    }

    // check if the length hits maximum, if yes, remove the last one,
    if (historyList.length == MAX_HISTORY) {
      historyList.removeLast();
    }
    // add the new carpark to the front
    historyList.addFirst(carpark);
  }

  void addHistoryList({
    required List<CarPark> carparkList,
  }) {
    historyList.addAll(carparkList);
  }

  void clearList() {
    historyList.clear();
  }
}

HistoryEntity historyEntity = HistoryEntity();
