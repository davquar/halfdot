import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  Storage._() {
    readUmamiCredentials();
  }

  static final Storage _instance = Storage._();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static Storage get instance {
    return _instance;
  }

  static const String _keyAccessToken = 'accessToken';
  static const String _keyDomain = 'domain';
  static const String _keyUsername = 'username';

  late String? _accessToken;
  late String? _domain;
  late String? _username;

  String? get accessToken => _accessToken;
  String? get domain => _domain;
  String? get username => _username;

  Future<String?> readAccessToken() async {
    return _storage.read(key: _keyAccessToken);
  }

  bool hasAccessToken() {
    return accessToken != null && accessToken != '';
  }

  Future<void> readUmamiCredentials() {
    return _storage.readAll().then((Map<String, String> map) {
      _domain = map[_keyDomain];
      _accessToken = map[_keyAccessToken];
      _username = map[_keyUsername];
    });
  }

  Future<void> writeUmamiCredentials(
    String domain,
    String accessToken,
    String username,
  ) {
    return _storage.write(key: _keyDomain, value: domain).then(
          (_) => _storage.write(key: _keyAccessToken, value: accessToken).then(
                (_) => _storage.write(key: _keyUsername, value: username).then(
                  (_) {
                    _domain = domain;
                    _accessToken = accessToken;
                    _username = username;
                  },
                ),
              ),
        );
  }

  Future<String?> readDomain() async {
    return _storage.read(key: _keyDomain);
  }

  Future<bool> hasDomain() async {
    String? domain = await readDomain();
    return !(domain == null || domain == '');
  }

  Future<String?> readUsername() async {
    return _storage.read(key: _keyUsername);
  }

  Future<void> clear() async {
    return _storage.deleteAll();
  }
}
