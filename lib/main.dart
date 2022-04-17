import 'package:bitcoin_ticker/utilities/constants.dart';
import 'package:flutter/material.dart';

import 'screens/price_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: kScaffoldBackgroundColor,
      ),
      home: PriceScreen(),
    );
  }
}
