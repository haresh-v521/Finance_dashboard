import 'package:flutter/material.dart';
import '../model/category.dart';

class PieChartProvider extends ChangeNotifier {
  List<CategoryPeriodAmountsModel> _data = [];

  List<CategoryData> setData(List<CategoryPeriodAmountsModel> data) {
    _data = data;
    return _calculateTotals();
  }

  List<CategoryData> _calculateTotals() {
    final totals = <String, double>{};
    for (var item in _data) {
      if (item.category?.name != null) {
        double netAmount = (item.creditAmount ?? 0) - (item.debitAmount ?? 0);
        netAmount = netAmount.abs();

        totals[item.category!.name!] =
            (totals[item.category!.name!] ?? 0) + netAmount;
      }
    }
    return totals.entries
        .map((entry) => CategoryData(entry.key, entry.value))
        .toList();
  }

  List<CategoryData> get chartData {
    return _calculateTotals();
  }
}
