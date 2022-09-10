import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  static const keyAccessToken = "accessToken";

  static final Storage _instance = Storage._();
  final storage = const FlutterSecureStorage();
  Storage._();

  static Storage get instance {
    return _instance;
  }

  Future<String?> getAccessToken() async {
    return await storage.read(key: keyAccessToken);
  }

  Future<bool> hasAccessToken() async {
    var token = await getAccessToken();
    return !(token == null || token == "");
  }

  Future<void> setAccessToken(String token) {
    return storage.write(key: keyAccessToken, value: token);
  }
}
