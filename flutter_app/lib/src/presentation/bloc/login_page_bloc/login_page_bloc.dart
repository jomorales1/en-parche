import 'package:dartz/dartz.dart';
import 'package:flutter_app/pages/home.dart';
import 'package:flutter_app/services_provider.dart';
import 'package:flutter_app/src/domain/use_cases/login_use_case.dart';
import 'package:flutter_app/src/presentation/bloc/login_page_bloc/login_page_event.dart';
import 'package:flutter_app/src/presentation/bloc/login_page_bloc/login_page_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LoginBloc extends Bloc<LoginPageEvent, LoginPageState> {

  LoginUseCase loginUseCase = LoginUseCase();

  LoginBloc(): super(Home()){
    on<SignInButtonPressed>((event, emit) => {
      emit(SignInState())
    });
    on<SignIn>((event, emit) => {
        // loginUseCase();

    });
  }

}


class LoginPageBloc extends Bloc<LoginPageEvent, LoginPageState> {
  LoginUseCase loginUseCase = getIt();
  // SharedPreferences prefs = getIt(); 
  LoginPageBloc() : super(Home());


// mapping a state by a event
  @override
  Stream<LoginPageState> mapEventToState(LoginPageEvent event) async* {
    if(event is SignInButtonPressed){
      yield SignInState();
    }
    if(event is SignIn){
      SignInState signInState = state as SignInState; 
      Either<String, void> result = await loginUseCase(LoginParams(signInState.user!, signInState.password!));
      yield* result.fold((l) async* {
          signInState.copyWith(error: l);
      }, (r) async* {
          yield LoginDone();
      });
    }
  }

}