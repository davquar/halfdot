import 'dart:convert';

import 'package:http/http.dart';
import 'package:halfdot/controllers/api_common.dart';
import 'package:halfdot/controllers/http_service.dart';
import 'package:halfdot/models/api/filter.dart';
import 'package:halfdot/models/api/stats.dart';

class StatsController implements ApiRequest {
  StatsController(
      this.domain, this.accessToken, this.uuid, this.period, this.filter) {
    url = getRequestUrl();
  }

  final String domain;
  final String accessToken;
  final String uuid;
  late Uri url;
  late Filter? filter;

  final DateTimeInterval period;

  @override
  Uri getRequestUrl() {
    Map<String, String> map = period.toMap();
    if (filter != null) map.addAll(filter!.toMap());

    return Uri.https(
      domain,
      'api/websites/$uuid/stats',
      map,
    );
  }

  @override
  Future<StatsResponse> doRequest() async {
    Response response = await HttpService.get(
      url,
      makeAccessTokenHeader(accessToken),
    );

    if (!isResponseOk(response)) {
      throw getApiException(response.statusCode, 'failed to get statistics');
    }

    return StatsResponse.fromJson(
      jsonDecode(
        utf8.decode(response.bodyBytes),
      ) as Map<String, dynamic>,
    );
  }
}
