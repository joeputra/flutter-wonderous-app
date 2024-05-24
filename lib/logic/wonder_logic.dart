import 'package:playground_1/common_libs.dart';
import 'package:playground_1/logic/data/wonder_data.dart';
import 'package:playground_1/logic/data/wonder_type.dart';

import 'data/wonder_data/greate_wall_data.dart';

class WondersLogic {
  List<WonderData> all = [];

  final int timelineStartYear = -3000;
  final int timelineEndYear = 2200;

  WonderData getData(WonderType value) {
    WonderData? result = all.firstWhereOrNull((w) => w.type == value);
    if (result == null) throw ('Could not find data for wonder type $value');
    return result;
  }

  void init() {
    all = [
      GreatWallData(),
      // PetraData(),
      // ColosseumData(),
      // ChichenItzaData(),
      // MachuPicchuData(),
      // TajMahalData(),
      // ChristRedeemerData(),
      // PyramidsGizaData(),
    ];
  }
}
