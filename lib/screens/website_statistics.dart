import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:umami/controllers/api_common.dart';
import 'package:umami/controllers/country_codes.dart';
import 'package:umami/controllers/metrics.dart';
import 'package:umami/controllers/pageviews.dart';
import 'package:umami/controllers/stats.dart';
import 'package:umami/controllers/storage.dart';
import 'package:umami/models/api/filter.dart';
import 'package:umami/models/api/metrics.dart';
import 'package:umami/models/api/pageviews.dart';
import 'package:umami/models/api/stats.dart';
import 'package:umami/models/api/website.dart';
import 'package:umami/models/ui/datetime_box.dart';
import 'package:umami/models/ui/error_card.dart';
import 'package:umami/models/ui/line_plot_date_time.dart';
import 'package:umami/models/ui/progress_indicator_card.dart';

class WebsiteStatisticsPage extends StatefulWidget {
  const WebsiteStatisticsPage({required this.website, super.key});

  final Website website;

  @override
  State<WebsiteStatisticsPage> createState() => _WebsiteStatisticsPageState();
}

class _WebsiteStatisticsPageState extends State<WebsiteStatisticsPage> {
  DateTimeInterval dateTimeRange = DateTimeInterval.getLast7Days();
  late CountryCodes _countryCodes;
  final Filter _filter = Filter();

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
              children: <Widget>[
                DateTimeBox(
                  key: const Key('dateRange'),
                  text: dateTimeRange.getPretty(),
                  onPressed: _showDateRangePicker,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                _makeCardTitle(AppLocalizations.of(context)!.summary),
                FutureBuilder<StatsResponse>(
                  future: StatsController(
                    Storage.instance.domain!,
                    Storage.instance.accessToken!,
                    widget.website.uuid,
                    dateTimeRange,
                    _filter,
                  ).doRequest(),
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<StatsResponse> snapshot,
                  ) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: ProgressIndicatorCard());
                    }
                    if (snapshot.hasError) {
                      return ErrorCard(
                        msg: handleSnapshotError(context, snapshot.error),
                      );
                    }
                    if (snapshot.hasData) {
                      return Card(
                        key: const Key('summary'),
                        elevation: 0,
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Text(
                                        snapshot.data!.pageViews.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                      Text(AppLocalizations.of(context)!
                                          .pageViews),
                                    ],
                                  ),
                                  Column(children: <Widget>[
                                    Text(
                                      snapshot.data!.uniques.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                    Text(AppLocalizations.of(context)!.uniques),
                                  ]),
                                  Column(
                                    children: <Widget>[
                                      Text(
                                        snapshot.data!.bounces.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                      Text(AppLocalizations.of(context)!
                                          .bounces),
                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Text(
                                        snapshot.data!.totalTime.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                      Text(AppLocalizations.of(context)!
                                          .totalTime),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Container();
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
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<PageViewsResponse> snapshot,
                  ) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const ProgressIndicatorCard();
                    }
                    if (snapshot.hasError) {
                      return ErrorCard(
                        msg: handleSnapshotError(context, snapshot.error),
                      );
                    }
                    if (snapshot.hasData) {
                      if (snapshot.data!.pageViews.length <= 1) {
                        return const SizedBox();
                      }
                      return Column(
                        children: <Widget>[
                          _makePageViewsCardTitle(),
                          Card(
                            key: const Key('pageViews'),
                            elevation: 0,
                            color: Theme.of(context).colorScheme.surfaceVariant,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 16.0,
                                bottom: 16.0,
                                right: 16.0,
                              ),
                              child: LinePlotDateTime(
                                snapshot.data!.pageViews,
                                snapshot.data!.sessions,
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
                _makeCard(MetricType.url),
                _makeCard(MetricType.referrer),
                _makeCard(MetricType.os),
                _makeCard(MetricType.device),
                _makeCard(MetricType.country),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.only(left: 4, right: 4),
          child: Wrap(
            spacing: 4,
            runSpacing: 0,
            children: <Widget>[
              ..._filter.toMap().entries.map(
                    (MapEntry<String, String> e) => InputChip(
                      visualDensity: VisualDensity.compact,
                      label: Text('${e.key}: ${e.value}'),
                      labelStyle: TextStyle(
                        fontSize: Theme.of(context).textTheme.caption!.fontSize,
                      ),
                      labelPadding: const EdgeInsets.only(right: 2),
                      onDeleted: () {
                        setState(() {
                          MetricType metricType = MetricType.values
                              .firstWhere((MetricType m) => m.value == e.key);
                          _filter.remove(metricType);
                        });
                      },
                    ),
                  )
            ],
          ),
        ),
      ),
    );
  }

  FutureBuilder<MetricsResponse> _makeMetricsFutureBuilder(
    MetricType metricType,
  ) {
    return FutureBuilder<MetricsResponse>(
      future: MetricsController(
        Storage.instance.domain!,
        Storage.instance.accessToken!,
        widget.website.uuid,
        _makeMetricsRequest(metricType),
      ).doRequest(),
      builder: (BuildContext context, AsyncSnapshot<MetricsResponse> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: ProgressIndicatorCard());
        }
        if (snapshot.hasError) {
          return ErrorCard(
            msg: handleSnapshotError(context, snapshot.error),
          );
        }
        if (snapshot.hasData) {
          return Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: <Widget>[
                  ...ListTile.divideTiles(
                    context: context,
                    tiles: <Widget>[
                      ...snapshot.data!.metrics.map(
                        (Metric e) => ListTile(
                          title: Text(
                            _processListTileData(e.object, metricType),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          trailing: Text(e.number.toString()),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 1,
                          ),
                          onTap: () => setState(() {
                            _filter.add(metricType, e.object);
                          }),
                        ),
                      ),
                    ],
                  ).toList(),
                ],
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  String _processListTileData(String data, MetricType metricType) {
    if (metricType == MetricType.country) {
      return _countryCodes.getCountry(data);
    }
    return data;
  }

  Widget _makeCard(MetricType metricType) {
    String title = '';

    switch (metricType) {
      case MetricType.url:
        title = AppLocalizations.of(context)!.urls;
        break;
      case MetricType.referrer:
        title = AppLocalizations.of(context)!.referrers;
        break;
      case MetricType.browser:
        title = AppLocalizations.of(context)!.browsers;
        break;
      case MetricType.device:
        title = AppLocalizations.of(context)!.devices;
        break;
      case MetricType.os:
        title = AppLocalizations.of(context)!.os;
        break;
      case MetricType.country:
        title = AppLocalizations.of(context)!.countries;
        break;
      case MetricType.event:
        title = AppLocalizations.of(context)!.events;
        break;
    }

    return Visibility(
      visible: !_filter.isActive(metricType),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _makeCardTitle(title),
          _makeMetricsFutureBuilder(metricType),
        ],
      ),
    );
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

  Padding _makePageViewsCardTitle() {
    return Padding(
        key: const Key('pageViewsTitle'),
        padding: const EdgeInsets.only(left: 18, top: 8),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.circle,
              color: Theme.of(context).colorScheme.background,
              size: 10,
            ),
            const VerticalDivider(width: 5),
            Text(
              AppLocalizations.of(context)!.pageViews,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.headlineSmall!.fontSize,
              ),
            ),
            const VerticalDivider(width: 15),
            Icon(
              Icons.circle,
              color: Theme.of(context).colorScheme.primary,
              size: 10,
            ),
            const VerticalDivider(width: 5),
            Text(
              AppLocalizations.of(context)!.sessions,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.headlineSmall!.fontSize,
              ),
            ),
          ],
        ));
  }

  void _showDateRangePicker() {
    showDateRangePicker(
      context: context,
      firstDate: DateTime(2010, 01, 01),
      lastDate: DateTime.now(),
      currentDate: dateTimeRange.startAt,
    ).then((DateTimeRange? value) {
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
    return PageViewsRequest(
      period: dateTimeRange,
      filter: _filter,
    );
  }

  MetricsRequest _makeMetricsRequest(MetricType type) {
    return MetricsRequest(
      period: dateTimeRange,
      metricType: type,
      filter: _filter,
    );
  }
}
