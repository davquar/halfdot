import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:halfdot/controllers/api_common.dart';

class LinePlotDateTime extends StatelessWidget {
  const LinePlotDateTime(this.pageViews, this.sessions, {Key? key})
      : super(key: key);

  final List<TimestampedEntry> pageViews;
  final List<TimestampedEntry> sessions;

  @override
  Widget build(BuildContext context) {
    if (pageViews.isEmpty || sessions.isEmpty) {
      return const SizedBox();
    }

    return AspectRatio(
      aspectRatio: 2,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(
            show: false,
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: <LineChartBarData>[
            LineChartBarData(
              spots: pageViews
                  .map(
                    (final TimestampedEntry point) => FlSpot(
                      point.dateTime.millisecondsSinceEpoch.toDouble(),
                      point.number.toDouble(),
                    ),
                  )
                  .toList(),
              color: Theme.of(context).colorScheme.primary,
              isCurved: true,
              dotData: const FlDotData(
                show: false,
              ),
            ),
            LineChartBarData(
              spots: sessions
                  .map(
                    (final TimestampedEntry point) => FlSpot(
                      point.dateTime.millisecondsSinceEpoch.toDouble(),
                      point.number.toDouble(),
                    ),
                  )
                  .toList(),
              color: Theme.of(context).colorScheme.inversePrimary,
              isCurved: true,
              dotData: const FlDotData(
                show: false,
              ),
            ),
          ],
          titlesData: FlTitlesData(
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(sideTitles: _makeBottomTitles(context)),
              leftTitles: AxisTitles(sideTitles: _makeLeftTitles(context))),
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Theme.of(context).cardColor,
              tooltipRoundedRadius: 15.0,
              showOnTopOfTheChartBoxArea: false,
              fitInsideHorizontally: true,
              tooltipPadding: const EdgeInsets.all(8.0),
              tooltipMargin: 0,
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map(
                  (LineBarSpot touchedSpot) {
                    return LineTooltipItem(
                      _makeTooltipText(
                        context: context,
                        barIndex: touchedSpot.barIndex,
                        spotIndex: touchedSpot.spotIndex,
                      ),
                      textAlign: TextAlign.end,
                      const TextStyle(),
                    );
                  },
                ).toList();
              },
            ),
          ),
        ),
      ),
    );
  }

  String _makeTooltipText({
    required BuildContext context,
    required int barIndex,
    required int spotIndex,
  }) {
    String date = '';
    String barName = '';
    String value = '';
    if (barIndex == 0) {
      date = DateFormat('yyyy/MM/dd\n\n').format(pageViews[spotIndex].dateTime);
      barName = AppLocalizations.of(context)!.pageViews;
      value = pageViews[spotIndex].number.toString();
    } else if (barIndex == 1) {
      barName = AppLocalizations.of(context)!.sessions;
      value = sessions[spotIndex].number.toString();
    }
    return '$date$barName: $value';
  }

  SideTitles _makeBottomTitles(BuildContext context) {
    return SideTitles(
      showTitles: true,
      getTitlesWidget: (double value, TitleMeta meta) {
        String text = DateFormat('d/MM').format(
          DateTime.fromMillisecondsSinceEpoch(value.toInt()),
        );

        if (meta.min == value || meta.max == value) {
          // fix repeated min/max label bug in fl_chart
          text = '';
        }

        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        );
      },
    );
  }

  SideTitles _makeLeftTitles(BuildContext context) {
    return SideTitles(
      showTitles: true,
      reservedSize: 50,
      getTitlesWidget: (double value, TitleMeta meta) {
        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Text(
            value.toInt().toString(),
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.right,
          ),
        );
      },
    );
  }
}
