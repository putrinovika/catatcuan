import 'package:mycashbook/constant/route_constants.dart';
import 'package:mycashbook/pages/AddExpenditurePage.dart';
import 'package:mycashbook/pages/AddIncomePage.dart';
import 'package:mycashbook/pages/DetailCashFlowPage.dart';
import 'package:mycashbook/pages/HomePage.dart';
import 'package:mycashbook/pages/LoginPage.dart';
import 'package:mycashbook/pages/SettingsPage.dart';
import 'package:mycashbook/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => UserProvider()),
  ], child: const MyApp()));
}

final routes = {
  loginRoute: (BuildContext context) => LoginPage(),
  homeRoute: (BuildContext context) => HomePage(),
  settingsRoute: (BuildContext context) => SettingsPage(),
  addExpenseRoute: (BuildContext context) => AddExpenditurePage(),
  addIncomeRoute: (BuildContext context) => AddIncomePage(),
  detailCashFlowRoute: (BuildContext context) => DetailCashFlowPage(),
};

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "MyCashBook App",
      theme: ThemeData(primaryColor: Colors.green.shade800),
      routes: routes,
    );
  }
}
