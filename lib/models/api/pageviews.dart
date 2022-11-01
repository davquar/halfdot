import 'package:umami/controllers/api_common.dart';

class PageViewsRequest {
  late int startAt;
  late int endAt;
  late GroupingUnit groupingUnit;
  final String tz = "Europe/Rome";

  PageViewsRequest({required DateTimeInterval period, this.groupingUnit = GroupingUnit.day}) {
    startAt = period.startAt.millisecondsSinceEpoch;
    endAt = period.endAt.millisecondsSinceEpoch;
  }

  Map<String, String> toMap() => {
        "start_at": startAt.toString(),
        "end_at": endAt.toString(),
        "unit": groupingUnit.value,
        "tz": tz,
      };
}

class PageViewsResponse {
  List<TimestampedEntry> pageViews = [];
  List<TimestampedEntry> sessions = [];

  PageViewsResponse(this.pageViews, this.sessions);

  PageViewsResponse.fromJSON(Map<String, dynamic> json) {
    if (json["pageviews"] != null) {
      for (var entry in json["pageviews"]!) {
        pageViews.add(TimestampedEntry.fromJSON(entry));
      }
    }
    if (json["sessions"] != null) {
      for (var entry in json["sessions"]!) {
        sessions.add(TimestampedEntry.fromJSON(entry));
      }
    }

    pageViews.sort((a, b) => a.dateTime.difference(b.dateTime).inMilliseconds);
    sessions.sort((a, b) => a.dateTime.difference(b.dateTime).inMilliseconds);
  }
}
