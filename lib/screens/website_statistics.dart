import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:halfdot/controllers/api_common.dart';
import 'package:halfdot/controllers/country_codes.dart';
import 'package:halfdot/controllers/metrics.dart';
import 'package:halfdot/controllers/pageviews.dart';
import 'package:halfdot/controllers/stats.dart';
import 'package:halfdot/controllers/storage.dart';
import 'package:halfdot/models/api/filter.dart';
import 'package:halfdot/models/api/metrics.dart';
import 'package:halfdot/models/api/pageviews.dart';
import 'package:halfdot/models/api/stats.dart';
import 'package:halfdot/models/api/website.dart';
import 'package:halfdot/models/ui/datetime_box.dart';
import 'package:halfdot/models/ui/error_card.dart';
import 'package:halfdot/models/ui/line_plot_date_time.dart';
import 'package:halfdot/models/ui/progress_indicator_card.dart';

class WebsiteStatisticsPage extends StatefulWidget {
  const WebsiteStatisticsPage({required this.website, super.key});

  final Website website;

  @override
  State<WebsiteStatisticsPage> createState() => _WebsiteStatisticsPageState();
}

class _WebsiteStatisticsPageState extends State<WebsiteStatisticsPage> {
  final String locale = Platform.localeName;
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
                  text:
                      '${dateTimeRange.getPretty(locale)} (${dateTimeRange.getNumDays()}d)',
                  onPressed: _showDateTimeRangeBottomSheet,
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
                    getCompatUmamiUrlOrNot(Storage.instance.domain!),
                    Storage.instance.accessToken!,
                    widget.website.id,
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
                    getCompatUmamiUrlOrNot(Storage.instance.domain!),
                    Storage.instance.accessToken!,
                    widget.website.id,
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
                      if (snapshot.data!.pageViews.length <= 1 ||
                          dateTimeRange.getNumDays() == 1) {
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
                _makeCard(MetricType.browser),
                _makeCard(MetricType.os),
                _makeCard(MetricType.device),
                _makeCard(MetricType.country),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Visibility(
        visible: _filter.isFiltering(),
        child: BottomAppBar(
          child: Wrap(
            spacing: 4,
            runSpacing: 0,
            children: <Widget>[
              ..._filter.toMap().entries.map(
                    (MapEntry<String, String> e) => InputChip(
                      visualDensity: VisualDensity.compact,
                      label: Text('${e.key}: ${e.value}'),
                      labelStyle: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.labelSmall!.fontSize,
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
        getCompatUmamiUrlOrNot(Storage.instance.domain!),
        Storage.instance.accessToken!,
        widget.website.id,
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
                    color: Theme.of(context).colorScheme.background,
                    tiles: <Widget>[
                      ...snapshot.data!.metrics.map(
                        (Metric e) => ListTile(
                          title: Text(
                            _processListTileData(e.object, metricType),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          trailing: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: <Widget>[
                              Text(e.number.toString()),
                              const Icon(Icons.chevron_right),
                            ],
                          ),
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
              color: Theme.of(context).colorScheme.primary,
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
              color: Theme.of(context).colorScheme.inversePrimary,
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
      firstDate: initialDateTime,
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

  void _showDateTimeRangeBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          children: <ListTile>[
            ListTile(
              leading: Text(
                AppLocalizations.of(context)!.today,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onTap: () => setState(() {
                DateTime now = DateTime.now();
                dateTimeRange.startAt =
                    DateTime(now.year, now.month, now.day, 0, 0);
                dateTimeRange.endAt =
                    DateTime(now.year, now.month, now.day, 23, 59);
                Navigator.pop(context);
              }),
            ),
            ListTile(
              leading: Text(
                AppLocalizations.of(context)!.last24h,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onTap: () => setState(() {
                DateTime now = DateTime.now();
                dateTimeRange.startAt = now.subtract(const Duration(hours: 24));
                dateTimeRange.endAt = now;
                Navigator.pop(context);
              }),
            ),
            ListTile(
              leading: Text(
                AppLocalizations.of(context)!.yesterday,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onTap: () => setState(() {
                DateTime now = DateTime.now();
                dateTimeRange.startAt =
                    DateTime(now.year, now.month, now.day - 1);
                dateTimeRange.endAt =
                    DateTime(now.year, now.month, now.day - 1, 23, 59);
                Navigator.pop(context);
              }),
            ),
            ListTile(
              leading: Text(
                AppLocalizations.of(context)!.thisWeek,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onTap: () => setState(() {
                DateTime now = DateTime.now();
                dateTimeRange.startAt =
                    now.subtract(Duration(days: now.weekday - 1));
                dateTimeRange.endAt = now;
                Navigator.pop(context);
              }),
            ),
            ListTile(
              leading: Text(
                AppLocalizations.of(context)!.last7d,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onTap: () => setState(() {
                DateTime now = DateTime.now();
                dateTimeRange.startAt = now.subtract(const Duration(days: 6));
                dateTimeRange.endAt = now;
                Navigator.pop(context);
              }),
            ),
            ListTile(
              leading: Text(
                AppLocalizations.of(context)!.lastMonth,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onTap: () => setState(() {
                DateTime now = DateTime.now();
                dateTimeRange.startAt = DateTime(now.year, now.month);
                dateTimeRange.endAt = now;
                Navigator.pop(context);
              }),
            ),
            ListTile(
              leading: Text(
                AppLocalizations.of(context)!.last30d,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onTap: () => setState(() {
                DateTime now = DateTime.now();
                dateTimeRange.startAt = now.subtract(const Duration(days: 29));
                dateTimeRange.endAt = now;
                Navigator.pop(context);
              }),
            ),
            ListTile(
              leading: Text(
                AppLocalizations.of(context)!.last90d,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onTap: () => setState(() {
                DateTime now = DateTime.now();
                dateTimeRange.startAt = now.subtract(const Duration(days: 89));
                dateTimeRange.endAt = now;
                Navigator.pop(context);
              }),
            ),
            ListTile(
              leading: Text(
                AppLocalizations.of(context)!.thisYear,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onTap: () => setState(() {
                DateTime now = DateTime.now();
                dateTimeRange.startAt = DateTime(now.year);
                dateTimeRange.endAt = now;
                Navigator.pop(context);
              }),
            ),
            ListTile(
              leading: Text(
                AppLocalizations.of(context)!.allTime,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onTap: () => setState(() {
                dateTimeRange.startAt = initialDateTime;
                dateTimeRange.endAt = DateTime.now();
                Navigator.pop(context);
              }),
            ),
            ListTile(
              leading: Text(
                AppLocalizations.of(context)!.customDateRange,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onTap: () => setState(() {
                Navigator.pop(context);
                _showDateRangePicker();
              }),
            ),
          ],
        );
      },
    );
  }
}
