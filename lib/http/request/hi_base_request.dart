enum HttpMethod { GET, POST, DELETE }

abstract class HiBaseRequest {
  var pathParams;
  var useHttps = true;
  String authority() {
    return "api.devio.org";
  }

  HttpMethod httpMethod();
  String path();
  String url() {
    Uri uri;
    var pathStr = path();
    // 拼接path参数
    if (pathParams != null) {
      if (path().endsWith("/")) {
        pathStr = "${path()}$pathParams";
      } else {
        pathStr = "${path()}/$pathParams";
      }
    }
    // http 和 https 切换
    if (useHttps) {
      uri = Uri.https(authority(), pathStr, params);
    } else {
      uri = Uri.http(authority(), pathStr, params);
    }
    print('url:${uri.toString()}');
    return uri.toString();
  }

  bool needLogin();

  /// 可填写公共参数
  Map<String, String> params = Map();

  /// 添加参数
  HiBaseRequest add(String k, Object v) {
    params[k] = v.toString();
    return this;
  }

  /// 填写 header 公共信息
  Map<String, dynamic> header = {};

  /// 添加header
  HiBaseRequest addHeader(String k, Object v) {
    header[k] = v.toString();
    return this;
  }
}
