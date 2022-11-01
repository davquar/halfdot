import 'dart:convert';

import 'package:umami/controllers/api_common.dart';
import 'package:umami/controllers/http_service.dart';
import 'package:umami/models/api/metrics.dart';

class MetricsController implements APIRequest {
  final String domain;
  final String accessToken;
  final String uuid;
  late Uri url;

  late MetricsRequest metricsRequest;

  MetricsController(this.domain, this.accessToken, this.uuid, this.metricsRequest) {
    url = getRequestURL();
  }

  @override
  Uri getRequestURL() {
    return Uri.https(
      domain,
      "api/websites/$uuid/metrics",
      metricsRequest.toMap(),
    );
  }

  @override
  Future<MetricsResponse> doRequest() async {
    var response = await HttpService.get(
      url,
      makeAccessTokenHeader(accessToken),
    );

    if (!isResponseOK(response)) {
      throw getAPIException(response.statusCode, "failed to get metrics");
    }

    return MetricsResponse.fromJSON(
      jsonDecode(
        utf8.decode(response.bodyBytes),
      ),
    );
  }
}
