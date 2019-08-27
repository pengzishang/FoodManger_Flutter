import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:video_player/video_player.dart';
// import 'package:local_notifications/local_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class RequestPage extends StatefulWidget {
  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage>
    with TickerProviderStateMixin {
  AnimationController animationController;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  // static const AndroidNotificationChannel channel =
  //     const AndroidNotificationChannel(
  //         id: 'default_notification',
  //         name: 'Default',
  //         description: 'Grant this app the ability to show notifications',
  //         importance: AndroidNotificationChannelImportance.HIGH);

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this,
        duration: Duration(seconds: 4),
        lowerBound: 0,
        upperBound: 4);
    animationController.addListener(() {
      print(animationController.value);
      setState(() {});
    });

    animationController.forward();
  }

  void requestAuthentication() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    print("id:$id title:$title,body:$body , payload:$payload");
    // if (title != null) {
    //   debugPrint('notification payload: ' + title);
    // }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('通知'),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          margin: EdgeInsets.only(right: 30, left: 30),
          child: Column(
            children: <Widget>[
              Opacity(
                opacity: animationController.value - 0 < 0
                    ? 0
                    : animationController.value - 0 > 1
                        ? 1
                        : (animationController.value - 0),
                child: Container(
                    margin: EdgeInsets.only(top: 60),
                    height: size.height * 0.15,
                    child: Center(
                        child:
                            Text("我们还需要一点支持", style: TextStyle(fontSize: 30)))),
              ),
              Opacity(
                opacity: animationController.value - 1 < 0
                    ? 0
                    : animationController.value - 1 > 1
                        ? 1
                        : (animationController.value - 1),
                child: Container(
                  margin: EdgeInsets.only(right: 10, left: 10),
                  child: Row(
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: Icon(
                            Icons.notifications_active,
                            size: 40,
                            color: Colors.orange,
                          )),
                      Expanded(
                          child: Text(
                        "请允许我们的信息提示,我们不会额外打扰您.",
                        style: TextStyle(fontSize: 20),
                      ))
                    ],
                  ),
                ),
              ),
              Opacity(
                opacity: animationController.value - 2 < 0
                    ? 0
                    : animationController.value - 2 > 1
                        ? 1
                        : (animationController.value - 2),
                child: Container(
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  color: Colors.green,
                  height: 200,
                  //视频
                ),
              ),
              Opacity(
                opacity: animationController.value - 3 < 0
                    ? 0
                    : (animationController.value - 3),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      child: CupertinoButton(
                        color: Colors.blue,
                        pressedOpacity: 0.8,
                        child: Center(
                            child: Text(
                          "启用推送",
                          style: TextStyle(),
                        )),
                        onPressed: requestAuthentication,
                      ),
                    ),
                    Container(
                      child: CupertinoButton(
                        pressedOpacity: 0.8,
                        child: Center(
                            child: Text(
                          "稍后启用",
                          style: TextStyle(),
                        )),
                        onPressed: () async {
                          var androidPlatformChannelSpecifics =
                              AndroidNotificationDetails(
                                  'your channel id',
                                  'your channel name',
                                  'your channel description',
                                  importance: Importance.Max,
                                  priority: Priority.High,
                                  ticker: 'ticker');
                          var iOSPlatformChannelSpecifics =
                              IOSNotificationDetails();
                          var platformChannelSpecifics = NotificationDetails(
                              androidPlatformChannelSpecifics,
                              iOSPlatformChannelSpecifics);

                          await flutterLocalNotificationsPlugin.show(
                              0,
                              'plain title',
                              'plain body',
                              platformChannelSpecifics,
                              payload: 'item x');

                          await flutterLocalNotificationsPlugin.schedule(
                              0,
                              'scheduled title',
                              'scheduled body',
                              DateTime.now().add(Duration(seconds: 10)),
                              platformChannelSpecifics);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
