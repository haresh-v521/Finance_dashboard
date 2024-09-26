import 'package:flutter/services.dart';

import '../model/category.dart';

class ChartDataRepo {
  Future<List<CategoryPeriodAmountsModel>> fetchChartData (int selectedMonthRange) async {
    await Future.delayed(const Duration(milliseconds: 300));
    String jsonString = await rootBundle.loadString('lib/model/mock_data.json');

    List<CategoryPeriodAmountsModel> dataList = categoryPeriodAmountsModelFromJson(jsonString);


    return dataList;
  }
}