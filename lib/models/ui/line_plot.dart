import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:umami/controllers/api_common.dart';

class LinePlotDateTime extends StatelessWidget {
  final List<TimestampedEntry> pageViews;
  final List<TimestampedEntry> sessions;

  const LinePlotDateTime(this.pageViews, this.sessions, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            verticalInterval: _xAxisInterval,
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: pageViews
                  .map(
                    (point) => FlSpot(
                      point.dateTime.millisecondsSinceEpoch.toDouble(),
                      point.number.toDouble(),
                    ),
                  )
                  .toList(),
              color: Theme.of(context).colorScheme.background,
              isCurved: true,
              dotData: FlDotData(
                show: false,
              ),
            ),
            LineChartBarData(
              spots: sessions
                  .map(
                    (point) => FlSpot(
                      point.dateTime.millisecondsSinceEpoch.toDouble(),
                      point.number.toDouble(),
                    ),
                  )
                  .toList(),
              color: Theme.of(context).colorScheme.primary,
              isCurved: true,
              dotData: FlDotData(
                show: false,
              ),
            ),
          ],
          titlesData: FlTitlesData(
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(sideTitles: _makeBottomTitles(context)),
              leftTitles: AxisTitles(sideTitles: _makeLeftTitles(context))),
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Theme.of(context).cardColor,
              tooltipRoundedRadius: 15.0,
              showOnTopOfTheChartBoxArea: true,
              fitInsideHorizontally: true,
              tooltipPadding: const EdgeInsets.all(8.0),
              tooltipMargin: 0,
              getTooltipItems: (touchedSpots) {
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
    String date = "";
    String barName = "";
    String value = "";
    if (barIndex == 0) {
      date = DateFormat("yyyy/MM/dd\n\n").format(pageViews[spotIndex].dateTime);
      barName = AppLocalizations.of(context)!.pageViews;
      value = pageViews[spotIndex].number.toString();
    } else if (barIndex == 1) {
      barName = AppLocalizations.of(context)!.sessions;
      value = sessions[spotIndex].number.toString();
    }
    return "$date$barName: $value";
  }

  SideTitles _makeBottomTitles(BuildContext context) {
    return SideTitles(
      showTitles: true,
      interval: _xAxisInterval,
      getTitlesWidget: (value, meta) {
        String text = DateFormat("d/MM").format(
          DateTime.fromMillisecondsSinceEpoch(value.toInt()),
        );

        if (meta.min == value || meta.max == value) {
          // fix repeated min/max label bug in fl_chart
          text = "";
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

  double get _xAxisInterval {
    int coeff = pageViews.length > 6 ? pageViews.length ~/ 6 : 1;
    return coeff * Duration.millisecondsPerDay.toDouble();
  }

  SideTitles _makeLeftTitles(BuildContext context) {
    return SideTitles(
      showTitles: true,
      reservedSize: 40,
      getTitlesWidget: (value, meta) {
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
