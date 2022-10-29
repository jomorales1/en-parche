import 'package:flutter/cupertino.dart';
import 'package:flutter_app/src/data/user/user_server_repository.dart';
import 'package:flutter_app/src/domain/repository/User_repository.dart';
import 'package:flutter_app/src/domain/use_cases/login_use_case.dart';
import 'package:flutter_app/src/presentation/bloc/login_page_bloc/login_page_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

void init(){
  loginService();
}

void loginService(){
  //bloc
    getIt.registerFactory(() => LoginPageBloc());

    // repositories
    getIt.registerLazySingleton<UserRepository>(() => UserServerRepository());

    //useCases
    getIt.registerSingleton(LoginUseCase());

    // shared preferences
  getIt.registerSingletonAsync<SharedPreferences>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    return await SharedPreferences.getInstance();
  });
}