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

class DateTimeInterval {
  DateTime startAt;
  DateTime endAt;

  DateTimeInterval(this.startAt, this.endAt);

  @override
  String toString() {
    return "start_at=${startAt.millisecondsSinceEpoch}&end_at=${endAt.millisecondsSinceEpoch}";
  }

  String getPrettyStart() {
    return "${startAt.day}/${startAt.month}/${startAt.year} ${startAt.hour}:${startAt.second}";
  }

  String getPrettyEnd() {
    return "${endAt.day}/${endAt.month}/${endAt.year} ${endAt.hour}:${endAt.second}";
  }

  Map<String, String> toMap() {
    return {
      "start_at": startAt.millisecondsSinceEpoch.toString(),
      "end_at": endAt.millisecondsSinceEpoch.toString(),
    };
  }

  static DateTimeInterval getLast24Hours() {
    return DateTimeInterval(
      DateTime.now().subtract(
        const Duration(hours: 24),
      ),
      DateTime.now(),
    );
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
