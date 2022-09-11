import 'package:flutter/material.dart';
import 'package:umami/controllers/stats.dart';
import 'package:umami/controllers/storage.dart';
import 'package:umami/models/api/stats.dart';
import 'package:umami/models/api/website.dart';

class StatsPage extends StatefulWidget {
  final Website website;

  const StatsPage({super.key, required this.website});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.website.name),
      ),
      body: ListView(
        children: [
          FutureBuilder<StatsResponse>(
            future: StatsController(
              Storage.instance.domain!,
              Storage.instance.accessToken!,
              widget.website.id,
            ).doRequest(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Card(
                  key: const Key("summary"),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Summary",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        const Divider(
                          color: Colors.transparent,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  snapshot.data!.pageViews.toString(),
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const Text("Page views"),
                              ],
                            ),
                            Column(children: [
                              Text(
                                snapshot.data!.uniques.toString(),
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const Text("Uniques"),
                            ]),
                            Column(
                              children: [
                                Text(
                                  snapshot.data!.bounces.toString(),
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const Text("Bounces"),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  snapshot.data!.totalTime.toString(),
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const Text("Total time"),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              } else {
                return const Card(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
