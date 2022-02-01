
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stallet/config/preferences.dart';

class PushService {

  //final FirebaseMessaging fcm = FirebaseMessaging();

  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  //
  // Future initialiseLocalNotifications() async {
  //
  //   flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  //   try{
  //     // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  //     var initializationSettingsAndroid = AndroidInitializationSettings('mipmap/ic_launcher');
  //     var initializationSettingsIOS = IOSInitializationSettings(
  //       requestSoundPermission: false,
  //       requestBadgePermission: false,
  //       requestAlertPermission: false,
  //       onDidReceiveLocalNotification: onDidReceiveLocalNotification,
  //     );
  //     var initializationSettings = InitializationSettings(
  //         android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  //     await flutterLocalNotificationsPlugin.initialize(initializationSettings,
  //         onSelectNotification: selectNotification);
  //   }catch(e){
  //     print(e.toString());
  //   }
  // }

//   Future initialisePushService(BuildContext context) async {
//
//     if(Platform.isIOS)
//     {
//
//       fcm.requestNotificationPermissions(IosNotificationSettings(sound: false, badge: true, alert: true));
//     }
//
//     fcm.subscribeToTopic('Events');
//     fcm.configure(
//       //when app is in foreground and we receive a push notification
//       onMessage: (Map<String, dynamic> message) async {
//         print('onMessage: $message');
//         showTopFlash(context: Preferences.currentContext, title: message['title'], message: message['message']);
//       },
//       onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
//       //when app is closed completely and its opened from push notification
//       onLaunch: (Map<String, dynamic> message) async {
//         Navigator.of(context).push(MaterialPageRoute(builder: (context) => CustomNavBar(index: 0,)));
//       },
//       //when app is in background and its opened from push notification
//       onResume: (Map<String, dynamic> message) async {
//         print('onResume: $message');
//         Navigator.of(context).push(MaterialPageRoute(builder: (context) => CustomNavBar(index: 0,)));
//       },
//     );
//
//     fcm.getToken().then((String token) async{
//
//       //assert(token != null);
//       Preferences.fcmToken = token;
//
//       if(token != null){
// //save token
//         await FirebaseFirestore.instance.collection('Users')
//             .doc(Preferences.uid)
//             .collection('Tokens')
//             .doc(token).set({
//           'token' : token,
//           'createdAt' : FieldValue.serverTimestamp(),
//           'platform' : Platform.operatingSystem,
//         });
//       }
//       print('fcm push notification token: '+ token);
//     });
//   }
//
//   Future onDidReceiveLocalNotification(int id, String title, String body, String payLoad) async {
//
//     //somewhere should go here
//   }
//
//   Future<void> sendLocalNotification (String title, String body, BuildContext context, FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
//
//     try{
//       var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//           'channel id: $title', 'channel name: $title', 'channel description: $body',
//           importance: Importance.max, priority: Priority.high, ticker: 'ticker');
//
//       var iOSPlatformChannelSpecifics = IOSNotificationDetails();
//
//       var platformChannelSpecifics = NotificationDetails(
//           android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
//
//       print('sending notification: ' + title);
//       await flutterLocalNotificationsPlugin.show(0, '$title', '$body', platformChannelSpecifics, payload: 'Default_Sound',);
//     }catch(e){
//       print(e.toString());
//     }
//
//   }
//
//   Future selectNotification(String payload) async {
//     if (payload != null) {
//       print('notification payload: ' + payload);
//     }
//
//     /*await Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => SecondScreen(payload)),
//     );*/
//   }
//
//   static Future<bool> callOnFcmApiSendPushNotifications({List <String> userToken, String title, String body}) async {
//
//     final postUrl = 'https://fcm.googleapis.com/fcm/send';
//     final data = {
//       //"registration_ids" : userToken,
//
//       "collapse_key" : "type_a",
//       "notification" : {
//         "title": title,
//         "body" : body,
//         "image" : ""
//       },
//       "priority": "high",
//       "data": {
//         "click_action": "FLUTTER_NOTIFICATION_CLICK",
//         "id": "1",
//         "status": "done"
//       },
//       "to" : Preferences.fcmToken,
//     };
//
//     final headers = {
//       'content-type': 'application/json',
//       'Authorization': 'key=' // 'key=YOUR_SERVER_KEY'
//     };
//
//     final response = await http.post(
//         postUrl,
//         body: json.encode(data),
//         encoding: Encoding.getByName('utf-8'),
//         headers: headers);
//
//     if (response.statusCode == 200) {
//       // on success do sth
//       print('test ok push CFM');
//       return true;
//     } else {
//       print(' CFM error');
//       // on failure do sth
//       return false;
//     }
//   }

}