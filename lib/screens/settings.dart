import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:umami/controllers/storage.dart';
import 'package:umami/screens/login.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var storage = Storage.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.settingsTitle),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.person),
                title: Text(AppLocalizations.of(context)!.userProfile),
                subtitle: Text("${storage.username}\n@${storage.domain}"),
                trailing: OutlinedButton(
                  child: const Icon(Icons.logout),
                  onPressed: () => _logout(),
                ),
              ),
            ],
          ),
        ));
  }

  void _logout() {
    storage.clear();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => const LoginPage(),
        ),
        (route) => false);
  }
}
