import 'package:ecomprofire/app/constants/routes.dart';
import 'package:ecomprofire/view/cart/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'app/theme/theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(320, 568),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ecomprofire',
        theme: theme(),
        initialRoute: CartScreen.routeName,
        routes: routes,
      ),
    );
  }
}
