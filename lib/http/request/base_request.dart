import 'package:flutter_bili_app/http/dao/login_dao.dart';
import 'package:flutter_bili_app/http/request/hi_base_request.dart';
import 'package:flutter_bili_app/util/hi_constants.dart';

abstract class BaseRequest extends HiBaseRequest {
  @override
  String url() {
    if (needLogin()) {
      // 给需要登录的接口携带登录令牌
      addHeader(LoginDao.BOARDING_PASS, LoginDao.getBoardingPass());
    }
    return super.url();
  }

  @override
  // ignore: overridden_fields
  Map<String, dynamic> header = {
    HiConstants.authTokenK: HiConstants.authTokenV,
    //访问令牌，在课程公告获取
    HiConstants.courseFlagK: HiConstants.courseFlagV
  };
}
