import 'package:flutter/material.dart';
import 'package:flutter_bilibili_app/http/core/hi_error.dart';
import 'package:flutter_bilibili_app/http/dao/home_dao.dart';
import 'package:flutter_bilibili_app/model/home_mo.dart';
import 'package:flutter_bilibili_app/model/video_model.dart';
import 'package:flutter_bilibili_app/util/toast_util.dart';
import 'package:flutter_bilibili_app/widget/hi_banner.dart';
import 'package:flutter_bilibili_app/widget/video_card.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomeTabPage extends StatefulWidget {
  final String categoryName;
  final List<BannerMo>? bannerList;

  const HomeTabPage({Key? key, required this.categoryName, this.bannerList})
      : super(key: key);

  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> with AutomaticKeepAliveClientMixin{
  List<VideoModel> videoList = [];
  int pageIndex = 1;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: StaggeredGridView.countBuilder(
          padding: EdgeInsets.only(top: 10, left: 10, right: 10),
          itemCount: videoList.length,
          crossAxisCount: 2,
          itemBuilder: (BuildContext context, int index) {
            if (widget.bannerList != null && index == 0) {
              return Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: _banner(),
              );
            } else {
              return VideoCard(videoModel: videoList[index]);
            }
          },
          staggeredTileBuilder: (int index) {
            if (widget.bannerList != null && index == 0) {
              return StaggeredTile.fit(2);
            } else {
              return StaggeredTile.fit(1);
            }
          }),
    );
  }

  _banner() {
    return Padding(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: HiBanner(widget.bannerList ?? List<BannerMo>.empty()),
    );
  }

  Future<void> _loadData({loadMore = false}) async {
    if (!loadMore) {
      pageIndex = 1;
    }
    var currentIndex = pageIndex + (loadMore ? 1 : 0);
    print('loading:currentIndex:$currentIndex');
    try {
      HomeMo result = await HomeDao.get(widget.categoryName,
          pageIndex: currentIndex, pageSize: 10);
      setState(() {
        if (loadMore) {
          if (result.videoList.isNotEmpty) {
            //合成一个新数组
            videoList = [...videoList, ...result.videoList];
            pageIndex++;
          }
        } else {
          videoList = result.videoList;
        }
      });
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      print(e);
      showWarnToast(e.message);
    }
  }

  @override
  bool get wantKeepAlive => true;
}
