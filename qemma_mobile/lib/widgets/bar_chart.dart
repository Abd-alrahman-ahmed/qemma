import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:qemma_mobile/helpers/app_locales.dart';
import 'package:qemma_mobile/models/chart_aggregator_enum.dart';
import 'package:qemma_mobile/models/chart_model.dart';
import 'package:qemma_mobile/widgets/empty_state.dart';

class BarChartWidget extends StatelessWidget {
  const BarChartWidget({
    Key? key,
    required this.points,
    required this.aggregator,
    required this.onChanged,
  }) : super(key: key);
  final List<ChartPoint> points;
  final void Function(int?) onChanged;
  final ChartAggregator aggregator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            Locales.t('student.details.charts'),
            //'رسم بياني بالدرجات',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          DropdownButton<int>(
            value: aggregator.index,
            isExpanded: true,
            items: Locales.chartGroupingOptions()
                .map(
                  (e) => DropdownMenuItem<int>(
                    value: e.id,
                    child: Text(e.value),
                  ),
                )
                .toList(),
            onChanged: onChanged,
          ),
          const SizedBox(
            height: 38,
          ),
          if (points.isNotEmpty)
            AspectRatio(
              aspectRatio: 1,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: BarChart(
                        barData(points),
                        swapAnimationDuration:
                            const Duration(milliseconds: 250),
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            const EmptyState(),
        ],
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: const Color.fromARGB(255, 212, 237, 218),
          width: 22,
          borderSide: const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(show: false),
        ),
      ],
    );
  }

  List<BarChartGroupData> createGroups(List<ChartPoint> points) =>
      points.map((p) => makeGroupData(p.id, p.value)).toList();

  BarChartData barData(List<ChartPoint> points) {
    return BarChartData(
      minY: 0,
      maxY: 100,
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay = points.firstWhere((p) => p.id == group.x).key;
              return BarTooltipItem(
                '$weekDay\n',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: (rod.toY).toString(),
                    style: const TextStyle(
                      color: Colors.yellow,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }),
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (v, m) => getTitles(v, m, points),
            reservedSize: 38,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            interval: 10,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: createGroups(points),
      gridData: FlGridData(show: true),
    );
  }

  Widget getTitles(double value, TitleMeta meta, List<ChartPoint> points) =>
      SideTitleWidget(
        axisSide: meta.axisSide,
        space: 16,
        child: Text(
          points.firstWhere((p) => p.id == value.toInt()).key,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      );
}
