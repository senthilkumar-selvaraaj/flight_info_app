import 'package:flight_info_app/main.dart';
import 'package:flight_info_app/models/lane.dart';

class LaneService {
  
static List<Lane> getLanes(){
  return database.store.box<Lane>().getAll();
}

static String getLaneCommand(){
  final lanes = getLanes();
  String command = "";
  lanes.forEach((element) { 
    command = "$command${element.deviceId ?? ''}\n";
  });
  print(command);
  return command;
}

}