import 'package:flutter_bili_app/http/core/hi_net.dart';
import 'package:flutter_bili_app/http/request/ranking_request.dart';
import 'package:flutter_bili_app/model/ranking_model.dart';

class RankingDao {
  // https://api.devio.org/uapi/fa/ranking?sort=like&pageIndex=1&pageSize=1
  static get(String sort, {int pageIndex = 1, pageSize = 10}) async {
    RankingRequest request = RankingRequest();
    request
        .add("sort", sort)
        .add("pageIndex", pageIndex)
        .add("pageSize", pageSize);
    var result = await HiNet.getInstance().fire(request);
    print(result);
    return RankingModel.fromJson(result['data']);
  }
}
