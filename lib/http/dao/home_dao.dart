import 'package:flutter_bili_app/http/core/hi_net.dart';
import 'package:flutter_bili_app/http/request/home_request.dart';
import 'package:flutter_bili_app/model/home_model.dart';

class HomeDao {
  static get(String cagetoryName, {int pageIndex = 1, int pageSize = 1}) async {
    HomeRequest request = HomeRequest();
    request.pathParams = cagetoryName;
    request.add("pageIndex", pageIndex).add("pageSize", pageSize);
    var result = await HiNet.getInstance().fire(request);
    // print(result);
    return HomeModel.fromJson(result['data']);
  }
}
