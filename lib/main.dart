import 'package:flutter/material.dart';
import 'package:umami/screens/websites.dart';
import 'controllers/storage.dart';
import 'controllers/login.dart';
import 'models/api/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Umami',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(title: 'Umami'),
    );
  }
}

class LoginPage extends StatefulWidget {
  final String title;

  const LoginPage({super.key, required this.title});

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
            )
            .then(
              (_) => _goToWebsites(),
            );
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
