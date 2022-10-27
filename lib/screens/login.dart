import 'package:flutter/material.dart';
import 'package:umami/controllers/api_common.dart';
import 'package:umami/controllers/login.dart';
import 'package:umami/controllers/storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:umami/models/api/login.dart';
import 'package:umami/screens/websites.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var urlController = TextEditingController();
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Storage.instance.readUmamiCredentials().then((_) {
      if (Storage.instance.hasAccessToken()) {
        _goToWebsites();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.loginScreenTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            TextField(
              key: const Key("url"),
              controller: urlController,
              autocorrect: false,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.loginUrlLabel,
                hintText: AppLocalizations.of(context)!.loginUrlHint,
              ),
            ),
            TextField(
              key: const Key("username"),
              controller: usernameController,
              autocorrect: false,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.usernameLabel,
                hintText: AppLocalizations.of(context)!.usernameHint,
              ),
            ),
            TextField(
              key: const Key("password"),
              controller: passwordController,
              obscureText: true,
              autocorrect: false,
              enableSuggestions: false,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.passwordLabel,
                hintText: AppLocalizations.of(context)!.passwordHint,
              ),
            ),
            ElevatedButton(
              onPressed: () => _doLogin(),
              child: Text(AppLocalizations.of(context)!.loginButton),
            ),
          ],
        ),
      ),
    );
  }

  _goToWebsites() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: ((_) => const WebsitesPage()),
      ),
    );
  }

  _doLogin() {
    var loginRequest = LoginRequest(
      usernameController.text,
      passwordController.text,
    );
    var loginController = LoginController(
      urlController.text,
      loginRequest,
    );

    loginController.doRequest().then(
      (value) {
        Storage.instance
            .writeUmamiCredentials(
              loginController.domain,
              value.token,
              loginRequest.username,
            )
            .then(
              (_) => _goToWebsites(),
            );
      },
    ).onError(
      (error, _) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text((error as APIException).getFriendlyErrorString(
              AppLocalizations.of(context)!,
            )),
          ),
        );
      },
    );
  }
}
