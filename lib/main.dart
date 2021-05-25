import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendor_dabbawala/UI/options_page.dart';
import 'package:vendor_dabbawala/UI/view_my_order_numbers.dart';
import 'UI/login_page.dart';
import 'package:vendor_dabbawala/UI/data/login_data.dart' as login;

BuildContext context;
var userToken;

final FirebaseMessaging _messaging = FirebaseMessaging();
final FirebaseMessaging _fcm = FirebaseMessaging();
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> isLoggedIn() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  login.storedUserId = prefs.getString('userId');
  print(login.storedUserId);
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //Future.delayed(Duration(seconds: 2), () async {
    runApp(MyApp());
  //});
  initFCM();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,

        ),
        home: LoginPage(),
    );
  }
}

var msg;

initFCM() async {

  flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

  var android = new AndroidInitializationSettings('app_icon');
  var iOS = new IOSInitializationSettings();

  var initSettings = new InitializationSettings(android, iOS);

  flutterLocalNotificationsPlugin.initialize(initSettings,
      onSelectNotification: onSelectNotification);

  userToken = await _messaging.getToken();
  print(userToken.toString());

  _fcm.configure(
    onMessage: (Map<String, dynamic> message) async {

      showOnMessageNotification(message);
      print("onMessage.....: $message");
      fcmMessageHandler(message, context);

    },
    onLaunch: (Map<String, dynamic> message) async {

      print("onLaunch: $message");
      fcmMessageHandler(message, context);

    },
    onResume: (Map<String, dynamic> message) async {

      print("onResume: $message");
      fcmMessageHandler(message, context);

    },
  );
  _fcm.requestNotificationPermissions(
      const IosNotificationSettings(
        sound: true,
        alert: true,
        badge: true,
      )
  );
  _fcm.onIosSettingsRegistered.listen((IosNotificationSettings setting){
    print("ios settings registered");
  });

}

Future showOnMessageNotification(var message) async {

  var android = new AndroidNotificationDetails(
      'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
      priority: Priority.High,importance: Importance.Max //HLFL48VG4M keyid //M68WY29944
  );
  var iOS = new IOSNotificationDetails();
  var platform = new NotificationDetails(android, iOS);
  await flutterLocalNotificationsPlugin.show(
      1, message['notification']['title'].toString(), message['notification']['body'].toString(), platform,
      payload: '');


  if(message['notification']['body'].toString() == "You have received a new order. Tap to know the details."){
    Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (c, a1, a2) => ViewMyOrderNumbers(),
          transitionsBuilder: (c, anim, a2, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: Duration(milliseconds: 300),
        )
    );
  }else{
    Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (c, a1, a2) => ViewMyOrderNumbers(),
          transitionsBuilder: (c, anim, a2, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: Duration(milliseconds: 300),
        )
    );
  }

}

void fcmMessageHandler(message, context) {
  switch (message['notification']['body']) {
    case "You have received a new order. Tap to know the details.":
      Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (c, a1, a2) => ViewMyOrderNumbers(),
            transitionsBuilder: (c, anim, a2, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: Duration(milliseconds: 300),
          )
      );
      break;
    default:
      Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (c, a1, a2) => ViewMyOrderNumbers(),
            transitionsBuilder: (c, anim, a2, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: Duration(milliseconds: 300),
          )
      );
      break;
  }
}

Future onSelectNotification(String message){

  Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (c, a1, a2) => ViewMyOrderNumbers(),
        transitionsBuilder: (c, anim, a2, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: Duration(milliseconds: 300),
      )
  );

}