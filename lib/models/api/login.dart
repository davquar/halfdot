import 'package:halfdot/models/api/common.dart';

class LoginRequest {
  LoginRequest(this.username, this.password, this.isManaged);
  final String username;
  final String password;
  final bool isManaged;

  Map<String, dynamic> toJson() {
    String userKey = isManaged ? 'email' : 'username';
    return <String, dynamic>{
      userKey: username,
      'password': password,
    };
  }
}

class LoginResponse implements ApiModel {
  LoginResponse(this.token);
  LoginResponse.fromJson(Map<String, dynamic> json) : token = json['token'];
  final String token;
}
