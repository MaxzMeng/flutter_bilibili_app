import 'package:flutter_bilibili_app/http/request/base_request.dart';

import 'hi_net_adapter.dart';

///测试适配器，mock数据
class MockAdapter extends HiNetAdapter {
  @override
  Future<HiNetResponse<Map>> send<Map>(BaseRequest request) {
    return Future<HiNetResponse<Map>>.delayed(Duration(milliseconds: 1000), () {
      return HiNetResponse(
          data: {"code": 0, "message": "success."},
          statusCode: 200) as HiNetResponse<Map>;
    });
  }
}
