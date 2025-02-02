library easy_firebase_notification;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class EasyFirebaseNotification
{
    static String appTitleLocale = "appTitle";
    static String token = "";
    static String allTopicValueLocale = "all";

    static int _index = 0;
    static BuildContext? _buildContext;

    static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

    static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

    static final NotificationDetails _notDet = NotificationDetails(
        android: AndroidNotificationDetails(
            appTitleLocale,
            "${appTitleLocale}_channel",
            priority: Priority.high,
            importance: Importance.high,
            icon: "@mipmap/ic_launcher",
            color: ThemeData().primaryColor
        ),
        iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true
        )
    );

    static AlertDialog Function({required String title, required String body}) defaultAlertDialog =
        ({required String title, required String body}) =>
        AlertDialog(
            scrollable: true,
            title: Text(title),
            content: Text(body),
            actions:
            [
              TextButton(
                  onPressed: ()
                  {
                    Navigator.pop(_buildContext!);
                  },
                  child: const Text("Back")
              ),
            ]
        );

    static Future<void> start(
        {
          AlertDialog Function({required String title, required String body})? alertDialog,
          required BuildContext context,
          String? appTitle,
          String? allTopic,
        }) async
    {
        _buildContext = context;
        if(alertDialog != null)
        {
            defaultAlertDialog = alertDialog;
        }
        if(appTitle != null)
        {
            appTitleLocale = appTitle;
        }
        if(allTopic != null)
        {
            allTopicValueLocale = allTopic;
        }
        await _initialize();
        await _listen();
        await _listenClick();
    }

    static Future<void> addTopic(String topic) async => await _firebaseMessaging.subscribeToTopic(topic);

    static Future<void> removeTopic(String topic) async => await _firebaseMessaging.unsubscribeFromTopic(topic);

    static Future<void> removeAllTopic() async => await _firebaseMessaging.unsubscribeFromTopic(allTopicValueLocale);

    static Future<String> getToken() async => (await _firebaseMessaging.getToken()).toString();

    static Future<void> _initialize() async
    {
        await _firebaseMessaging.setAutoInitEnabled(true);
        await addTopic(allTopicValueLocale);
        await _firebaseMessaging.requestPermission(
            alert: true,
            announcement: true,
            badge: true,
            carPlay: true,
            criticalAlert: true,
            provisional: true,
            sound: true
        );
        token = await getToken();
        _firebaseMessaging.onTokenRefresh.listen((String t) async => token = t);
    }

    static Future<void> _process(RemoteMessage message) async
    {
        String title = message.notification?.title ?? "";
        String body = message.notification?.body ?? "";
        _index ++;
        await _notifications.show(
            _index,
            title,
            body,
            _notDet
        );
        if(_buildContext != null)
        {
          await showDialog(
              context: _buildContext!,
              builder: (context) => defaultAlertDialog(title: title, body: body)
          );
        }
    }

    static Future<void> _listen() async => FirebaseMessaging.onMessage.listen((RemoteMessage message) async => await _process(message));

    static Future<void> _listenClick() async => FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async => await _process(message));
}

