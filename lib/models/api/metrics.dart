import 'package:halfdot/controllers/api_common.dart';
import 'package:halfdot/models/api/common.dart';
import 'package:halfdot/models/api/filter.dart';

class MetricsRequest {
  MetricsRequest({
    required DateTimeInterval period,
    required this.metricType,
    this.filter,
  }) {
    startAt = period.startAt.millisecondsSinceEpoch;
    endAt = period.endAt.millisecondsSinceEpoch;
  }
  late int startAt;
  late int endAt;
  final MetricType metricType;
  late Filter? filter;

  Map<String, String> toMap() {
    Map<String, String> map = <String, String>{
      'startAt': startAt.toString(),
      'endAt': endAt.toString(),
      'type': metricType.value,
    };

    if (filter != null) map.addAll(filter!.toMap());
    return map;
  }
}

class MetricsResponse implements ApiModel {
  MetricsResponse(this.metrics);
  MetricsResponse.fromJson(List<dynamic> json) {
    for (final dynamic metric in json) {
      metrics.add(Metric.fromJson(metric));
    }
  }
  List<Metric> metrics = <Metric>[];
}

class Metric {
  Metric(this.object, this.number);
  Metric.fromJson(Map<String, dynamic> json)
      : object = valueOrNone(json['x']),
        number = valueOrNone(json['y']);
  static const String noneMetric = '(None)';
  final String object;
  final int number;

  static dynamic valueOrNone(dynamic value) {
    if (value == null) {
      return noneMetric;
    }
    if (value.toString().isEmpty) {
      return noneMetric;
    }
    return value!;
  }
}

enum MetricType {
  url('url'),
  referrer('referrer'),
  browser('browser'),
  os('os'),
  device('device'),
  country('country'),
  event('event');

  const MetricType(this.value);
  final String value;
}
