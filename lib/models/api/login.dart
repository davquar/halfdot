import 'package:umami/models/api/common.dart';

class LoginRequest {
  LoginRequest(this.username, this.password);
  final String username;
  final String password;

  Map<String, dynamic> toJSON() => <String, dynamic>{
        'username': username,
        'password': password,
      };
}

class LoginResponse implements APIModel {
  LoginResponse(this.token);
  LoginResponse.fromJSON(Map<String, dynamic> json) : token = json['token'];
  final String token;
}
