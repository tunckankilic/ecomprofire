import 'package:ecomprofire/app/constants/routes.dart';
import 'package:ecomprofire/view/cart/cart_screen.dart';
import 'package:flutter/material.dart';
import 'app/theme/theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ecomprofire',
      theme: theme(),
      initialRoute: CartScreen.routeName,
      routes: routes,
    );
  }
}
