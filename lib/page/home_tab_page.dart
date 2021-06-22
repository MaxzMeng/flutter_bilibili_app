import 'package:flutter/material.dart';
import 'package:flutter_bilibili_app/model/home_mo.dart';
import 'package:flutter_bilibili_app/widget/hi_banner.dart';

class HomeTabPage extends StatefulWidget {
  final String categoryName;
  final List<BannerMo>? bannerList;

  const HomeTabPage({Key? key, required this.categoryName, this.bannerList})
      : super(key: key);

  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [if (widget.bannerList != null) _banner()],
      ),
    );
  }

  _banner() {
    return Padding(
      padding: EdgeInsets.only(left: 8, right: 8),
      child: HiBanner(widget.bannerList ?? List<BannerMo>.empty()),
    );
  }
}
