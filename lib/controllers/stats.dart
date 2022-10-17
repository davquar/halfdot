import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:umami/controllers/api_common.dart';
import 'package:umami/models/api/stats.dart';

class StatsController implements APIRequest {
  final String domain;
  final String accessToken;
  final int id;
  late Uri url;

  final DateTimeInterval period;

  StatsController(this.domain, this.accessToken, this.id, this.period) {
    url = getRequestURL();
  }

  @override
  Uri getRequestURL() {
    return Uri.https(
      domain,
      "api/website/$id/stats",
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
      throw getHTTPException(response.statusCode, "failed to get statistics");
    }

    return StatsResponse.fromJSON(
      jsonDecode(
        utf8.decode(response.bodyBytes),
      ) as Map<String, dynamic>,
    );
  }
}
