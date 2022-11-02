import 'package:http/http.dart' as http;

class HttpService {
  factory HttpService() {
    return _instance;
  }

  HttpService._();

  static late http.Client _client;
  static int _ongoingCalls = 0;
  static final HttpService _instance = HttpService._();

  static get client => _client;
  static get ongoingCalls => _ongoingCalls;

  static newClient() {
    _client = http.Client();
  }

  static close() {
    _client.close();
  }

  static Future<http.Response> get(Uri url, Map<String, String> headers) async {
    if (_ongoingCalls == 0) {
      newClient();
    }
    _ongoingCalls++;
    return http
        .get(
          url,
          headers: headers,
        )
        .timeout(const Duration(seconds: 30))
        .whenComplete(_callCompleted);
  }

  static _callCompleted() {
    _ongoingCalls--;
    if (_ongoingCalls == 0) {
      _client.close();
    }
  }
}
