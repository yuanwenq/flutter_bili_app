import 'package:flutter_bili_app/http/request/base_request.dart';

class FavoriteRequest extends BaseRequest {
  @override
  HttpMethod httpMethod() {
    return HttpMethod.POST;
  }

  @override
  bool needLogin() {
    return true;
  }

  @override
  String path() {
    return "uapi/fa/favorite";
  }
}
