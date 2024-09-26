import 'category.dart';

class Data {
  final List<List<CategoryPeriodAmountsModel>> pieData;
  final List<CategoryPeriodAmountsModel> lineData;
  final int selectedValue;
  Data({required this.pieData, required this.lineData,required this.selectedValue,});
}