import 'package:umami/controllers/api_common.dart';

class MetricsRequest {
  late int startAt;
  late int endAt;
  final MetricType type;

  MetricsRequest(DateTimeRange period, this.type) {
    startAt = period.startAt.millisecondsSinceEpoch;
    endAt = period.endAt.millisecondsSinceEpoch;
  }

  Map<String, String> toMap() => {
        "start_at": startAt.toString(),
        "end_at": endAt.toString(),
        "type": type.value,
      };
}

class MetricsResponse {
  List<Metric> metrics = [];

  MetricsResponse(this.metrics);

  MetricsResponse.fromJSON(List<dynamic> json) {
    for (var metric in json) {
      metrics.add(Metric.fromJSON(metric));
    }
  }
}

class Metric {
  static const noneMetric = "(None)";
  final String object;
  final int number;

  Metric(this.object, this.number);

  Metric.fromJSON(Map<String, dynamic> json)
      : object = valueOrNone(json["x"]),
        number = valueOrNone(json["y"]);

  static dynamic valueOrNone(value) {
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
  url("url"),
  referrer("referrer"),
  browser("browser"),
  os("os"),
  device("device"),
  country("country"),
  event("event");

  final String value;
  const MetricType(this.value);
}
