import 'package:flutter/material.dart';
import 'package:flutter_bilibili_app/core/hi_state.dart';
import 'package:flutter_bilibili_app/http/core/hi_error.dart';
import 'package:flutter_bilibili_app/http/dao/home_dao.dart';
import 'package:flutter_bilibili_app/model/home_mo.dart';
import 'package:flutter_bilibili_app/navigator/hi_navigator.dart';
import 'package:flutter_bilibili_app/page/home_tab_page.dart';
import 'package:flutter_bilibili_app/util/color.dart';
import 'package:flutter_bilibili_app/util/toast_util.dart';
import 'package:flutter_bilibili_app/util/view_util.dart';
import 'package:flutter_bilibili_app/widget/hi_tab.dart';
import 'package:flutter_bilibili_app/widget/loading_container.dart';
import 'package:flutter_bilibili_app/widget/navigation_bar.dart';
import 'package:underline_indicator/underline_indicator.dart';

class HomePage extends StatefulWidget {
  final ValueChanged<int>? onJumpTo;

  const HomePage({Key? key, this.onJumpTo}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends HiState<HomePage>
    with
        AutomaticKeepAliveClientMixin,
        TickerProviderStateMixin,
        WidgetsBindingObserver {
  var _listener;
  late TabController _tabController;
  List<CategoryMo> categoryList = [];
  List<BannerMo> bannerList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    _tabController = TabController(length: categoryList.length, vsync: this);
    HiNavigator.getInstance().addListener(this._listener = (current, pre) {
      print('home:current:${current.page}');
      print('home:pre:${pre.page}');
      if (widget == current.page || current.page is HomePage) {
        print('打开了首页:onResume');
      } else if (widget == pre?.page || pre?.page is HomePage) {
        print('首页:onPause');
      }
    });
    loadData();
  }

  @override
  void dispose() {
    HiNavigator.getInstance().removeListener(this._listener);
    WidgetsBinding.instance?.removeObserver(this);
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive: // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
        break;
      case AppLifecycleState.resumed: //从后台切换前台，界面可见
        //fix Android压后台首页状态栏字体颜色变白，详情页状态栏字体变黑问题
        changeStatusBar();
        break;
      case AppLifecycleState.paused: // 界面不可见，后台
        break;
      case AppLifecycleState.detached: // APP结束时调用
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: LoadingContainer(
          isLoading: _isLoading,
          child: Column(
            children: [
              NavigationBar(
                height: 50,
                child: _appBar(),
                color: Colors.white,
              ),
              Container(
                color: Colors.white,
                child: _tabBar(),
              ),
              Flexible(
                  child: TabBarView(
                      controller: _tabController,
                      children: categoryList
                          .map((e) => HomeTabPage(
                                categoryName: e.name,
                                bannerList: e.name == '推荐' ? bannerList : null,
                              ))
                          .toList()))
            ],
          )),
    );
  }

  _tabBar() {
    return HiTab(
      categoryList.map<Tab>((tab) {
        return Tab(
          text: tab.name,
        );
      }).toList(),
      controller: _tabController,
      fontSize: 16,
      borderWidth: 3,
      unselectedLabelColor: Colors.black54,
      insets: 13,
    );
  }

  @override
  bool get wantKeepAlive => true;

  void loadData() async {
    try {
      HomeMo result = await HomeDao.get('推荐');
      print('loadData():$result');
      if (result.categoryList != null) {
        //tab长度变化后需要重新创建TabController
        _tabController = TabController(
            length: result.categoryList?.length ?? 0, vsync: this);
      }
      setState(() {
        categoryList = result.categoryList ?? [];
        bannerList = result.bannerList ?? [];
      });
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      print(e);
      showWarnToast(e.message);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  _appBar() {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              widget.onJumpTo?.call(3);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(23),
              child: Image(
                height: 46,
                width: 46,
                image: AssetImage("images/avatar.png"),
              ),
            ),
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: EdgeInsets.only(left: 10),
                height: 32,
                alignment: Alignment.centerLeft,
                child: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                decoration: BoxDecoration(color: Colors.grey[100]),
              ),
            ),
          )),
          Icon(
            Icons.explore_outlined,
            color: Colors.grey,
          ),
          Padding(
            padding: EdgeInsets.only(left: 12),
            child: Icon(
              Icons.mail_outline,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
