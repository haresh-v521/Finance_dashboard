// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes, avoid_renaming_method_parameters

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader {
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String, dynamic> en = {
    "appIncome": "Income",
    "appIncomeCap": "INCOME",
    "appCost": "Cost",
    "appCostCap": "COST",
    "appExpense": "Expense",
    "appExpenseCap": "EXPENSE",
    "noDataAvailable": "No data available",
    "currentMonth": "Current month",
    "twoMonth": "2 month",
    "threeMonth": "3 month",
    "sixMonth": "6 month",
    "nineMonth": "9 month",
    "twelveMonth": "12 month",
    "customRange": "Custom Range",
    "profit": "Profit",
    "profitAndLoss": "Profit and Loss",
    "appLiabilityCap": "LIABILITY",
    "appAssetCap": "ASSET",
    "appEquityCap": "EQUITY",
    "appOtherIncomeCap": "OTHER INCOME",
    "selectRange": "Selected Range:",
    "noDataRangSelect": "No date range selected"
  };
  static const Map<String, Map<String, dynamic>> mapLocales = {"en": en};
}
