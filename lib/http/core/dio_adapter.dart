import 'package:dio/dio.dart';
import 'package:flutter_bilibili_app/http/core/hi_error.dart';
import 'package:flutter_bilibili_app/http/core/hi_net_adapter.dart';
import 'package:flutter_bilibili_app/http/request/base_request.dart';

class DioAdapter extends HiNetAdapter {
  @override
  Future<HiNetResponse<T>> send<T>(BaseRequest request) async {
    Response? response;
    var option = Options(headers: request.header);
    var error;
    try {
      var method = request.httpMethod();
      switch (method) {
        case HttpMethod.GET:
          response = await Dio().get(request.url(), options: option);
          break;
        case HttpMethod.POST:
          response = await Dio()
              .post(request.url(), data: request.params, options: option);
          break;
        case HttpMethod.DELETE:
          response = await Dio()
              .delete(request.url(), data: request.params, options: option);
          break;
      }
    } on DioError catch (e) {
      error = e;
      response = e.response;
    } catch (e) {
      error = e;
    }
    if (error != null) {
      var e = HiNetError(response?.statusCode ?? -1, error.toString(),
          data: buildRes(response, request));
      throw e;
    }
    return buildRes(response, request);
  }

  HiNetResponse<T> buildRes<T>(Response? response, BaseRequest request) {
    return HiNetResponse<T>(
        data: response?.data,
        request: request,
        statusCode: response?.statusCode ?? -1,
        statusMessage: response?.statusMessage,
        extra: response);
  }
}
