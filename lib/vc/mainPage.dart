import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import 'package:foodmanger_flutter/vc/notificationRequest.dart';
import 'package:image_picker/image_picker.dart';

import 'package:foodmanger_flutter/Tools/PhotoManger.dart';
import 'package:foodmanger_flutter/DataBase/dataBase.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  int selectIndex = 0;
  List<FoodDataModel> models;

  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 4, initialIndex: 0);
    _tabController.addListener(() {
      setState(() {
        selectIndex = _tabController.index;
      });
    });
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
            TabbarItem(
              "全部记录",
              selectIndex == 0,
              onPressed: () {
                setState(() {
                  selectIndex = 0;
                });
              },
            ),
            TabbarItem(
              "最近3天",
              selectIndex == 1,
              onPressed: () {
                setState(() {
                  selectIndex = 1;
                });
              },
            ),
            TabbarItem(
              "最近1个月",
              selectIndex == 2,
              onPressed: () {
                setState(() {
                  selectIndex = 2;
                });
              },
            ),
            TabbarItem(
              "保质期过半",
              selectIndex == 3,
              onPressed: () {
                setState(() {
                  selectIndex = 3;
                });
              },
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          FutureBuilder(
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return FoodList(snapshot.data);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
            future: DBSharedInstance().getAllData(),
          ),
          FutureBuilder(
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return FoodList(snapshot.data);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
            future: DBSharedInstance().getAllData(),
          ),
          FutureBuilder(
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return FoodList(snapshot.data);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
            future: DBSharedInstance().getAllData(),
          ),FutureBuilder(
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return FoodList(snapshot.data);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
            future: DBSharedInstance().getAllData(),
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
            barrierDismissible: false,
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
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return DurationDialog(onValue);
            }).then((onValue) {
          if (onValue == null) {
            return;
          }
          String errorCode = onValue["errorCode"];
          FoodDataModel data = onValue["data"];
          if (errorCode != null) {
            if (errorCode == "100") {
              buildShowModalBottomSheet(context);
            }
          } else if (data != null) {}
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
  int duration_day = 14;
  int duration_month = 8;
  String produceDateLabel = "点击选取生产日期";
  DateTime produceDate;
  bool knowProduceDate = false;
  DateTime selectedTime;

  bool isVaild = false;
  String name;

  @override
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text("这个还能保质多久呢?"),
      children: <Widget>[
        Stack(
          children: <Widget>[
            Image.file(widget.imagefile),
            IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
                size: 40,
              ),
              onPressed: () {
                Navigator.of(context).pop({"data": null, "errorCode": "100"});
              },
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 50, left: 50),
          child: TextField(
            decoration: InputDecoration(helperText: "食物名字", hintText: "输入食物名字"),
            maxLength: 10,
            onChanged: (value) {
              name = value;
              print(value);
            },
            style: TextStyle(fontSize: 30),
            textAlign: TextAlign.center,
          ),
        ),
        knowProduceDate
            ? Column(
                children: <Widget>[
                  ListTile(
                    title: Text("外包装标明的保质期是多少呢?"),
                    subtitle: Text(isVaild
                        ? DateFormat.yMd().format(selectedTime
                                .add(Duration(days: duration_month * 30))) +
                            " 食物到期"
                        : "请先选择一个食品生产日期"),
                    trailing: Text("保质期${duration_month}月"),
                  ),
                  Slider(
                    divisions: 24,
                    label: "大约剩${duration_month}个月",
                    onChanged: (double value) {
                      setState(() {
                        duration_month = value.toInt();
                      });
                    },
                    value: duration_month.toDouble(),
                    max: 24,
                    min: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: RaisedButton(
                      elevation: 5,
                      child: Text(
                        produceDateLabel,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      onPressed: () {
                        setState(() {
                          buildShowDatePicker(context).then((onValue) {
                            if (onValue != null) {
                              setState(() {
                                selectedTime = onValue;
                                isVaild = true;
                                produceDateLabel =
                                    "生产日期:${DateFormat.yMd().format(onValue)}";
                              });
                            }
                          });
                        });
                      },
                    ),
                  ),
                  Align(
                    heightFactor: 0.3,
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                      child: Text(
                        "还是直接估计保质期吧!",
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
                  Padding(
                    padding: const EdgeInsets.only(top: 10, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        FlatButton(
                          child: Text(
                            "确定",
                            style: TextStyle(
                                color: isVaild ? Colors.blue : Colors.grey),
                          ),
                          onPressed: isVaild
                              ? () {
                                  var expireDate = DateTime(
                                      selectedTime.year,
                                      selectedTime.month + duration_month,
                                      selectedTime.day);
                                  var model = FoodDataModel(DateTime.now().millisecondsSinceEpoch.toDouble(),
                                      name: name,
                                      productDate:
                                          selectedTime.millisecondsSinceEpoch.toDouble(),
                                      freshTimeDuration: (expireDate
                                          .difference(selectedTime)
                                          .inMilliseconds).toDouble());
                                  DBSharedInstance()
                                      .insertList(model)
                                      .then((onValue) {
                                    Navigator.of(context).pop(
                                        {"data": model, "errorCode": null});
                                  });
                                }
                              : null,
                        ),
                        FlatButton(
                          color: Colors.grey[100],
                          child: Text("取消"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ),
                  ),
                ],
              )
            : Column(
                children: <Widget>[
                  ListTile(
                    title: Text("您估计还能保存多久呢?"),
                    subtitle: Text(DateFormat.yMd().format(
                            DateTime.now().add(Duration(days: duration_day))) +
                        " 食物到保质期"),
                    trailing: Text("大约${duration_day}天"),
                  ),
                  Slider(
                    divisions: 365,
                    label: "大约${duration_day}天",
                    onChanged: (double value) {
                      setState(() {
                        duration_day = value.toInt();
                      });
                    },
                    value: duration_day.toDouble(),
                    max: 365,
                    min: 1,
                  ),
                  Align(
                    heightFactor: 0.4,
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
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        FlatButton(
                          child: Text(
                            "确定",
                            style: TextStyle(color: Colors.blue),
                          ),
                          onPressed: () {
                            var model = FoodDataModel(DateTime.now().millisecondsSinceEpoch.toDouble(),
                                name: name,
                                duration: (duration_day * 24 * 60 * 60 * 1000).toDouble());
                            DBSharedInstance()
                                .insertList(model)
                                .then((onValue) {
                              print(onValue);
                              Navigator.of(context)
                                  .pop({"data": model, "errorCode": null});
                            });
                          },
                        ),
                        FlatButton(
                          color: Colors.grey[100],
                          child: Text("取消"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ),
                  ),
                ],
              )
      ],
    );
  }

  Future<DateTime> buildShowDatePicker(BuildContext context) {
    return showDatePicker(
        context: context,
        firstDate: DateTime(DateTime.now().year,
            DateTime.now().month - duration_month, DateTime.now().day),
        initialDate: DateTime.now(),
        lastDate: DateTime(
            DateTime.now().year + 1, DateTime.now().month, DateTime.now().day));
  }
}

class TabbarItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  @required
  VoidCallback onPressed;
  TabbarItem(this.title, this.isSelected, {this.onPressed});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      elevation: 2,
      child: Text(
        this.title,
        style: TextStyle(color: Colors.white),
      ),
      color: isSelected ? Colors.deepOrange : Colors.grey[400],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onPressed: onPressed,
    );
  }
}

class FoodCard extends StatefulWidget {
  final FoodDataModel model;
  FoodCard(this.model);

  @override
  _FoodCardState createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 15,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.red,
            height: 200,
          ),
          Container(
            height: 5,
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
    );
  }
}

class FoodList extends StatefulWidget {
  final List<FoodDataModel> list;

  FoodList(this.list);

  @override
  _FoodListState createState() => _FoodListState();
}

class _FoodListState extends State<FoodList> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: widget.list.map((item) => FoodCard(item)).toList(),
    );
  }
}
