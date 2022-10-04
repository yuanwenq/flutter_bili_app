import 'package:flutter_bili_app/model/video_model.dart';

class HomeModel {
  List<BannerModel>? bannerList;
  List<CategoryModel>? categoryList;
  late List<VideoModel> videoList;

  HomeModel({this.bannerList, this.categoryList, required this.videoList});

  HomeModel.fromJson(Map<String, dynamic> json) {
    if (json['bannerList'] != null) {
      bannerList = List<BannerModel>.empty(growable: true);
      json['bannerList'].forEach((v) {
        bannerList!.add(BannerModel.fromJson(v));
      });
    }
    if (json['categoryList'] != null) {
      categoryList = List<CategoryModel>.empty(growable: true);
      json['categoryList'].forEach((v) {
        categoryList!.add(CategoryModel.fromJson(v));
      });
    }
    if (json['videoList'] != null) {
      videoList = List<VideoModel>.empty(growable: true);
      json['videoList'].forEach((v) {
        videoList.add(VideoModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (bannerList != null) {
      data['bannerList'] = bannerList!.map((v) => v.toJson()).toList();
    }
    if (categoryList != null) {
      data['categoryList'] = categoryList!.map((v) => v.toJson()).toList();
    }
    if (videoList != null) {
      data['videoList'] = videoList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BannerModel {
  late String id;
  late int sticky;
  late String type;
  late String title;
  late String subtitle;
  late String url;
  late String cover;
  late String createTime;

  BannerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sticky = json['sticky'];
    type = json['type'];
    title = json['title'];
    subtitle = json['subtitle'];
    url = json['url'];
    cover = json['cover'];
    createTime = json['createTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['sticky'] = sticky;
    data['type'] = type;
    data['title'] = title;
    data['subtitle'] = subtitle;
    data['url'] = url;
    data['cover'] = cover;
    data['createTime'] = createTime;
    return data;
  }
}

class CategoryModel {
  late String name;
  late int count;

  CategoryModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = name;
    data['count'] = count;
    return data;
  }
}
