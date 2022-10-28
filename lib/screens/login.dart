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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 50),
            SizedBox(
              height: 100,
              child: Image.asset("assets/app_icon.png"),
            ),
            const SizedBox(height: 10),
            Text("Umami", style: Theme.of(context).textTheme.headline6),
            Text(AppLocalizations.of(context)!.loginSubtitle),
            const SizedBox(height: 20),
            TextField(
              key: const Key("url"),
              controller: urlController,
              autocorrect: false,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.loginUrlLabel,
                hintText: AppLocalizations.of(context)!.loginUrlHint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              key: const Key("username"),
              controller: usernameController,
              autocorrect: false,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.usernameLabel,
                hintText: AppLocalizations.of(context)!.usernameHint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              key: const Key("password"),
              controller: passwordController,
              obscureText: true,
              autocorrect: false,
              enableSuggestions: false,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.passwordLabel,
                hintText: AppLocalizations.of(context)!.passwordHint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _doLogin(),
              icon: const Icon(Icons.login),
              label: Text(AppLocalizations.of(context)!.loginButton),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
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
