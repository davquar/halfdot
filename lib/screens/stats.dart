import 'package:flutter/material.dart';
import 'package:umami/controllers/api_common.dart' as api_common;
import 'package:umami/controllers/pageviews.dart';
import 'package:umami/controllers/stats.dart';
import 'package:umami/controllers/storage.dart';
import 'package:umami/models/api/pageviews.dart';
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
          FutureBuilder<PageViewsResponse>(
            future: PageViewsController(
              Storage.instance.domain!,
              Storage.instance.accessToken!,
              widget.website.id,
              _makePageViewsRequest(),
            ).doRequest(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Row(
                  children: [
                    Expanded(
                      child: Card(
                        key: const Key("pageViews"),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "Page views",
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              const Divider(
                                color: Colors.transparent,
                              ),
                              ...snapshot.data!.pageViews.map(
                                (e) => Text(
                                  "${_prettyPrintDate(e.dateTime)} | ${e.number}",
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        key: const Key("sessions"),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Sessions",
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              const Divider(
                                color: Colors.transparent,
                              ),
                              ...snapshot.data!.sessions.map(
                                (e) => Text(
                                  "${_prettyPrintDate(e.dateTime)} | ${e.number}",
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
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

  PageViewsRequest _makePageViewsRequest() {
    return PageViewsRequest(
      period: api_common.DateTimeRange(
        DateTime.now().subtract(
          const Duration(hours: 24),
        ),
        DateTime.now(),
      ),
    );
  }

  String _prettyPrintDate(DateTime date) {
    return "${date.year}-${date.month}-${date.day} ${date.hour}:${date.minute}";
  }
}
