import 'dart:convert';

import 'package:flutter_bilibili_app/http/core/hi_error.dart';
import 'package:flutter_bilibili_app/http/core/hi_net_adapter.dart';
import 'package:flutter_bilibili_app/http/request/base_request.dart';
import 'package:http/http.dart' as http;

class HttpAdapter extends HiNetAdapter {
  var _client = http.Client();

  @override
  Future<HiNetResponse<String>> send<String>(BaseRequest request) async {
    var url = Uri.parse(request.url());
    http.Response? response;
    var option =
        request.header.map((key, value) => MapEntry(key, value.toString()));
    var error;
    try {
      var method = request.httpMethod();
      switch (method) {
        case HttpMethod.GET:
          response = await _client.get(url, headers: option);
          break;
        case HttpMethod.POST:
          response =
              await _client.post(url, body: request.params, headers: option);
          break;
        case HttpMethod.DELETE:
          response =
              await _client.delete(url, body: request.params, headers: option);
          break;
      }
    } catch (e) {
      error = e;
    } finally {
      _client.close();
    }
    if (error != null) {
      var e = HiNetError(response?.statusCode ?? -1, error.toString(),
          data: buildRes(response, request));
      throw e;
    }
    return buildRes(response, request);
  }

  HiNetResponse<Map> buildRes<Map>(
      http.Response? response, BaseRequest request) {
    return HiNetResponse<Map>(
        data: jsonDecode(response?.body??""),
        request: request,
        statusCode: response?.statusCode ?? -1,
        statusMessage: response?.reasonPhrase,
        extra: response);
  }
}
