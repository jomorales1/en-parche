

import 'package:flutter_app/src/domain/entities/User.dart';

abstract class UserRepository{
  Future<void> add(String? name, String? email);
  Future<void> signUp(String email, String password);
  Future<String> login(String email, String password);
}