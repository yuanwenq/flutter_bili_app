import 'package:flutter_bili_app/http/request/base_request.dart';
import 'package:flutter_bili_app/http/request/hi_base_request.dart';

class VideoDetailRequest extends BaseRequest {
  @override
  HttpMethod httpMethod() {
    return HttpMethod.GET;
  }

  @override
  bool needLogin() {
    return true;
  }

  @override
  String path() {
    return "/uapi/fa/detail/";
  }
}
