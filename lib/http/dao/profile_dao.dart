import 'package:flutter_bili_app/http/core/hi_net.dart';
import 'package:flutter_bili_app/http/request/profile_request.dart';
import 'package:flutter_bili_app/model/profile_model.dart';

class ProfileDao {
  // https://api.devio.org/uapi/fa/profile
  static get() async {
    ProfileRequest request = ProfileRequest();
    var result = await HiNet.getInstance().fire(request);
    print(result);
    return ProfileModel.fromJson(result['data']);
  }
}
