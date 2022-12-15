import 'package:halfdot/models/api/metrics.dart';

class Filter {
  Filter({
    this.url,
    this.referrer,
    this.browser,
    this.os,
    this.device,
    this.countryCode,
    this.event,
  });

  late String? url;
  late String? referrer;
  late String? browser;
  late String? os;
  late String? device;
  late String? countryCode;
  late String? event;

  void add(MetricType metricType, String value) {
    switch (metricType) {
      case MetricType.url:
        url = value;
        break;
      case MetricType.referrer:
        referrer = value;
        break;
      case MetricType.browser:
        browser = value;
        break;
      case MetricType.os:
        os = value;
        break;
      case MetricType.device:
        device = value;
        break;
      case MetricType.country:
        countryCode = value;
        break;
      case MetricType.event:
        event = value;
        break;
    }
  }

  void remove(MetricType metricType) {
    switch (metricType) {
      case MetricType.url:
        url = null;
        break;
      case MetricType.referrer:
        referrer = null;
        break;
      case MetricType.browser:
        browser = null;
        break;
      case MetricType.os:
        os = null;
        break;
      case MetricType.device:
        device = null;
        break;
      case MetricType.country:
        countryCode = null;
        break;
      case MetricType.event:
        event = null;
        break;
    }
  }

  bool isActive(MetricType metricType) {
    switch (metricType) {
      case MetricType.url:
        return isUrlActive();
      case MetricType.referrer:
        return isReferrerActive();
      case MetricType.browser:
        return isBrowserActive();
      case MetricType.os:
        return isOsActive();
      case MetricType.device:
        return isDeviceActive();
      case MetricType.country:
        return isCountryCodeActive();
      case MetricType.event:
        return isEventActive();
    }
  }

  bool isUrlActive() {
    return url != null;
  }

  bool isReferrerActive() {
    return referrer != null;
  }

  bool isBrowserActive() {
    return browser != null;
  }

  bool isOsActive() {
    return os != null;
  }

  bool isDeviceActive() {
    return device != null;
  }

  bool isCountryCodeActive() {
    return countryCode != null;
  }

  bool isEventActive() {
    return event != null;
  }

  Map<String, String> toMap() {
    Map<String, String> map = <String, String>{};

    if (isUrlActive()) map[MetricType.url.value] = url!;
    if (isReferrerActive()) map[MetricType.referrer.value] = referrer!;
    if (isBrowserActive()) map[MetricType.browser.value] = browser!;
    if (isDeviceActive()) map[MetricType.device.value] = device!;
    if (isOsActive()) map[MetricType.os.value] = os!;
    if (isCountryCodeActive()) map[MetricType.country.value] = countryCode!;
    if (isEventActive()) map[MetricType.event.value] = event!;

    return map;
  }
}
