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

  var isFormFilled = false;
  var isLoading = false;

  @override
  void initState() {
    super.initState();
    Storage.instance.readUmamiCredentials().then((_) {
      if (Storage.instance.hasAccessToken()) {
        _goToWebsites();
      }
    });

    urlController.addListener(_validateForm);
    usernameController.addListener(_validateForm);
    passwordController.addListener(_validateForm);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: AutofillGroup(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 50),
              SizedBox(
                height: 100,
                width: 100,
                child: isLoading
                    ? const CircularProgressIndicator(
                        backgroundColor: Colors.grey,
                        strokeWidth: 10,
                      )
                    : Image.asset(
                        "assets/app_icon.png",
                      ),
              ),
              const SizedBox(height: 10),
              Text("Umami", style: Theme.of(context).textTheme.headline6),
              Text(AppLocalizations.of(context)!.loginSubtitle),
              const SizedBox(height: 20),
              TextField(
                key: const Key("url"),
                controller: urlController,
                autocorrect: false,
                enabled: !isLoading,
                keyboardType: TextInputType.url,
                autofillHints: const [AutofillHints.url],
                onTap: () {
                  if (urlController.text.isEmpty) {
                    urlController.text = "https://";
                  }
                },
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.loginUrlLabel,
                  hintText: AppLocalizations.of(context)!.loginUrlHint,
                  errorText: !_isURLAccepted() ? AppLocalizations.of(context)!.loginUrlErrorLabel : null,
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
                enabled: !isLoading,
                keyboardType: TextInputType.visiblePassword,
                autofillHints: const [AutofillHints.username],
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
                enabled: !isLoading,
                keyboardType: TextInputType.visiblePassword,
                autofillHints: const [AutofillHints.password],
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
                onPressed: (isFormFilled && !isLoading) ? () => _doLogin() : null,
                icon: const Icon(Icons.login),
                label: Text(AppLocalizations.of(context)!.loginButton),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isURLAccepted() {
    var url = urlController.text;

    if (!url.startsWith("https") && !url.contains(":/")) {
      url = "https://$url";
    }
    if (!url.endsWith("/")) {
      url += "/";
    }

    var parsed = Uri.tryParse(url);
    if (parsed == null) {
      return false;
    }

    return parsed.isScheme("HTTPS") && parsed.hasAbsolutePath;
  }

  _validateForm() {
    setState(() {
      isFormFilled = _isURLAccepted() && usernameController.text.isNotEmpty && passwordController.text.isNotEmpty;
    });
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
    setState(() {
      isLoading = true;
    });

    var loginRequest = LoginRequest(
      usernameController.text,
      passwordController.text,
    );

    var loginController = LoginController(
      urlController.text.replaceFirst("https://", ""),
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
        setState(() {
          isLoading = false;
        });

        var loc = AppLocalizations.of(context)!;
        late String title;
        late String content;

        if (error is NotFoundException) {
          title = loc.connectionError;
          content = loc.errNotFoundWhileLogin;
        } else if (error is APIException) {
          title = loc.umamiError;
          content = error.getFriendlyErrorString(loc);
        } else {
          title = loc.connectionError;
          content = "${loc.errGenericHttp} [${error.toString()}]";
        }

        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, "OK"),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      },
    );
  }
}
