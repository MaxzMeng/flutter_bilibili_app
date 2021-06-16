import 'package:flutter/material.dart';
import 'package:flutter_bilibili_app/model/video_model.dart';
import 'package:flutter_bilibili_app/navigator/hi_navigator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            Text('首页'),
            MaterialButton(
                child: Text('详情'),
                onPressed: () => {
                      HiNavigator.getInstance().onJumpTo(RouteStatus.detail,
                          args: {'videoMo': VideoModel(1001)})
                    })
          ],
        ),
      ),
    );
  }
}
