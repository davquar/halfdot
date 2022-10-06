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
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:umami/models/ui/numbered_list_item.dart';
import 'package:umami/models/ui/progress_indicator_card.dart';

class StatsPage extends StatefulWidget {
  final Website website;

  const StatsPage({super.key, required this.website});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  api_common.DateTimeRange dateTimeRange = _getLast24Hours();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.website.name),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            margin: const EdgeInsets.only(
              left: 4,
              top: 8,
              right: 4,
              bottom: 4,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _makeDateTimeBox(isEnd: false),
                const Text("  —  "),
                _makeDateTimeBox(isEnd: true),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                FutureBuilder<StatsResponse>(
                  future: StatsController(
                    Storage.instance.domain!,
                    Storage.instance.accessToken!,
                    widget.website.id,
                    dateTimeRange,
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
                      return const ProgressIndicatorCard(cardTitle: "Summary");
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
                                      (e) => NumberedListItem(
                                        item: _prettyPrintDate(e.dateTime, discardTime: true),
                                        number: e.number,
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
                                      (e) => NumberedListItem(
                                        item: _prettyPrintDate(e.dateTime, discardTime: true),
                                        number: e.number,
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
                      return const ProgressIndicatorCard(cardTitle: "Sessions");
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
                          (e) => NumberedListItem(
                            item: e.object,
                            number: e.number,
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
          return ProgressIndicatorCard(cardTitle: cardTitle);
        }
      },
    );
  }

  Expanded _makeDateTimeBox({required bool isEnd}) {
    final Key key = isEnd ? const Key("rangeEnd") : const Key("rangeStart");
    final text = isEnd ? dateTimeRange.getPrettyEnd() : dateTimeRange.getPrettyStart();

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).focusColor,
          ),
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).dialogBackgroundColor,
        ),
        child: TextButton(
          style: const ButtonStyle(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: () => _showDateTimePicker(isEnd),
          child: Text(
            text,
            key: key,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  void _showDateTimePicker(bool isEnd) {
    late DateTime currentTime;
    if (isEnd) {
      if (dateTimeRange.endAt.isBefore(DateTime.now())) {
        currentTime = dateTimeRange.endAt;
      } else {
        currentTime = DateTime.now();
      }
    } else {
      if (dateTimeRange.startAt.isBefore(DateTime.now())) {
        currentTime = dateTimeRange.startAt;
      } else {
        currentTime = DateTime.now();
      }
    }

    DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      minTime: isEnd ? dateTimeRange.startAt : DateTime(2010, 01, 01),
      maxTime: isEnd ? DateTime.now() : dateTimeRange.endAt,
      currentTime: currentTime,
      locale: LocaleType.en,
      onConfirm: (date) {
        setState(() {
          if (isEnd) {
            dateTimeRange.endAt = date;
          } else {
            dateTimeRange.startAt = date;
          }
        });
      },
    );
  }

  static api_common.DateTimeRange _getLast24Hours() {
    return api_common.DateTimeRange(
      DateTime.now().subtract(
        const Duration(hours: 24),
      ),
      DateTime.now(),
    );
  }

  PageViewsRequest _makePageViewsRequest() {
    return PageViewsRequest(period: dateTimeRange);
  }

  MetricsRequest _makeMetricsRequest(MetricType type) {
    return MetricsRequest(dateTimeRange, type);
  }

  String _prettyPrintDate(DateTime date, {bool discardTime = false}) {
    var datePart = "${date.year}/${date.month}/${date.day}";
    if (discardTime) {
      return datePart;
    }
    return "$datePart ${date.hour}:${date.minute}";
  }
}
