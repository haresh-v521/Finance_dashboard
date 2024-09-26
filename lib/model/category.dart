import 'dart:convert';

// Chart data classes
class CategoryData {
  final String category;
  final double amount;
  CategoryData(this.category, this.amount);
}

class PeriodData {
  final DateTime period;
  double income;
  double cost;
  double expense;
  PeriodData({
    required this.period,
    this.income = 0,
    this.cost = 0,
    this.expense = 0,
  });
  double get profit => income - (cost + expense);
}

List<CategoryPeriodAmountsModel> categoryPeriodAmountsModelFromJson(
        String str) =>
    List<CategoryPeriodAmountsModel>.from(
        json.decode(str).map((x) => CategoryPeriodAmountsModel.fromJson(x)));

String categoryPeriodAmountsModelToJson(
        List<CategoryPeriodAmountsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoryPeriodAmountsModel {
  final String? id;
  final DateTime? periodDate;
  final double? creditAmount;
  final double? debitAmount;
  final Category? category;

  CategoryPeriodAmountsModel({
    this.id,
    this.periodDate,
    this.creditAmount,
    this.debitAmount,
    this.category,
  });
  double get netActivity => (creditAmount ?? 0) - (debitAmount ?? 0);

  factory CategoryPeriodAmountsModel.fromJson(Map<String, dynamic> json) {
    return CategoryPeriodAmountsModel(
      id: json["id"],
      periodDate: json["periodDate"] == null
          ? null
          : DateTime.parse(json["periodDate"]),
      creditAmount: json["creditAmount"],
      debitAmount: json["debitAmount"],
      category:
          json["category"] == null ? null : Category.fromJson(json["category"]),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "periodDate":
          "${periodDate!.year.toString().padLeft(4, '0')}-${periodDate!.month.toString().padLeft(2, '0')}-${periodDate!.day.toString().padLeft(2, '0')}",
      "creditAmount": creditAmount,
      "debitAmount": debitAmount,
      "category": category?.toJson(),
    };
  }

  @override
  String toString() {
    return 'CategoryPeriodAmountsModel{id: $id, periodDate: $periodDate, creditAmount: $creditAmount, debitAmount: $debitAmount, category: ${category?.name}}';
  }
}

class Category {
  final String? name;
  final String? code;
  final String? sortString;
  final String? type;
  final String? currency;
  final List<int>? indent;

  Category({
    this.name,
    this.code,
    this.sortString,
    this.type,
    this.currency,
    this.indent,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        name: json["name"],
        code: json["code"],
        sortString: json["sortString"],
        type: json["type"],
        currency: json["currency"],
        indent: json["indent"] == null
            ? []
            : List<int>.from(json["indent"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "code": code,
        "sortString": sortString,
        "type": type,
        "currency": currency,
        "indent":
            indent == null ? [] : List<dynamic>.from(indent!.map((x) => x)),
      };
}
