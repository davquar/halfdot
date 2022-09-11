import 'package:http/http.dart';

abstract class APIRequest {
  Uri getRequestURL();
  Future doRequest();
}

Map<String, String> makeAccessTokenHeader(String accessToken) {
  return {"Authorization": "Bearer $accessToken"};
}

bool isResponseOK(Response response) {
  return response.statusCode == 200 || response.statusCode == 201;
}
