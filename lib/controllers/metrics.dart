import 'dart:convert';

import 'package:http/http.dart';
import 'package:umami/controllers/api_common.dart';
import 'package:umami/controllers/http_service.dart';
import 'package:umami/models/api/metrics.dart';

class MetricsController implements ApiRequest {
  MetricsController(this.domain, this.accessToken, this.uuid, this.metricsRequest) {
    url = getRequestUrl();
  }

  final String domain;
  final String accessToken;
  final String uuid;
  late Uri url;

  late MetricsRequest metricsRequest;

  @override
  Uri getRequestUrl() {
    return Uri.https(
      domain,
      'api/websites/$uuid/metrics',
      metricsRequest.toMap(),
    );
  }

  @override
  Future<MetricsResponse> doRequest() async {
    Response response = await HttpService.get(
      url,
      makeAccessTokenHeader(accessToken),
    );

    if (!isResponseOk(response)) {
      throw getApiException(response.statusCode, 'failed to get metrics');
    }

    return MetricsResponse.fromJson(
      jsonDecode(
        utf8.decode(response.bodyBytes),
      ),
    );
  }
}
