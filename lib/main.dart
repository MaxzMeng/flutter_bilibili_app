import 'package:flutter/material.dart';
import 'package:flutter_bilibili_app/model/video_model.dart';
import 'package:flutter_bilibili_app/page/home_page.dart';
import 'package:flutter_bilibili_app/page/video_detail_page.dart';

void main() {
  runApp(BiliBiliApp());
}

class BiliBiliApp extends StatefulWidget {
  const BiliBiliApp({Key? key}) : super(key: key);

  @override
  _BiliBiliAppState createState() => _BiliBiliAppState();
}

class _BiliBiliAppState extends State<BiliBiliApp> {
  BilibiliRouteDelegate _routeDelegate = BilibiliRouteDelegate();
  BilibiliRouteInformationParser _routeInformationParser =
      BilibiliRouteInformationParser();

  @override
  Widget build(BuildContext context) {
    var widget = Router(
      routerDelegate: _routeDelegate,
      routeInformationParser: _routeInformationParser,
      routeInformationProvider: PlatformRouteInformationProvider(
          initialRouteInformation: RouteInformation(location: "/")),
    );

    return MaterialApp(
      home: widget,
    );
  }
}

class BilibiliRouteDelegate extends RouterDelegate<BilibiliRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> navigatorKey;

  BilibiliRouteDelegate() : navigatorKey = GlobalKey<NavigatorState>();
  BilibiliRoutePath? path;
  List<MaterialPage> pages = [];
  VideoModel? videoModel;

  @override
  Widget build(BuildContext context) {
    pages = [
      pageWrap(HomePage(
        onJumpToDetail: (videoModel) {
          this.videoModel = videoModel;
          notifyListeners();
        },
      )),
      if (videoModel != null) pageWrap(VideoDetailPage(videoModel!))
    ];

    return Navigator(
      key: navigatorKey,
      pages: pages,
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(BilibiliRoutePath configuration) async {
    this.path = currentConfiguration;
  }
}

class BilibiliRouteInformationParser
    extends RouteInformationParser<BilibiliRoutePath> {
  @override
  Future<BilibiliRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location ?? "");
    print('uri:$uri');
    if (uri.pathSegments.length == 0) {
      return BilibiliRoutePath.home();
    }
    return BilibiliRoutePath.detail();
  }
}

class BilibiliRoutePath {
  final String _location;

  BilibiliRoutePath.home() : _location = "/";

  BilibiliRoutePath.detail() : _location = "detail";
}

pageWrap(Widget child) {
  return MaterialPage(key: ValueKey(child.hashCode), child: child);
}
