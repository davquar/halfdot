import 'dart:convert';

import 'package:http/http.dart';
import 'package:umami/controllers/api_common.dart';
import 'package:umami/controllers/http_service.dart';
import 'package:umami/models/api/stats.dart';

class StatsController implements APIRequest {
  StatsController(this.domain, this.accessToken, this.uuid, this.period) {
    url = getRequestURL();
  }

  final String domain;
  final String accessToken;
  final String uuid;
  late Uri url;

  final DateTimeInterval period;

  @override
  Uri getRequestURL() {
    return Uri.https(
      domain,
      'api/websites/$uuid/stats',
      period.toMap(),
    );
  }

  @override
  Future<StatsResponse> doRequest() async {
    Response response = await HttpService.get(
      url,
      makeAccessTokenHeader(accessToken),
    );

    if (!isResponseOK(response)) {
      throw getAPIException(response.statusCode, 'failed to get statistics');
    }

    return StatsResponse.fromJSON(
      jsonDecode(
        utf8.decode(response.bodyBytes),
      ) as Map<String, dynamic>,
    );
  }
}
