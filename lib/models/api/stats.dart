import 'package:umami/models/api/common.dart';

class StatsResponse implements APIModel {
  StatsResponse(this.pageViews, this.uniques, this.bounces, this.totalTime);

  StatsResponse.fromJSON(Map<String, dynamic> json)
      : pageViews = json['pageviews']['value'],
        uniques = json['uniques']['value'],
        bounces = json['bounces']['value'],
        totalTime = json['totaltime']['value'];

  final int pageViews;
  final int uniques;
  final int bounces;
  final int totalTime;
}
