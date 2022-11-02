import 'dart:convert';

import 'package:http/http.dart';
import 'package:umami/controllers/api_common.dart';
import 'package:umami/controllers/http_service.dart';
import 'package:umami/models/api/pageviews.dart';

class PageViewsController implements APIRequest {
  PageViewsController(this.domain, this.accessToken, this.uuid, this.pageViewsRequest) {
    url = getRequestURL();
  }

  final String domain;
  final String accessToken;
  final String uuid;
  late Uri url;

  late PageViewsRequest pageViewsRequest;

  @override
  Uri getRequestURL() {
    return Uri.https(
      domain,
      'api/websites/$uuid/pageviews',
      pageViewsRequest.toMap(),
    );
  }

  @override
  Future<PageViewsResponse> doRequest() async {
    Response response = await HttpService.get(
      url,
      makeAccessTokenHeader(accessToken),
    );

    if (!isResponseOK(response)) {
      throw getAPIException(response.statusCode, 'failed to get page views');
    }

    return PageViewsResponse.fromJSON(
      jsonDecode(
        utf8.decode(response.bodyBytes),
      ) as Map<String, dynamic>,
    );
  }
}
