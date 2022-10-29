import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';


@immutable
abstract class LoginPageState extends Equatable {
  LoginPageState([this.properties = const <dynamic>[]]) : super();

  final List properties;

  @override
  List<dynamic> get props => properties as List<dynamic>;
  
}

class LoginDone extends LoginPageState{}

class SignInState extends LoginPageState {
  final String? user;
  final String? password;
  final String? error;
  SignInState({this.user, this.password, this.error}) : super([user, password, error]);
  SignInState copyWith({String? user, String? password, String? error}) {
    return SignInState(
        user: user != null ? user : this.user,
        password: password != null ? password : this.password,
        error: error != null ? error : null);

  }
}

class Home extends LoginPageState {
  final String home;

  Home({this.home = "home"}) : super([home]);
}

class ErrorState extends LoginPageState{
  final String message;
  ErrorState({required this.message}) : super([message]);
}
