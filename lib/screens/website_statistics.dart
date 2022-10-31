import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:umami/controllers/api_common.dart';
import 'package:umami/controllers/country_codes.dart';
import 'package:umami/controllers/metrics.dart';
import 'package:umami/controllers/pageviews.dart';
import 'package:umami/controllers/stats.dart';
import 'package:umami/controllers/storage.dart';
import 'package:umami/models/api/metrics.dart';
import 'package:umami/models/api/pageviews.dart';
import 'package:umami/models/api/stats.dart';
import 'package:umami/models/api/website.dart';
import 'package:umami/models/ui/datetime_box.dart';
import 'package:umami/models/ui/error_card.dart';
import 'package:umami/models/ui/numbered_list_item.dart';
import 'package:umami/models/ui/progress_indicator_card.dart';

class WebsiteStatisticsPage extends StatefulWidget {
  final Website website;

  const WebsiteStatisticsPage({super.key, required this.website});

  @override
  State<WebsiteStatisticsPage> createState() => _WebsiteStatisticsPageState();
}

class _WebsiteStatisticsPageState extends State<WebsiteStatisticsPage> {
  DateTimeInterval dateTimeRange = DateTimeInterval.getLast24Hours();
  late CountryCodes _countryCodes;

  final Key _metricsURLs = const Key("metricsURLs");
  final Key _metricsReferrers = const Key("metricsReferrers");
  final Key _metricsOS = const Key("metricsOS");
  final Key _metricsDevices = const Key("metricsDevices");
  final Key _metricsCountries = const Key("metricsCountries");

  @override
  Widget build(BuildContext context) {
    _countryCodes = CountryCodes(context);
    _countryCodes.load();

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
                DateTimeBox(
                  key: const Key("dateRange"),
                  text: dateTimeRange.getPretty(),
                  onPressed: () => _showDateRangePicker(),
                ),
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
                _makeCardTitle(AppLocalizations.of(context)!.summary),
                FutureBuilder<StatsResponse>(
                  future: StatsController(
                    Storage.instance.domain!,
                    Storage.instance.accessToken!,
                    widget.website.uuid,
                    dateTimeRange,
                  ).doRequest(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Card(
                        key: const Key("summary"),
                        elevation: 0,
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        snapshot.data!.pageViews.toString(),
                                        style: Theme.of(context).textTheme.titleLarge,
                                      ),
                                      Text(AppLocalizations.of(context)!.pageViews),
                                    ],
                                  ),
                                  Column(children: [
                                    Text(
                                      snapshot.data!.uniques.toString(),
                                      style: Theme.of(context).textTheme.titleLarge,
                                    ),
                                    Text(AppLocalizations.of(context)!.uniques),
                                  ]),
                                  Column(
                                    children: [
                                      Text(
                                        snapshot.data!.bounces.toString(),
                                        style: Theme.of(context).textTheme.titleLarge,
                                      ),
                                      Text(AppLocalizations.of(context)!.bounces),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        snapshot.data!.totalTime.toString(),
                                        style: Theme.of(context).textTheme.titleLarge,
                                      ),
                                      Text(AppLocalizations.of(context)!.totalTime),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return ErrorCard(
                        msg: (snapshot.error! as APIException).getFriendlyErrorString(
                          AppLocalizations.of(context)!,
                        ),
                      );
                    } else {
                      return const ProgressIndicatorCard();
                    }
                  },
                ),
                FutureBuilder<PageViewsResponse>(
                  future: PageViewsController(
                    Storage.instance.domain!,
                    Storage.instance.accessToken!,
                    widget.website.uuid,
                    _makePageViewsRequest(),
                  ).doRequest(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Row(
                        children: [
                          Expanded(
                            child: Card(
                              key: const Key("pageViews"),
                              elevation: 0,
                              color: Theme.of(context).colorScheme.surfaceVariant,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.pageViews,
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
                              elevation: 0,
                              color: Theme.of(context).colorScheme.surfaceVariant,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.sessions,
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
                      return ErrorCard(
                        msg: (snapshot.error! as APIException).getFriendlyErrorString(
                          AppLocalizations.of(context)!,
                        ),
                      );
                    } else {
                      return const ProgressIndicatorCard();
                    }
                  },
                ),
                _makeCardTitle(AppLocalizations.of(context)!.urls),
                _makeMetricsFutureBuilder(
                  type: MetricType.url,
                  cardKey: _metricsURLs,
                ),
                _makeCardTitle(AppLocalizations.of(context)!.referrers),
                _makeMetricsFutureBuilder(
                  type: MetricType.referrer,
                  cardKey: _metricsReferrers,
                ),
                _makeCardTitle(AppLocalizations.of(context)!.os),
                _makeMetricsFutureBuilder(
                  type: MetricType.os,
                  cardKey: _metricsOS,
                ),
                _makeCardTitle(AppLocalizations.of(context)!.devices),
                _makeMetricsFutureBuilder(
                  type: MetricType.device,
                  cardKey: _metricsDevices,
                ),
                _makeCardTitle(AppLocalizations.of(context)!.countries),
                _makeMetricsFutureBuilder(
                  type: MetricType.country,
                  cardKey: _metricsCountries,
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
    required Key cardKey,
  }) {
    return FutureBuilder<MetricsResponse>(
      future: MetricsController(
        Storage.instance.domain!,
        Storage.instance.accessToken!,
        widget.website.uuid,
        _makeMetricsRequest(type),
      ).doRequest(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Card(
            key: cardKey,
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  ...ListTile.divideTiles(
                    context: context,
                    tiles: [
                      ...snapshot.data!.metrics.map(
                        (e) => ListTile(
                          title: Text(
                            _processListTileData(e.object, cardKey),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          trailing: Text(e.number.toString()),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 1,
                          ),
                        ),
                      ),
                    ],
                  ).toList(),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return ErrorCard(
            msg: (snapshot.error! as APIException).getFriendlyErrorString(
              AppLocalizations.of(context)!,
            ),
          );
        } else {
          return const ProgressIndicatorCard();
        }
      },
    );
  }

  String _processListTileData(String data, Key key) {
    if (key == _metricsCountries) {
      return _countryCodes.getCountry(data);
    }
    return data;
  }

  Padding _makeCardTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, top: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }

  void _showDateRangePicker() {
    showDateRangePicker(
      context: context,
      firstDate: DateTime(2010, 01, 01),
      lastDate: dateTimeRange.endAt,
      currentDate: dateTimeRange.startAt,
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        dateTimeRange.startAt = value.start;
        dateTimeRange.endAt = value.end.add(const Duration(
          hours: 23,
          minutes: 59,
          seconds: 59,
        ));
      });
    });
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
