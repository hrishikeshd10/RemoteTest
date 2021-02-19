import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_neighbourhood_online/Providers/categories_provdier.dart';
import 'package:my_neighbourhood_online/Providers/location_provider.dart';
import 'package:my_neighbourhood_online/Utilities/key_constants.dart';
import 'package:my_neighbourhood_online/api_response_model/notification_model.dart';
import 'package:my_neighbourhood_online/screens/register.dart';
import 'package:my_neighbourhood_online/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }
  print("background");

  MyAppState().showNotification(message);

  // Or do other work.
}

StreamController<bool> controller = BehaviorSubject<bool>();
void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white, // navigation bar color
    statusBarColor: Colors.transparent, // status bar color
    statusBarBrightness: Brightness.light, //status bar brigtness
    statusBarIconBrightness: Brightness.light, //status barIcon Brightness
    //Navigation bar divider color
    systemNavigationBarIconBrightness: Brightness.light, //navigation bar icon
  ));
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  // static Future<dynamic> myBackgroundMessageHandler(
  //     Map<String, dynamic> message) async {
  //   print("sound played");
  //
  //   return null;
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
    if (Platform.isAndroid) {
      configLocalNotification();
      _firebaseMessaging.configure(
          onBackgroundMessage: myBackgroundMessageHandler,
          onMessage: (message) async {
            showNotification(message);
            setState(() {});
          },
          onResume: (message) async {
            print("ON resume");
            setState(() {});
          },
          onLaunch: (message) async {
            print("hi on launch");
            showNotification(message);
            setState(() {});
          });
    }
  }

  Future selectNotification(String payload) async {
    print('selectNotification $payload');
  }

  void configLocalNotification() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings("@mipmap/ic_launcher");
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  void showNotification(message) async {
    print('showNotification  $message');

    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'default_notification_channel_id',
        'EasyCare Notification Channel',
        'EasyCare',
        playSound: true,
        enableVibration: true,
        importance: Importance.max,
        priority: Priority.max,
        styleInformation: BigTextStyleInformation(message['data']['body']));
    var title = message['notification']['title'];
    var body = message['notification']['body'];

    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title.toString(),
      body.toString(),
      platformChannelSpecifics,
    );
//Load notifications in the preferences.
    final SharedPreferences pref = await SharedPreferences.getInstance();
    NotificationModel notificationModel = NotificationModel(
        title: message['notification']['title'],
        body: message['notification']['body']);
    List<String> notificationList =
        pref.getStringList(SPKeys.notificationList) ?? [];
    notificationList.add(notificationModelToJson(notificationModel));
    pref.setStringList(SPKeys.notificationList, notificationList);
    print(pref.getStringList(SPKeys.notificationList)[0]);
    controller.add(true);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: LocationProvider()),
        ChangeNotifierProvider.value(value: CategoriesProvider())
      ],
      child: MaterialApp(
          title: 'My Neighbourhood Online',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            accentColorBrightness: Brightness.dark,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            textTheme:
                GoogleFonts.montserratTextTheme(Theme.of(context).textTheme),
          ),
          home: SplashScreen(),
          routes: <String, WidgetBuilder>{
            '/signup': (BuildContext context) => new SignUpPage(),
          }),
    );
  }
}
