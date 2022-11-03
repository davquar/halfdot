import 'package:umami/controllers/api_common.dart';
import 'package:umami/models/api/common.dart';

class PageViewsRequest {
  PageViewsRequest({
    required DateTimeInterval period,
    this.groupingUnit = GroupingUnit.day,
  }) {
    startAt = period.startAt.millisecondsSinceEpoch;
    endAt = period.endAt.millisecondsSinceEpoch;
  }

  late int startAt;
  late int endAt;
  late GroupingUnit groupingUnit;
  final String tz = 'Europe/Rome';

  Map<String, String> toMap() => <String, String>{
        'start_at': startAt.toString(),
        'end_at': endAt.toString(),
        'unit': groupingUnit.value,
        'tz': tz,
      };
}

class PageViewsResponse implements ApiModel {
  PageViewsResponse(this.pageViews, this.sessions);

  PageViewsResponse.fromJson(Map<String, dynamic> json) {
    if (json['pageviews'] != null) {
      for (final Map<String, dynamic> entry in json['pageviews']!) {
        pageViews.add(TimestampedEntry.fromJson(entry));
      }
    }
    if (json['sessions'] != null) {
      for (final Map<String, dynamic> entry in json['sessions']!) {
        sessions.add(TimestampedEntry.fromJson(entry));
      }
    }

    pageViews.sort((
      TimestampedEntry a,
      TimestampedEntry b,
    ) =>
        a.dateTime.difference(b.dateTime).inMilliseconds);
    sessions.sort((
      TimestampedEntry a,
      TimestampedEntry b,
    ) =>
        a.dateTime.difference(b.dateTime).inMilliseconds);
  }

  List<TimestampedEntry> pageViews = <TimestampedEntry>[];
  List<TimestampedEntry> sessions = <TimestampedEntry>[];
}
