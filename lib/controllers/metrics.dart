import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:umami/controllers/api_common.dart';
import 'package:umami/models/api/metrics.dart';

class MetricsController implements APIRequest {
  final String domain;
  final String accessToken;
  final int id;
  late Uri url;

  late MetricsRequest metricsRequest;

  MetricsController(this.domain, this.accessToken, this.id, this.metricsRequest) {
    url = getRequestURL();
  }

  @override
  Uri getRequestURL() {
    return Uri.https(
      domain,
      "api/website/$id/metrics",
      metricsRequest.toMap(),
    );
  }

  @override
  Future<MetricsResponse> doRequest() async {
    var response = await http.get(
      url,
      headers: makeAccessTokenHeader(accessToken),
    );

    if (!isResponseOK(response)) {
      throw getHTTPException(response.statusCode, "failed to get metrics");
    }

    return MetricsResponse.fromJSON(
      jsonDecode(
        utf8.decode(response.bodyBytes),
      ),
    );
  }
}
