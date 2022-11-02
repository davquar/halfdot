import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:umami/controllers/api_common.dart';
import 'package:umami/controllers/storage.dart';
import 'package:umami/controllers/websites.dart';
import 'package:umami/models/api/website.dart';
import 'package:umami/screens/settings.dart';
import 'package:umami/screens/website_statistics.dart';

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
        title: Text(AppLocalizations.of(context)!.websites),
        actions: <Widget>[
          IconButton(
            onPressed: _goToSettings,
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      body: FutureBuilder<WebsitesResponse>(
        future: WebsitesController(
          Storage.instance.domain!,
          Storage.instance.accessToken!,
        ).doRequest(),
        builder: (BuildContext context, dynamic snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                handleSnapshotError(context, snapshot.error),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            return ListView(
              children: <Widget>[
                ...snapshot.data!.websites.map(
                  (Website website) => ListTile(
                    title: Text(website.name),
                    subtitle: Text(website.domain),
                    onTap: () => _goToStats(website),
                  ),
                )
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  _goToStats(Website website) {
    Navigator.push(
      context,
      MaterialPageRoute<WebsiteStatisticsPage>(
        builder: (_) => WebsiteStatisticsPage(
          website: website,
        ),
      ),
    );
  }

  _goToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute<SettingsPage>(
        builder: (_) => const SettingsPage(),
      ),
    );
  }
}
