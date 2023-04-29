import 'dart:convert';

import 'package:http/http.dart';
import 'package:halfdot/controllers/api_common.dart';
import 'package:halfdot/controllers/http_service.dart';
import 'package:halfdot/models/api/metrics.dart';

class MetricsController implements ApiRequest {
  MetricsController(
    this.domain,
    this.accessToken,
    this.id,
    this.metricsRequest,
  ) {
    url = getRequestUrl();
  }

  final String domain;
  final String accessToken;
  final String id;
  late Uri url;

  late MetricsRequest metricsRequest;

  @override
  Uri getRequestUrl() {
    return Uri.https(
      domain,
      'api/websites/$id/metrics',
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
