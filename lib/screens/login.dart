import 'package:flutter/material.dart';
import 'package:umami/controllers/login.dart';
import 'package:umami/controllers/storage.dart';
import 'package:umami/models/api/login.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            TextField(
              key: const Key("url"),
              controller: urlController,
              autocorrect: false,
              decoration: const InputDecoration(
                labelText: "URL (without https://)",
                hintText: "Enter the URL (without scheme) of your Umami instance.",
              ),
            ),
            TextField(
              key: const Key("username"),
              controller: usernameController,
              autocorrect: false,
              decoration: const InputDecoration(
                labelText: "Username",
                hintText: "Enter the username of your Umami profile.",
              ),
            ),
            TextField(
              key: const Key("password"),
              controller: passwordController,
              obscureText: true,
              autocorrect: false,
              enableSuggestions: false,
              decoration: const InputDecoration(
                labelText: "Password",
                hintText: "Enter the password of your Umami profile.",
              ),
            ),
            ElevatedButton(
              onPressed: () => _doLogin(),
              child: const Text("Login"),
            ),
          ],
        ),
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
        Storage.instance.setAccessToken(value.token).then((value) => Navigator.pop(context));
      },
    ).onError(
      (error, stackTrace) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
          ),
        );
      },
    );
  }
}
