import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:umami/controllers/api_common.dart';
import 'package:umami/models/api/login.dart';

class LoginController implements APIRequest {
  LoginController(this.domain, this.loginRequest) {
    url = getRequestURL();
  }

  final String domain;
  final LoginRequest loginRequest;
  late Uri url;

  @override
  Uri getRequestURL() {
    return Uri.https(domain, 'api/auth/login');
  }

  @override
  Future<LoginResponse> doRequest() async {
    try {
      http.Response response = await http.post(
        url,
        body: loginRequest.toJSON(),
      );

      if (!isResponseOK(response)) {
        throw getAPIException(response.statusCode, 'failed to authenticate');
      }

      return LoginResponse.fromJSON(
        jsonDecode(
          utf8.decode(response.bodyBytes),
        ) as Map<String, dynamic>,
      );
    } on Exception catch (e) {
      return Future<LoginResponse>.error(e);
    }
  }
}
