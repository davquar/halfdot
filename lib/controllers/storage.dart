import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  static const _keyAccessToken = "accessToken";
  static const _keyDomain = "domain";

  late String? _accessToken;
  late String? _domain;

  static final Storage _instance = Storage._();
  final _storage = const FlutterSecureStorage();

  Storage._() {
    readUmamiCredentials();
  }

  static Storage get instance {
    return _instance;
  }

  String? get accessToken => _accessToken;
  String? get domain => _domain;

  Future<String?> readAccessToken() async {
    return await _storage.read(key: _keyAccessToken);
  }

  bool hasAccessToken() {
    return !(_isEmpty(accessToken));
  }

  Future<void> readUmamiCredentials() {
    return _storage.readAll().then((map) {
      _domain = map[_keyDomain];
      _accessToken = map[_keyAccessToken];
    });
  }

  Future<void> writeUmamiCredentials(String domain, String accessToken) {
    return _storage.write(key: _keyDomain, value: domain).then(
          (_) => _storage.write(key: _keyAccessToken, value: accessToken).then(
            (_) {
              _domain = domain;
              _accessToken = accessToken;
            },
          ),
        );
  }

  Future<String?> readDomain() async {
    return await _storage.read(key: _keyDomain);
  }

  Future<bool> hasDomain() async {
    var domain = await readDomain();
    return !(domain == null || domain == "");
  }

  static _isEmpty(value) {
    return value == null || value == "";
  }
}
