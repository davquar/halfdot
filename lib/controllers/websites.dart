import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:halfdot/controllers/api_common.dart';
import 'package:halfdot/controllers/http_service.dart';
import 'package:halfdot/models/api/website.dart';

class WebsitesController implements ApiRequest {
  WebsitesController(this.domain, this.accessToken) {
    url = getRequestUrl();
  }

  final String domain;
  final String accessToken;
  late Uri url;

  @override
  Uri getRequestUrl() {
    return Uri.https(domain, 'api/websites');
  }

  @override
  Future<WebsitesResponse> doRequest() async {
    Response response = await HttpService.get(
      url,
      makeAccessTokenHeader(accessToken),
    );

    if (!isResponseOk(response)) {
      throw getApiException(response.statusCode, 'failed to get website data');
    }

    return WebsitesResponse.fromJson(
      jsonDecode(
        utf8.decode(response.bodyBytes),
      ) as List<dynamic>,
    );
  }
}
