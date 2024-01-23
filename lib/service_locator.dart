import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_data_dashboard/core/router/router.dart';
import 'package:streaming_data_dashboard/core/services/api_service.dart';
import 'package:streaming_data_dashboard/features/home/bloc/home_bloc.dart';
import 'package:streaming_data_dashboard/features/login/bloc/login_bloc.dart';
import 'package:streaming_data_dashboard/features/login/repository/login_repository.dart';
import 'package:streaming_data_dashboard/features/settings/bloc/settings_bloc.dart';
import 'package:streaming_data_dashboard/features/units_edit/bloc/units_edit_bloc.dart';

GetIt sl = GetIt.instance;

void setup() {
  sl.registerSingletonAsync<SharedPreferences>(
      () async => await SharedPreferences.getInstance());
  sl.registerSingletonWithDependencies<ApiService>(() => ApiService(pref: sl()),
      dependsOn: [SharedPreferences]);
  sl.registerSingletonWithDependencies<AppRouter>(() => AppRouter(pref: sl()),
      dependsOn: [SharedPreferences]);

  //Blocs
  sl.registerFactory(() => HomeBloc());
  sl.registerFactory(() => SettingsBloc());
  sl.registerFactory(() => LoginBloc());
  sl.registerFactory(() => UnitsEditBloc());

  //Repositories
  sl.registerSingletonWithDependencies<LoginRepository>(
      () => LoginRepository(apiService: sl(), sharedPreferences: sl()),
      dependsOn: [ApiService, SharedPreferences]);
}
