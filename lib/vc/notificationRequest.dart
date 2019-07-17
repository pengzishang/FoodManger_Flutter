import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';

class RequestPage extends StatefulWidget {
  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {

@override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: Colors.white,
        margin: EdgeInsets.only(right: 20, left: 20),
        child: Center(
          child: Column(
            children: <Widget>[
              Opacity(child: Text("我们还需要一点支持"), opacity: 0.5,),
              Row(
                children: <Widget>[
                  Icon(Icons.notifications_active),
                  Text("请允许我们的信息提示,我们不会额外打扰您.")
                ],
              ),
              Container(
                //视频
              ),
              Container(
                width: 300,
                child: CupertinoButton(
                  color: Colors.blue,
                  pressedOpacity: 0.8,
                  child: Center(child: Text("启用推送",style: TextStyle(),)),
                  onPressed: (){},
                ),
              ),
              CupertinoButton(
                  pressedOpacity: 0.8,
                  child: Center(child: Text("稍后启用",style: TextStyle(),)),
                  onPressed: (){},
                ),
            ],
          ),
        ),
      ),
    );
  }
}
