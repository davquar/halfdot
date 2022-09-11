import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:umami/controllers/api_common.dart';
import 'package:umami/models/api/pageviews.dart';

class PageViewsController implements APIRequest {
  final String domain;
  final String accessToken;
  final int id;
  late Uri url;

  late PageViewsRequest pageViewsRequest;

  PageViewsController(this.domain, this.accessToken, this.id, this.pageViewsRequest) {
    url = getRequestURL();
  }

  @override
  Uri getRequestURL() {
    return Uri.https(
      domain,
      "api/website/$id/pageviews",
      pageViewsRequest.toMap(),
    );
  }

  @override
  Future<PageViewsResponse> doRequest() async {
    var response = await http.get(
      url,
      headers: makeAccessTokenHeader(accessToken),
    );

    if (!isResponseOK(response)) {
      throw Exception("Failed to get page views: ${response.statusCode}");
    }

    return PageViewsResponse.fromJSON(
      jsonDecode(
        utf8.decode(response.bodyBytes),
      ) as Map<String, dynamic>,
    );
  }
}
