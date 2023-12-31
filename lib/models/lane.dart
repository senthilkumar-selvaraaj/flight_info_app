
import 'package:objectbox/objectbox.dart';

@Entity()
class Lane {
  @Id()
  int id = 0;
  String? name;
  String? deviceId;
  String? terminal;
}

