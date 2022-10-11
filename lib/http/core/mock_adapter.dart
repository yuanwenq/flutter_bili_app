import 'package:flutter_bili_app/http/core/hi_net_adapter.dart';
import 'package:flutter_bili_app/http/request/hi_base_request.dart';

/// 测试适配器，mock数据

class MockAdapter extends HiNetAdapter {
  @override
  Future<HiNetResponse<T>> send<T>(HiBaseRequest request) {
    return Future.delayed(Duration(milliseconds: 1000), () {
      return HiNetResponse(
          request: request,
          data: {"code": 0, "message": "success"} as T,
          statusCode: 403);
    });
  }
}
