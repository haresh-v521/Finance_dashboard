import 'package:demo_dashboard/provider/chart_provider.dart';
import 'package:demo_dashboard/provider/pie_chart_provider.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'chart_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(

      EasyLocalization(
        supportedLocales: const [Locale('en')],
        path: 'assets/translations', // <-- change the path of the translation files
        fallbackLocale: const Locale('en'),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => ChartProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => PieChartProvider(),
          ),
          // Add DurationProvider
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const ChartScreen());
  }
}
