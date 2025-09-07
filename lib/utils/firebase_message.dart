import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class FirebaseMessage {
  static Future<void> initialize() async {
    await FirebaseMessaging.instance.requestPermission();

    // setup background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    String? token = await FirebaseMessaging.instance.getToken();
    print('FCM token: $token');

    // get foreground message
    FirebaseMessaging.onMessage.listen((message) {});

    FirebaseMessaging.onMessageOpenedApp.listen((message) {});
  }

  static Future<String?> getToken() => FirebaseMessaging.instance.getToken();
}
