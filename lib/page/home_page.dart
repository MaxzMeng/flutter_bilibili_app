import 'package:flutter/material.dart';
import 'package:flutter_bilibili_app/model/video_model.dart';
import 'package:flutter_bilibili_app/navigator/hi_navigator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin{
  var _listener;

  @override
  void initState() {
    super.initState();
    HiNavigator.getInstance().addListener(this._listener = (current, pre) {
      print('home:current:${current.page}');
      print('home:pre:${pre.page}');
      if (widget == current.page || current.page is HomePage) {
        print('打开了首页:onResume');
      } else if (widget == pre?.page || pre?.page is HomePage) {
        print('首页:onPause');
      }
    });
  }

  @override
  void dispose() {
    HiNavigator.getInstance().removeListener(this._listener);
    super.dispose();
  }

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

  @override
  bool get wantKeepAlive => true;
}
