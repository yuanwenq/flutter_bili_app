import 'package:flutter_bili_app/http/request/base_request.dart';
import 'package:flutter_bili_app/http/request/hi_base_request.dart';

class LoginRequest extends BaseRequest {
  @override
  HttpMethod httpMethod() {
    return HttpMethod.POST;
  }

  @override
  bool needLogin() {
    return false;
  }

  @override
  String path() {
    return "/uapi/user/login";
  }
}
