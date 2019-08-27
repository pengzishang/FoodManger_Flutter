import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import 'package:foodmanger_flutter/vc/notificationRequest.dart';
import 'package:image_picker/image_picker.dart';

import 'package:foodmanger_flutter/Tools/PhotoManger.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 5, initialIndex: 0);

    // Future.delayed(Duration(seconds: 1)).then((onValue) {
    //   Navigator.of(context).push(new MaterialPageRoute(
    //     fullscreenDialog: true,
    //     builder: (_) {
    //     return RequestPage();
    //   }));
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "食物",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        bottom: TabBar(
          isScrollable: true,
          indicatorColor: Colors.transparent,
          controller: _tabController,
          labelPadding: EdgeInsets.only(left: 15),
          tabs: <Widget>[
            RaisedButton(
              child: Text("da"),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              onPressed: () {},
            ),
            RaisedButton(
              child: Text("data21scxz12"),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              onPressed: () {},
            ),
            RaisedButton(
              child: Text("data2dsa2112"),
              onPressed: () {},
            ),
            RaisedButton(
              child: Text("datasadx2112"),
              onPressed: () {},
            ),
            TabbarItem("data2zxcxz112", true),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Container(
            color: Colors.red,
          ),
          ListView(
            children: <Widget>[
              Card(
                margin: EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                elevation: 15,
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: <Widget>[
                    Container(
                      color: Colors.red,
                      height: 200,
                    ),
                    Container(
                      height: 10,
                      child: LinearProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.deepOrange),
                        // backgroundColor: Colors.transparent,
                        value: 0.5,
                        semanticsLabel: "dddd",
                        semanticsValue: "ccvv",
                      ),
                    ),
                    ListTile(
                      title: Text("data"),
                      subtitle: Text("data1111"),
                      trailing: Icon(Icons.cached),
                    )
                  ],
                ),
              ),
              Card(
                margin: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                elevation: 15,
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: <Widget>[
                    Container(
                      color: Colors.red,
                      height: 200,
                    ),
                    Container(
                      height: 10,
                      child: LinearProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.deepOrange),
                        // backgroundColor: Colors.transparent,
                        value: 0.5,
                        semanticsLabel: "dddd",
                        semanticsValue: "ccvv",
                      ),
                    ),
                    ListTile(
                      title: Text("data"),
                      subtitle: Text("data1111"),
                      trailing: Icon(Icons.cached),
                    )
                  ],
                ),
              ),
            ],
          ),
          Container(
            color: Colors.red,
          ),
          Container(
            color: Colors.red,
          ),
          Container(
            color: Colors.red,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          buildShowModalBottomSheet(context);

          // LocalNotifications.createAndroidNotificationChannel(channel: channel);
          // LocalNotifications.createNotification(
          //     title: "Basic",
          //     content: "Notification",
          //     id: 0,
          //     androidSettings: new AndroidSettings(channel: channel));
        },
      ),
    );
  }

  Future buildShowModalBottomSheet(BuildContext context) {
    void takeImage() {
      PhotoManger().takeImage().then((onValue) {
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                title: Text("这个还能保质多久呢?"),
                children: <Widget>[
                  Container(
                    height: 200,
                    color: Colors.red,
                  )
                ],
              );
            });
      });
    }

    void getImage() {
      PhotoManger().getImage().then((onValue) {
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (context) {
              return DurationDialog(onValue);
            });
      });
    }

    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(style: BorderStyle.solid)),
        builder: (BuildContext context) {
          return SafeArea(
            child: Container(
              height: 120,
              child: ListView(
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  Container(
                    height: 60,
                    child: InkWell(
                      child: Center(
                          child: Text(
                        "现在拍一张食物的照片",
                        style: TextStyle(fontSize: 18),
                      )),
                      onTap: () {
                        takeImage();
                      },
                    ),
                  ),
                  Divider(),
                  Container(
                    height: 60,
                    child: InkWell(
                      child: Center(
                          child: Text("相册选一张食物的照片",
                              style: TextStyle(fontSize: 18))),
                      onTap: () {
                        getImage();
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        context: context);
  }
}

class DurationDialog extends StatefulWidget {
  final File imagefile;
  DurationDialog(this.imagefile);
  @override
  _DurationDialogState createState() => _DurationDialogState();
}

class _DurationDialogState extends State<DurationDialog> {
  int duration_day = 1;
  int duration_month = 1;
  String produceDateLabel = "点击选取生产日期";
  bool knowProduceDate = false;
  DateTime selectedTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text("这个还能保质多久呢?"),
      children: <Widget>[
        Container(
          child: Image.file(widget.imagefile),
        ),
        knowProduceDate
            ? Column(
                children: <Widget>[
                  SizedBox(
                    height: 15,
                  ),
                  RaisedButton(
                    elevation: 5,
                    child: Text(
                      produceDateLabel,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () {
                      setState(() {
                        showDatePicker(
                                context: context,
                                firstDate:
                                    DateTime.now().subtract(Duration(days: 30)),
                                initialDate: DateTime.now(),
                                lastDate:
                                    DateTime.now().add(Duration(days: 10 * 30)))
                            .then((onValue) {
                          setState(() {
                            selectedTime = onValue;
                            produceDateLabel =
                                "生产日期:${DateFormat.yMd().format(onValue)}";
                          });
                        });
                      });
                    },
                  ),
                  ListTile(
                    title: Text("保质期大概多久呢?"),
                    subtitle: Text(DateFormat.yMd().format(
                        selectedTime.add(Duration(days: duration_month * 30)))+" 食物到期"),
                    trailing: Text("目前大约${duration_month}月"),
                  ),
                  Slider(
                    divisions: 24,
                    label: "大约${duration_month}月",
                    onChanged: (double value) {
                      setState(() {
                        duration_month = value.toInt();
                        print(duration_month);
                      });
                    },
                    value: duration_month.toDouble(),
                    max: 24,
                    min: 1,
                  ),
                  Align(
                    heightFactor: 0.3,
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                      child: Text(
                        "还是直接输入保质期吧!",
                        style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline),
                      ),
                      onPressed: () {
                        setState(() {
                          knowProduceDate = !knowProduceDate;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 15,),
                  Row(mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                    FlatButton(child: Text("确定",style: TextStyle(color: Colors.blue),), onPressed: () {},),
                    FlatButton(child: Text("取消"), onPressed: () {
                      Navigator.of(context).pop();
                    },)
                  ],),
                ],
              )
            : Column(
                children: <Widget>[
                  ListTile(
                    title: Text("还能保存多久呢?"),
                  ),
                  Slider(
                    divisions: 365,
                    label: "大约${duration_day}天",
                    onChanged: (double value) {
                      // print(value);
                      setState(() {
                        duration_day = value.toInt();
                        print(duration_day);
                      });
                    },
                    value: duration_day.toDouble(),
                    max: 365,
                    min: 1,
                  ),
                  Align(
                    heightFactor: 0.3,
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                      child: Text(
                        "我知道生产日期和保质期!",
                        style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline),
                      ),
                      onPressed: () {
                        setState(() {
                          knowProduceDate = !knowProduceDate;
                        });
                      },
                    ),
                  )
                ],
              )
      ],
    );
  }
}

class TabbarItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  TabbarItem(this.title, this.isSelected);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      elevation: 5,
      child: Text(
        this.title,
        style: TextStyle(color: isSelected ? Colors.white : Colors.black),
      ),
      color: isSelected ? Colors.deepOrange : Colors.grey[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onPressed: () {},
    );
  }
}
