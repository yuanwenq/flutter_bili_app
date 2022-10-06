import 'package:flutter_bili_app/http/core/hi_net.dart';
import 'package:flutter_bili_app/http/request/video_detail_request.dart';
import 'package:flutter_bili_app/model/video_detail_model.dart';

/// 详情页DAO
class VideoDetailDao {
  // https://api.devio.org/uapi/fa/detail/BV1VK4y1E7WH
  static get(String vid) async {
    VideoDetailRequest request = VideoDetailRequest();
    request.pathParams = vid;
    var result = await HiNet.getInstance().fire(request);
    print(result);
    return VideoDetailModel.fromJson(result['data']);
  }
}
