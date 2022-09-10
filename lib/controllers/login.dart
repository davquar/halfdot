import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:umami/controllers/api_common.dart';
import 'package:umami/models/api/login.dart';

class LoginController implements APIRequest {
  final String domain;
  final LoginRequest loginRequest;
  late Uri url;

  LoginController(this.domain, this.loginRequest) {
    url = getRequestURL();
  }

  @override
  Uri getRequestURL() {
    return Uri.https(domain, "api/auth/login");
  }

  @override
  Future<LoginResponse> doRequest() async {
    try {
      var response = await http.post(
        url,
        body: loginRequest.toJSON(),
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to authenticate: ${response.statusCode}");
      }

      var loginResponse = LoginResponse.fromJSON(
        jsonDecode(
          utf8.decode(response.bodyBytes),
        ) as Map<String, dynamic>,
      );

      return loginResponse;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
