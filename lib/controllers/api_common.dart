import 'package:http/http.dart';

abstract class APIRequest {
  Uri getRequestURL();
  Future doRequest();
}

class DateTimeRange {
  DateTime startAt;
  DateTime endAt;

  DateTimeRange(this.startAt, this.endAt);

  @override
  String toString() {
    return "start_at=${startAt.millisecondsSinceEpoch}&end_at=${endAt.millisecondsSinceEpoch}";
  }

  Map<String, String> toMap() {
    return {
      "start_at": startAt.millisecondsSinceEpoch.toString(),
      "end_at": endAt.millisecondsSinceEpoch.toString(),
    };
  }
}

Map<String, String> makeAccessTokenHeader(String accessToken) {
  return {"Authorization": "Bearer $accessToken"};
}

bool isResponseOK(Response response) {
  return response.statusCode == 200 || response.statusCode == 201;
}
