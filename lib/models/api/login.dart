class LoginRequest {
  final String username;
  final String password;

  LoginRequest(this.username, this.password);

  Map<String, dynamic> toJSON() => {
        "username": username,
        "password": password,
      };
}

class LoginResponse {
  final String token;

  LoginResponse(this.token);

  LoginResponse.fromJSON(Map<String, dynamic> json) : token = json["token"];
}
