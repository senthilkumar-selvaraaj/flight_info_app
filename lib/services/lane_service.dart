import 'package:aai_chennai/main.dart';
import 'package:aai_chennai/models/lane.dart';
import 'package:aai_chennai/objectbox.g.dart';

class LaneService {
  
static List<Lane> getLanes(){
  return database.store.box<Lane>().getAll();
}

static bool isExist(String deviceId){

 final query =  database.store.box<Lane>().query(Lane_.deviceId.equals(deviceId)).build();
 final lanes = query.find();
 print(lanes);
 return lanes.isNotEmpty;
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