import 'package:halfdot/models/api/common.dart';

class StatsResponse implements ApiModel {
  StatsResponse(this.pageViews, this.visitors, this.bounces, this.totalTime);

  StatsResponse.fromJson(Map<String, dynamic> json)
      : pageViews = json['pageviews']['value'],
        visitors = json['visitors']['value'],
        bounces = json['bounces']['value'],
        totalTime = json['totaltime']['value'];

  final int pageViews;
  final int visitors;
  final int bounces;
  final int totalTime;
}
