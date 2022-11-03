import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:umami/controllers/api_common.dart';
import 'package:umami/models/api/login.dart';

class LoginController implements ApiRequest {
  LoginController(this.domain, this.loginRequest) {
    url = getRequestUrl();
  }

  final String domain;
  final LoginRequest loginRequest;
  late Uri url;

  @override
  Uri getRequestUrl() {
    return Uri.https(domain, 'api/auth/login');
  }

  @override
  Future<LoginResponse> doRequest() async {
    try {
      http.Response response = await http.post(
        url,
        body: loginRequest.toJson(),
      );

      if (!isResponseOk(response)) {
        throw getApiException(response.statusCode, 'failed to authenticate');
      }

      return LoginResponse.fromJson(
        jsonDecode(
          utf8.decode(response.bodyBytes),
        ) as Map<String, dynamic>,
      );
    } on Exception catch (e) {
      return Future<LoginResponse>.error(e);
    }
  }
}
