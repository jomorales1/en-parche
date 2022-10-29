


import 'package:equatable/equatable.dart';
import 'package:flutter_app/src/domain/use_cases/login_use_case.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LoginPageEvent extends Equatable{
  LoginPageEvent([this.properties = const <dynamic>[]]) : super();

  final List properties;

  LoginUseCase _loginUseCase = LoginUseCase();

  @override
  List<Object> get props => properties as List<Object>;
  
}

class SignInButtonPressed extends LoginPageEvent{}

class SignIn extends LoginPageEvent{
}

class ErrorOccurred extends LoginPageEvent {
  final String message;
  ErrorOccurred({required this.message}) : super([message]);
}