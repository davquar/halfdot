import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:halfdot/controllers/storage.dart';
import 'package:halfdot/screens/login.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Storage storage = Storage.instance;

  static String _appVersion = '?';
  static String _build = '?';
  static const String _apiVersion = '2.0.2';
  static const String _repoUrl = 'https://github.com/davquar/halfdot';
  static const String _license = 'MIT';
  static const String _licenseUrl =
      'https://github.com/davquar/halfdot/blob/main/LICENSE';
  static const String _privacyUrl =
      'https://github.com/davquar/halfdot/blob/main/PRIVACY.md';

  @override
  Widget build(BuildContext context) {
    PackageInfo.fromPlatform().then((PackageInfo info) {
      _appVersion = info.version;
      _build = info.buildNumber;
    });

    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.settingsTitle),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  AppLocalizations.of(context)!.userSettings,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: Theme.of(context).colorScheme.primary),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: Text(AppLocalizations.of(context)!.userProfile),
                subtitle: Text('${storage.username}\n${storage.domain}'),
                trailing: OutlinedButton(
                  onPressed: _logout,
                  child: const Icon(Icons.logout),
                ),
              ),
              ListTile(
                title: Text(
                  AppLocalizations.of(context)!.about,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: Theme.of(context).colorScheme.primary),
                ),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.appVersion),
                subtitle: Text('$_appVersion (build $_build)'),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.apiVersion),
                subtitle: const Text(_apiVersion),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.license),
                subtitle: const Text(_license),
                onTap: () => launchUrlString(
                  _licenseUrl,
                  mode: LaunchMode.externalApplication,
                ),
                trailing: const Icon(Icons.link),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.sourceCode),
                subtitle: const Text(_repoUrl),
                onTap: () => launchUrlString(
                  _repoUrl,
                  mode: LaunchMode.externalApplication,
                ),
                trailing: const Icon(Icons.link),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.privacyPolicy),
                subtitle: const Text(_privacyUrl),
                onTap: () => launchUrlString(
                  _privacyUrl,
                  mode: LaunchMode.externalApplication,
                ),
                trailing: const Icon(Icons.link),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.licenses),
                onTap: () => showLicensePage(context: context),
              ),
            ],
          ),
        ));
  }

  void _logout() {
    storage.clear();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute<LoginPage>(
          builder: (BuildContext context) => const LoginPage(),
        ),
        (Route<dynamic> route) => false);
  }
}
