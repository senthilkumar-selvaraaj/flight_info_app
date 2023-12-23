import 'package:flight_info_app/main.dart';
import 'package:flight_info_app/models/lane.dart';

class LaneService {
  
static List<Lane> getLanes(){
  return database.store.box<Lane>().getAll();
}

static List<String> getLaneIds(){
  final lanes =  database.store.box<Lane>().getAll();
  return lanes.map((e) => e.deviceId ?? '').toList();
}


static String getLaneCommand(){
  // final lanes = getLanes();
  String command = "";
  allLanes.forEach((element) { 
    command = "$command${element.deviceId ?? ''}\n";
  });
  print(command);
  return command;
}

}