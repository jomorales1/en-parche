// import 'package:dartz/dartz.dart';


import 'package:flutter_app/services_provider.dart';
import 'package:flutter_app/src/core/usecases.dart';
import 'package:flutter_app/src/domain/entities/User.dart';
import 'package:flutter_app/src/domain/repository/User_repository.dart';
import 'package:dartz/dartz.dart';

class LoginUseCase extends UseCase<User, LoginParams> {
  final UserRepository _userRepository = getIt();

  @override
  Future<Either<String, void>> call(LoginParams params) async {
    try {
      return Right(await _userRepository.login(params.email, params.password));
    } catch (e) {
      return Left(e.toString());
    }
  }
} 

class LoginParams {
  final String email;
  final String password;
  LoginParams(this.email, this.password);
}