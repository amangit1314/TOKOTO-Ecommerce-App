import 'package:get_it/get_it.dart';

import '../providers/providers.dart';
import '../resources/api_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => Api('products'));
  locator.registerLazySingleton(() => AuthProvider());
  locator.registerLazySingleton(() => UserProvider());
  locator.registerLazySingleton(() => OrderProvider());
  locator.registerLazySingleton(() => CartProvider());
  locator.registerLazySingleton(() => ProductProvider());
  locator.registerLazySingleton(() => CategoryProvider());
  locator.registerLazySingleton(() => ProfileProvider());
}
