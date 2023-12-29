import 'package:aai_chennai/objectbox.g.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ObjectBox {
  /// The Store of this app.
  late final Store store;
  
  ObjectBox._create(this.store) {
    // Add any additional setup code, e.g. build queries.
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    print(p.join(docsDir.path));
    final store = await openStore(macosApplicationGroup: "FGDTDLOBXDJ.cia", directory: p.join(docsDir.path, "aai"));
    return ObjectBox._create(store);
  }
}