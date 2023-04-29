import 'package:halfdot/controllers/api_common.dart';
import 'package:halfdot/models/api/common.dart';
import 'package:halfdot/models/api/filter.dart';

class PageViewsRequest {
  PageViewsRequest({
    required DateTimeInterval period,
    this.filter,
    this.groupingUnit = GroupingUnit.day,
  }) {
    startAt = period.startAt.millisecondsSinceEpoch;
    endAt = period.endAt.millisecondsSinceEpoch;
  }

  late int startAt;
  late int endAt;
  late Filter? filter;
  late GroupingUnit groupingUnit;

  Map<String, String> toMap() {
    Map<String, String> map = <String, String>{
      'startAt': startAt.toString(),
      'endAt': endAt.toString(),
      'unit': groupingUnit.value,
      'timezone': 'UTC',
    };

    if (filter != null) map.addAll(filter!.toMap());
    return map;
  }
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
