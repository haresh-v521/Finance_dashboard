import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../model/category.dart';
import '../translations/locale_keys.g.dart';

class ProfitAndLossChartWidget extends StatelessWidget {
  final List<PeriodData> data;

  const ProfitAndLossChartWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          SfCartesianChart(
            primaryXAxis: DateTimeAxis(
              dateFormat: DateFormat('yy/MM'),
              intervalType: DateTimeIntervalType.months,
              majorGridLines: const MajorGridLines(width: 0),
            ),
            primaryYAxis: NumericAxis(
              numberFormat: NumberFormat.compact(),
              majorGridLines: const MajorGridLines(width: 0),
            ),
            series: <CartesianSeries>[
              LineSeries<PeriodData, DateTime>(
                name: LocaleKeys.appIncome,
                color: const Color(0xFF0000FF),
                dataSource: data,
                dataLabelSettings: const DataLabelSettings(
                    isVisible: true, useSeriesColor: true),
                xValueMapper: (PeriodData periodData, _) => periodData.period,
                yValueMapper: (PeriodData periodData, _) => periodData.income,
              ),
              LineSeries<PeriodData, DateTime>(
                name: LocaleKeys.appCost,
                color: const Color(0xFFFF0000),
                dataSource: data,
                dataLabelSettings: const DataLabelSettings(
                    isVisible: true, useSeriesColor: true),
                xValueMapper: (PeriodData periodData, _) => periodData.period,
                yValueMapper: (PeriodData periodData, _) => periodData.cost,
              ),
              LineSeries<PeriodData, DateTime>(
                name: LocaleKeys.appExpense,
                color: const Color(0xFF800000),
                dataSource: data,
                dataLabelSettings: const DataLabelSettings(
                    isVisible: true, useSeriesColor: true),
                xValueMapper: (PeriodData periodData, _) => periodData.period,
                yValueMapper: (PeriodData periodData, _) => periodData.expense,
              ),
              LineSeries<PeriodData, DateTime>(
                  name: LocaleKeys.profit,
                  color: const Color(0xFF00FF00),
                  dataSource: data,
                  dataLabelSettings: const DataLabelSettings(
                      isVisible: true, useSeriesColor: true),
                  xValueMapper: (PeriodData periodData, _) => periodData.period,
                  yValueMapper: (PeriodData periodData, _) => periodData.profit
                  // Calculate profit
                  ),
            ],
            legend:
                const Legend(isVisible: true, position: LegendPosition.bottom),
          ),
          const Text(
            LocaleKeys.profitAndLoss,
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
