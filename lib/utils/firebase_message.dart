import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class FirebaseMessage {
  static Future<void> initialize() async {
    // turn off on the web
    if (kIsWeb) {
      return;
    }

    FirebaseMessaging firebaseMessage = FirebaseMessaging.instance;
    await firebaseMessage.requestPermission();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await firebaseMessage.subscribeToTopic('all_users');

    FirebaseMessaging.onMessage.listen((message) {});
    FirebaseMessaging.onMessageOpenedApp.listen((message) {});
  }

  static Future<String?> getToken() {
    if (kIsWeb) {
      return Future.value(null);
    }
    return FirebaseMessaging.instance.getToken();
  }
}
