import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:umami/controllers/api_common.dart';
import 'package:umami/models/api/stats.dart';

class StatsController implements APIRequest {
  final String domain;
  final String accessToken;
  final String uuid;
  late Uri url;

  final DateTimeInterval period;

  StatsController(this.domain, this.accessToken, this.uuid, this.period) {
    url = getRequestURL();
  }

  @override
  Uri getRequestURL() {
    return Uri.https(
      domain,
      "api/websites/$uuid/stats",
      period.toMap(),
    );
  }

  @override
  Future<StatsResponse> doRequest() async {
    var response = await http.get(
      url,
      headers: makeAccessTokenHeader(accessToken),
    );

    if (!isResponseOK(response)) {
      throw getAPIException(response.statusCode, "failed to get statistics");
    }

    return StatsResponse.fromJSON(
      jsonDecode(
        utf8.decode(response.bodyBytes),
      ) as Map<String, dynamic>,
    );
  }
}
