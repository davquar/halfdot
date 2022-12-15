import 'package:halfdot/models/api/common.dart';

class LoginRequest {
  LoginRequest(this.username, this.password);
  final String username;
  final String password;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'username': username,
        'password': password,
      };
}

class LoginResponse implements ApiModel {
  LoginResponse(this.token);
  LoginResponse.fromJson(Map<String, dynamic> json) : token = json['token'];
  final String token;
}
