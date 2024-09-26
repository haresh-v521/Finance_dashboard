import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/chart_provider.dart';

class AppRadioButton extends StatelessWidget {
  final String label;
  final int value;
  final Function(BuildContext)? customRange;
  const AppRadioButton(
      {super.key, required this.label, this.value = 1, this.customRange});
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChartProvider>(context);
    return SizedBox(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Radio(
            value: value,
            groupValue: provider.selectedValue,
            onChanged: (value) async {
              if (customRange != null) {
                customRange!(context);
              } else {
                provider.selectValue(value!);
              }
            },
          ),
          Text(label)
        ],
      ),
    );
  }
}
