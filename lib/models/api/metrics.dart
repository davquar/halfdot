import 'package:umami/controllers/api_common.dart';
import 'package:umami/models/api/common.dart';

class MetricsRequest {
  MetricsRequest(DateTimeInterval period, this.type) {
    startAt = period.startAt.millisecondsSinceEpoch;
    endAt = period.endAt.millisecondsSinceEpoch;
  }
  late int startAt;
  late int endAt;
  final MetricType type;

  Map<String, String> toMap() => <String, String>{
        'start_at': startAt.toString(),
        'end_at': endAt.toString(),
        'type': type.value,
      };
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
