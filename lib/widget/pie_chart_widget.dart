import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../model/category.dart';
import '../provider/pie_chart_provider.dart';

class PieChartWidget extends StatelessWidget {
  final String title;
  final List<CategoryData> chartData;

  const PieChartWidget(
      {super.key, required this.title, required this.chartData});

  @override
  Widget build(BuildContext context) {
    final pieChartProvider = Provider.of<PieChartProvider>(context);
    final chartData = pieChartProvider.chartData;

    return SizedBox(
      height: 320,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 300,
            height: 300,
            child: SfCircularChart(margin: EdgeInsets.zero,
                series: <CircularSeries>[
              PieSeries<CategoryData, String>(

                dataSource: chartData,
                xValueMapper: (CategoryData data, _) => data.category,
                yValueMapper: (CategoryData data, _) => data.amount,
                dataLabelMapper: (datum, index) {
                  return "${datum.category}\n${datum.amount.toInt()}";
                },
                explode: false,
                dataLabelSettings: const DataLabelSettings(
                    isVisible: true, margin: EdgeInsets.all(0)),
              ),
            ]),
          ),
          Text(
            title,
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
