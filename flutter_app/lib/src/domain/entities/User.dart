

import 'package:json_annotation/json_annotation.dart';
part 'User.g.dart';

@JsonSerializable()
class User {

  const User({
    this.email,
    this.name,
    this.password,
    this.token
  });

  final String? name;
  final String? email;
  final String? password;
  final String? token;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this); 

  static User createEmpty() {
    return User(
        name: '',
        email: '',
        password: 'password');
  }
  
}