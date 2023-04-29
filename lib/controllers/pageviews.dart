import 'dart:convert';

import 'package:http/http.dart';
import 'package:halfdot/controllers/api_common.dart';
import 'package:halfdot/controllers/http_service.dart';
import 'package:halfdot/models/api/pageviews.dart';

class PageViewsController implements ApiRequest {
  PageViewsController(
    this.domain,
    this.accessToken,
    this.id,
    this.pageViewsRequest,
  ) {
    url = getRequestUrl();
  }

  final String domain;
  final String accessToken;
  final String id;
  late Uri url;

  late PageViewsRequest pageViewsRequest;

  @override
  Uri getRequestUrl() {
    return Uri.https(
      domain,
      'api/websites/$id/pageviews',
      pageViewsRequest.toMap(),
    );
  }

  @override
  Future<PageViewsResponse> doRequest() async {
    Response response = await HttpService.get(
      url,
      makeAccessTokenHeader(accessToken),
    );

    if (!isResponseOk(response)) {
      throw getApiException(response.statusCode, 'failed to get page views');
    }

    return PageViewsResponse.fromJson(
      jsonDecode(
        utf8.decode(response.bodyBytes),
      ) as Map<String, dynamic>,
    );
  }
}
