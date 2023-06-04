import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:halfdot/controllers/api_common.dart';
import 'package:halfdot/controllers/storage.dart';
import 'package:halfdot/controllers/websites.dart';
import 'package:halfdot/models/api/website.dart';
import 'package:halfdot/screens/settings.dart';
import 'package:halfdot/screens/website_statistics.dart';

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
          getCompatUmamiUrlOrNot(Storage.instance.domain!),
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
