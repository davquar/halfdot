import 'package:flutter/material.dart';
import 'package:umami/controllers/storage.dart';
import 'package:umami/controllers/websites.dart';
import 'package:umami/models/api/website.dart';

class WebsitesPage extends StatefulWidget {
  const WebsitesPage({super.key});

  @override
  State<WebsitesPage> createState() => _WebsitesPageState();
}

class _WebsitesPageState extends State<WebsitesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Websites"),
      ),
      body: FutureBuilder<WebsitesResponse>(
        future: WebsitesController(
          Storage.instance.domain!,
          Storage.instance.accessToken!,
        ).doRequest(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: [
                ...snapshot.data!.websites.map(
                  (website) => ListTile(
                    title: Text(website.name),
                    subtitle: Text(website.domain),
                  ),
                )
              ],
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
