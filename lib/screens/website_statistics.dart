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
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
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
                  key: const Key("rangeStart"),
                  text: dateTimeRange.getPrettyStart(),
                  onPressed: () => _showDateTimePicker(false),
                ),
                const Text("  —  "),
                DateTimeBox(
                  key: const Key("rangeEnd"),
                  text: dateTimeRange.getPrettyEnd(),
                  onPressed: () => _showDateTimePicker(true),
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
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.summary,
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
                        cardTitle: AppLocalizations.of(context)!.summary,
                        msg: (snapshot.error! as APIException).getFriendlyErrorString(
                          AppLocalizations.of(context)!,
                        ),
                      );
                    } else {
                      return ProgressIndicatorCard(cardTitle: AppLocalizations.of(context)!.summary);
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
                        cardTitle: AppLocalizations.of(context)!.sessions,
                        msg: (snapshot.error! as APIException).getFriendlyErrorString(
                          AppLocalizations.of(context)!,
                        ),
                      );
                    } else {
                      return ProgressIndicatorCard(cardTitle: AppLocalizations.of(context)!.sessions);
                    }
                  },
                ),
                _makeMetricsFutureBuilder(
                  type: MetricType.url,
                  cardKey: "metricsURLs",
                  cardTitle: AppLocalizations.of(context)!.urls,
                ),
                _makeMetricsFutureBuilder(
                  type: MetricType.referrer,
                  cardKey: "metricsReferrers",
                  cardTitle: AppLocalizations.of(context)!.referrers,
                ),
                _makeMetricsFutureBuilder(
                  type: MetricType.os,
                  cardKey: "metricsOS",
                  cardTitle: AppLocalizations.of(context)!.os,
                ),
                _makeMetricsFutureBuilder(
                  type: MetricType.device,
                  cardKey: "metricsDevices",
                  cardTitle: AppLocalizations.of(context)!.devices,
                ),
                _makeMetricsFutureBuilder(
                  type: MetricType.country,
                  cardKey: "metricsCountries",
                  cardTitle: AppLocalizations.of(context)!.countries,
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
        widget.website.uuid,
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
                            number: e.number,
                            item: type == MetricType.country ? _countryCodes.getCountry(e.object) : e.object,
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
          return ErrorCard(
            cardTitle: cardTitle,
            msg: (snapshot.error! as APIException).getFriendlyErrorString(
              AppLocalizations.of(context)!,
            ),
          );
        } else {
          return ProgressIndicatorCard(cardTitle: cardTitle);
        }
      },
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
