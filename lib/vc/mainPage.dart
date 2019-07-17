// import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_notifications/local_notifications.dart';
import 'dart:async';

import 'package:foodmanger_flutter/vc/notificationRequest.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const AndroidNotificationChannel channel =
      const AndroidNotificationChannel(
          id: 'default_notification',
          name: 'Default',
          description: 'Grant this app the ability to show notifications',
          importance: AndroidNotificationChannelImportance.HIGH);

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3)).then((onValue) {
      Navigator.of(context).push(new MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) {
        return RequestPage();
      }));
      // Navigator.of(context).push(CupertinoPageRoute(builder: (BuildContext context) {
      //   return RequestPage();
      // }));
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(),
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          LocalNotifications.createAndroidNotificationChannel(channel: channel);
          LocalNotifications.createNotification(
              title: "Basic",
              content: "Notification",
              id: 0,
              androidSettings: new AndroidSettings(channel: channel));
        },
      ),
    );
  }
}
