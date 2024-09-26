import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../model/category.dart';
import '../model/data.dart';
import '../repogistory/chart_data_repo.dart';
import '../translations/locale_keys.g.dart';

class ChartProvider extends ChangeNotifier {
  Data? _data;
  bool _isLoading = false;
  String? _error;
  int _selectedValue = 1;
  DateTime? _startDate;
  DateTime? _endDate;
  Data? get data => _data;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get selectedValue => _selectedValue;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  ChartDataRepo chartDataRepo = ChartDataRepo();
  void selectValue(int value, {DateTime? startDate, DateTime? endDate}) {
    _selectedValue = value;
    _startDate = startDate;
    _endDate = endDate;

    DateTime now = DateTime.now();
    switch (value) {
      case 1:
        _startDate = DateTime(now.year, now.month, 1);
        _endDate = DateTime(now.year, now.month, now.day);
        break;
      case 2:
        _startDate = DateTime(now.year, now.month - 1, now.day);
        _endDate = DateTime(now.year, now.month, now.day);
        break;
      case 3:
        _startDate = DateTime(now.year, now.month - 2, now.day);
        _endDate = DateTime(now.year, now.month, now.day);
        break;
      case 6:
        _startDate = DateTime(now.year, now.month - 5, now.day);
        _endDate = DateTime(now.year, now.month, now.day);
        break;
      case 9:
        _startDate = DateTime(now.year, now.month - 8, now.day);
        _endDate = DateTime(now.year, now.month, now.day);
        break;
      case 12:
        _startDate = DateTime(now.year, now.month - 11, now.day);
        _endDate = DateTime(now.year, now.month, now.day);
        break;
      default:
        break;
    }
    notifyListeners();
    fetchData(firstDate: startDate, secondDate: endDate);
  }

  Future<void> fetchData({DateTime? firstDate, DateTime? secondDate}) async {
    _isLoading = true;
    notifyListeners();
    try {
      List<CategoryPeriodAmountsModel> categoryPeriodAmounts =
          await chartDataRepo.fetchChartData(_selectedValue);
      DateTime now = DateTime.now();
      DateTime startDate =
          firstDate ?? DateTime(now.year, now.month - _selectedValue + 1);
      DateTime endDate = secondDate ?? now.add(const Duration(days: 1));
      List<CategoryPeriodAmountsModel> filteredCategoryPeriodAmounts =
          categoryPeriodAmounts
              .where((cpa) =>
                  cpa.periodDate!
                      .isAfter(startDate.subtract(const Duration(days: 1))) &&
                  cpa.periodDate!
                      .isBefore(endDate.add(const Duration(days: 1))) &&
                  cpa.periodDate!.isBefore(endDate))
              .toList();

      List<List<CategoryPeriodAmountsModel>> filteredData = [];
      filteredData.add(filterByTypes(filteredCategoryPeriodAmounts,
          [LocaleKeys.appIncomeCap, LocaleKeys.appOtherIncomeCap]));
      filteredData.add(filterByTypes(filteredCategoryPeriodAmounts,
          [LocaleKeys.appCostCap, LocaleKeys.appLiabilityCap]));
      filteredData.add(filterByTypes(filteredCategoryPeriodAmounts, [
        LocaleKeys.appExpenseCap,
        LocaleKeys.appAssetCap,
        LocaleKeys.appEquityCap
      ]));

      _data = Data(
          pieData: filteredData,
          lineData: filteredCategoryPeriodAmounts,
          selectedValue: _selectedValue);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<CategoryPeriodAmountsModel> filterByTypes(
      List<CategoryPeriodAmountsModel> data, List<String> types) {
    return data
        .where((cpa) => types.contains(cpa.category!.type!.toUpperCase()))
        .toList();
  }

  List<PeriodData> getProfitAndLossData(List<CategoryPeriodAmountsModel> data) {
    Map<DateTime, Map<String, double>> periodData = {};
    for (var cpa in data) {
      DateTime period = DateTime(cpa.periodDate!.year, cpa.periodDate!.month);
      periodData.putIfAbsent(
          period,
          () => {
                LocaleKeys.appIncome: 0,
                LocaleKeys.appCost: 0,
                LocaleKeys.appExpense: 0
              });
      switch (cpa.category!.type!.toUpperCase()) {
        case LocaleKeys.appIncomeCap:
        case LocaleKeys.appOtherIncomeCap:
          periodData[period]![LocaleKeys.appIncome] =
              (periodData[period]![LocaleKeys.appIncome] ?? 0) +
                  (cpa.creditAmount ?? 0);
          break;
        case LocaleKeys.appCostCap:
        case LocaleKeys.appLiabilityCap:
          periodData[period]![LocaleKeys.appCost] =
              (periodData[period]![LocaleKeys.appCost] ?? 0) +
                  (cpa.debitAmount ?? 0);
          break;
        case LocaleKeys.appExpenseCap:
        case LocaleKeys.appAssetCap:
        case LocaleKeys.appEquityCap:
          periodData[period]![LocaleKeys.appExpense] =
              (periodData[period]![LocaleKeys.appExpense] ?? 0) +
                  (cpa.debitAmount ?? 0);
          break;
      }
    }

    List<PeriodData> result = [];
    for (var entry in periodData.entries) {
      result.add(PeriodData(
        period: entry.key,
        income: entry.value[LocaleKeys.appIncome] ?? 0,
        cost: entry.value[LocaleKeys.appCost] ?? 0,
        expense: entry.value[LocaleKeys.appExpense] ?? 0,
      ));
    }
    result.sort((a, b) => a.period.compareTo(b.period));
    return result;
  }

  Future<void> rangePicker(BuildContext context) async {
    DateTimeRange? range = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2022, 01, 01),
        lastDate: DateTime(DateTime.now().year, DateTime.now().month + 1)
            .subtract(const Duration(days: 1)));
    if (range != null) {
      selectValue(0, startDate: range.start, endDate: range.end);
    }
  }

  String getLabel(int index) {
    switch (index) {
      case 1:
        return LocaleKeys.currentMonth.tr();
      case 2:
        return LocaleKeys.twoMonth.tr();
      case 3:
        return LocaleKeys.threeMonth.tr();
      case 6:
        return LocaleKeys.sixMonth.tr();
      case 9:
        return LocaleKeys.nineMonth.tr();
      case 12:
        return LocaleKeys.twelveMonth.tr();
      default:
        return '';
    }
  }
}
