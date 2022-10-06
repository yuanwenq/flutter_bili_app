import 'package:flutter_bili_app/model/video_model.dart';

class RankingModel {
  late int total;
  late List<VideoModel> list;

  RankingModel({required this.total, required this.list});

  RankingModel.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    if (json['list'] != null) {
      list = List<VideoModel>.empty(growable: true);
      json['list'].forEach((v) {
        list.add(VideoModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
