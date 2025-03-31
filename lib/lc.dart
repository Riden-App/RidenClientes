import 'package:get_it/get_it.dart';
import 'package:ride_usuario/data/repositories/auth_reposity.dart';
import 'package:ride_usuario/services/shared_preferences_service.dart';

final lc = GetIt.instance;

Future<void> initalizeDependencies() async {
  lc.registerLazySingleton(() => AuthReposity());
  lc.registerLazySingleton(() => PreferenciasUsuario());
}
