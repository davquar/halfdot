import 'package:flutter/material.dart';
import 'package:umami/controllers/api_common.dart' as api_common;
import 'package:umami/controllers/metrics.dart';
import 'package:umami/controllers/pageviews.dart';
import 'package:umami/controllers/stats.dart';
import 'package:umami/controllers/storage.dart';
import 'package:umami/models/api/metrics.dart';
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
          _makeMetricsFutureBuilder(
            type: MetricType.url,
            cardKey: "metricsURLs",
            cardTitle: "URLs",
          ),
          _makeMetricsFutureBuilder(
            type: MetricType.referrer,
            cardKey: "metricsReferrers",
            cardTitle: "Referrers",
          ),
          _makeMetricsFutureBuilder(
            type: MetricType.os,
            cardKey: "metricsOS",
            cardTitle: "OS",
          ),
          _makeMetricsFutureBuilder(
            type: MetricType.device,
            cardKey: "metricsDevices",
            cardTitle: "Devices",
          ),
          _makeMetricsFutureBuilder(
            type: MetricType.country,
            cardKey: "metricsCountries",
            cardTitle: "Countries",
          ),
        ],
      ),
    );
  }

  FutureBuilder<MetricsResponse> _makeMetricsFutureBuilder({
    required MetricType type,
    required String cardKey,
    required String cardTitle,
  }) {
    return FutureBuilder<MetricsResponse>(
      future: MetricsController(
        Storage.instance.domain!,
        Storage.instance.accessToken!,
        widget.website.id,
        _makeMetricsRequest(type),
      ).doRequest(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Row(
            children: [
              Expanded(
                child: Card(
                  key: Key(cardKey),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          cardTitle,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        const Divider(
                          color: Colors.transparent,
                        ),
                        ...snapshot.data!.metrics.map(
                          (e) => Text(
                            "${e.object} | ${e.number}",
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
    );
  }

  api_common.DateTimeRange _getLast24Hours() {
    return api_common.DateTimeRange(
      DateTime.now().subtract(
        const Duration(hours: 24),
      ),
      DateTime.now(),
    );
  }

  PageViewsRequest _makePageViewsRequest() {
    return PageViewsRequest(period: _getLast24Hours());
  }

  MetricsRequest _makeMetricsRequest(MetricType type) {
    return MetricsRequest(_getLast24Hours(), type);
  }

  String _prettyPrintDate(DateTime date) {
    return "${date.year}-${date.month}-${date.day} ${date.hour}:${date.minute}";
  }
}
