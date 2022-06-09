import 'package:ecomprofire/app/constants/routes.dart';
import 'package:flutter/material.dart';
import 'app/theme/theme.dart';
import 'view/view_shelf.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ecomprofire',
      theme: theme(),
      initialRoute: SplashScreen.routeName,
      routes: routes,
    );
  }
}
