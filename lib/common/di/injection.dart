import 'package:get_it/get_it.dart';
import 'package:gulim/common/di/injection.config.dart';
import 'package:injectable/injectable.dart';

final getIt = GetIt.instance;

@InjectableInit()
configureDependencies() async => getIt.init();
