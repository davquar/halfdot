import 'package:http/http.dart';

abstract class APIRequest {
  Uri getRequestURL();
  Future doRequest();
}

enum GroupingUnit {
  hour("hour"),
  day("day"),
  month("month"),
  year("year");

  final String value;
  const GroupingUnit(this.value);
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

class TimestampedEntry {
  final DateTime dateTime;
  final int number;

  TimestampedEntry(this.dateTime, this.number);

  TimestampedEntry.fromJSON(Map<String, dynamic> json)
      : dateTime = DateTime.parse(json["t"]),
        number = json["y"];

  toMap() {
    return {"t": dateTime.toString(), "y": number};
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

Map<String, String> makeAccessTokenHeader(String accessToken) {
  return {"Authorization": "Bearer $accessToken"};
}

bool isResponseOK(Response response) {
  return response.statusCode == 200 || response.statusCode == 201;
}
