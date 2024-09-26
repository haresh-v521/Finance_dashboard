import 'package:demo_dashboard/provider/chart_provider.dart';
import 'package:demo_dashboard/provider/pie_chart_provider.dart';
import 'package:demo_dashboard/translations/locale_keys.g.dart';
import 'package:demo_dashboard/widget/common_radio_button.dart';
import 'package:demo_dashboard/widget/line_chart.dart';
import 'package:demo_dashboard/widget/pie_chart_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  PieChartProvider? _pieChartProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChartProvider>(context, listen: false).fetchData();
      Provider.of<ChartProvider>(context, listen: false).selectValue(1);
      _pieChartProvider = Provider.of<PieChartProvider>(context, listen: false);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ChartProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (provider.error != null) {
            return Text('Error: ${provider.error}');
          } else if (provider.data != null) {
            final profitLossData =
                provider.getProfitAndLossData(provider.data?.lineData ?? []);
            return LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                bool isWideScreen = constraints.maxWidth > 600;
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 50,
                            ),
                            isWideScreen
                                ? Wrap(
                              crossAxisAlignment: WrapCrossAlignment.start,alignment: WrapAlignment.start,
                                    children: [
                                      ...[1, 2, 3, 6, 9, 12].map((value) {
                                        return InkWell(
                                          child: SizedBox(width: 130,
                                            child: AppRadioButton(
                                              label: provider.getLabel(value),
                                              value: value,
                                            ),
                                          ),
                                          onTap: () {
                                            provider.selectValue(value);
                                            if (value == 0) {
                                              provider.rangePicker(context);
                                            }
                                          },
                                        );
                                      }),
                                      InkWell(
                                        child: SizedBox(
                                          width: 130,
                                          child: AppRadioButton(
                                            label: LocaleKeys.customRange.tr(),
                                            value: 0,
                                            customRange: provider.rangePicker,
                                          ),
                                        ),
                                        onTap: () => provider.rangePicker(context),
                                      ),
                                    ],
                                  )
                                : Padding(
                                  padding: const EdgeInsets.only(left: 0,right: 0),
                                  child: GridView.count(
                                      physics: isWideScreen
                                          ? const BouncingScrollPhysics()
                                          : const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      scrollDirection: isWideScreen
                                          ? Axis.horizontal
                                          : Axis.vertical,
                                      padding: EdgeInsets.zero,
                                      crossAxisCount: 2,childAspectRatio: 7,
                                      children: [
                                        ...[1, 2, 3, 6, 9, 12].map((value) {
                                          return InkWell(
                                            child: AppRadioButton(
                                              label: provider.getLabel(value),
                                              value: value,
                                            ),
                                            onTap: () {
                                              provider.selectValue(value);
                                              if (value == 0) {
                                                provider.rangePicker(context);
                                              }
                                            },
                                          );
                                        }),
                                        Center(
                                          child: InkWell(
                                            child: AppRadioButton(
                                              label: LocaleKeys.customRange.tr(),
                                              value: 0,
                                              customRange: provider.rangePicker,
                                            ),
                                            onTap: () => provider.rangePicker(context),
                                          ),
                                        ),
                                      ],
                                    ),
                                ),
                            Padding(
                              padding:EdgeInsets.only(top: 5,left: isWideScreen ? 10 : 12),
                              child: Text(
                                provider.startDate != null && provider.endDate != null
                                    ? '${LocaleKeys.selectRange.tr()} ${DateFormat('yyyy/MM/dd').format(provider.startDate!)} - ${DateFormat('yyyy/MM/dd').format(provider.endDate!)}'
                                    : LocaleKeys.noDataRangSelect.tr(),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: isWideScreen ? 320 : null,
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: isWideScreen
                                ? const BouncingScrollPhysics()
                                : const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            scrollDirection:
                                isWideScreen ? Axis.horizontal : Axis.vertical,
                            itemCount: provider.data!.pieData.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 0),
                            itemBuilder: (context, index) {
                              return PieChartWidget(
                                title: index == 0
                                    ? LocaleKeys.appIncome
                                    : index == 1
                                        ? LocaleKeys.appCost
                                        : LocaleKeys.appExpense,
                                chartData: _pieChartProvider!
                                    .setData(provider.data!.pieData[index]),
                              );
                            },
                          ),
                        ),
                        Center(
                          child: SizedBox(
                            width: isWideScreen ? 800 : 400,
                            child: ProfitAndLossChartWidget(
                              data: profitLossData,
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text(LocaleKeys.noDataAvailable),
            );
          }
        },
      ),
    );
  }
}
