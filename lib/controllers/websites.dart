import 'dart:convert';

import 'package:umami/controllers/api_common.dart';
import 'package:umami/controllers/http_service.dart';
import 'package:umami/models/api/website.dart';

class WebsitesController implements APIRequest {
  final String domain;
  final String accessToken;
  late Uri url;

  WebsitesController(this.domain, this.accessToken) {
    url = getRequestURL();
  }

  @override
  Uri getRequestURL() {
    return Uri.https(domain, "api/websites");
  }

  @override
  Future<WebsitesResponse> doRequest() async {
    var response = await HttpService.get(
      url,
      makeAccessTokenHeader(accessToken),
    );

    if (!isResponseOK(response)) {
      throw getAPIException(response.statusCode, "failed to get website data");
    }

    return WebsitesResponse.fromJSON(
      jsonDecode(
        utf8.decode(response.bodyBytes),
      ) as List<dynamic>,
    );
  }
}
