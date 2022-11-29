

import 'package:json_annotation/json_annotation.dart';
part 'User.g.dart';

@JsonSerializable()
class User {

  User({
    this.email,
    this.name,
    this.password,
    this.token,
    this.isFriend
  });

  String? name;
  String? email;
  String? password;
  String? token;
  bool? isFriend;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this); 

  static User createEmpty() {
    return User(
        name: '',
        email: '',
        password: 'password');
  }
  
}