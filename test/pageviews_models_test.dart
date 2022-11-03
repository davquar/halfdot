import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:umami/models/api/pageviews.dart';

void main() {
  test('Test deserializing', () {
    String sampleResponse = '''
{
  "pageviews": [
      {"t": "2020-04-20 01:00:00", "y": 3},
      {"t": "2020-04-20 02:00:00", "y": 7}
  ],
  "sessions": [
      {"t": "2020-04-20 01:00:00", "y": 2},
      {"t": "2020-04-20 02:00:00", "y": 4}
    ]
}
''';

    dynamic json = jsonDecode(sampleResponse) as Map<String, dynamic>;
    PageViewsResponse resp = PageViewsResponse.fromJson(json);

    expect(resp.pageViews.length, 2);
    expect(resp.sessions.length, 2);
    expect(
      resp.pageViews.toString(),
      '[{t: 2020-04-20 01:00:00.000, y: 3}, {t: 2020-04-20 02:00:00.000, y: 7}]',
    );
  });
}
