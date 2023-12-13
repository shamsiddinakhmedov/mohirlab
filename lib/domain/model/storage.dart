import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

@singleton
class Storage {
  final _hive = Hive.box('storage');
}
