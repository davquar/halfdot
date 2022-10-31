import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:umami/controllers/api_common.dart';

class LinePlotDateTime extends StatelessWidget {
  final List<TimestampedEntry> points;

  const LinePlotDateTime(this.points, {Key? key}) : super(key: key);

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
              spots: points
                  .map(
                    (point) => FlSpot(
                      point.dateTime.millisecondsSinceEpoch.toDouble(),
                      point.number.toDouble(),
                    ),
                  )
                  .toList(),
              color: Theme.of(context).primaryColor,
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
        ),
      ),
    );
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
    int coeff = points.length > 6 ? points.length ~/ 6 : 1;
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
