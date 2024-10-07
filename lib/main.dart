import 'package:ecomprofire/app/constants/routes.dart';
import 'package:ecomprofire/app/service/notification_service.dart';
import 'package:ecomprofire/view/cart/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'app/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// Arka plan mesaj işleyicisini main fonksiyonunun dışında tanımlayın
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Arka planda mesaj işleniyor: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  final notificationService = NotificationService();
  runApp(MyApp());
}

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
