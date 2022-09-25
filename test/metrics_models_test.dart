import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:umami/models/api/metrics.dart';

void main() {
  test("Test deserializing", () {
    const sampleResponse = '''
[
    {"x": "/", "y": 46},
    {"x": "/docs", "y": 17},
    {"x": "/download", "y": 14}
]
''';

    var json = jsonDecode(sampleResponse);
    var resp = MetricsResponse.fromJSON(json);

    expect(resp.metrics.length, 3);
    expect(resp.metrics[0].object, "/");
    expect(resp.metrics[0].number, 46);
    expect(resp.metrics[1].object, "/docs");
    expect(resp.metrics[1].number, 17);
    expect(resp.metrics[2].object, "/download");
    expect(resp.metrics[2].number, 14);
  });
}
