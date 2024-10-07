import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService() {
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    // FCM için izinleri iste
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Kullanıcı bildirimlere izin verdi');
    } else {
      print('Kullanıcı bildirimleri reddetti');
    }

    // FCM token'ını al
    String? token = await _firebaseMessaging.getToken();
    print('FCM Token: $token');

    // Yerel bildirimler için initializer
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Bildirime tıklandığında yapılacak işlemler
        print('Bildirime tıklandı: ${response.payload}');
      },
    );

    // Ön planda FCM mesajlarını dinle
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Ön planda mesaj alındı!');
      _showNotification(message);
    });

    // Arka planda veya kapalıyken FCM mesajlarını dinle
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> _showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      await _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'channel_id', // Manifest ile tutarlı
            'channel_name',
            channelDescription: 'channel_description',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        payload: message.data['payload'],
      );
    }
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledDate,
  }) async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'channel_id', // Manifest ile tutarlı
          'channel_name',
          channelDescription: 'channel_description',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode
          .exactAllowWhileIdle, // androidAllowWhileIdle yerine
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // Yardımcı metod: DateTime'ı TZDateTime'a dönüştürür
  tz.TZDateTime _convertToTZDateTime(DateTime dateTime, tz.Location location) {
    return tz.TZDateTime.from(dateTime, location);
  }

  // Kullanım kolaylığı için ek bir metod
  Future<void> scheduleNotificationDateTime({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    required tz.Location location,
  }) async {
    final tzDateTime = _convertToTZDateTime(scheduledDate, location);
    await scheduleNotification(
      id: id,
      title: title,
      body: body,
      scheduledDate: tzDateTime,
    );
  }

  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}

// Bu fonksiyon, main.dart dosyasının dışında tanımlanmalıdır
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Arka planda mesaj işleniyor: ${message.messageId}");
  // Burada arka plan mesajını işleyebilirsiniz
}
