import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bili_app/barrage/barrage_input.dart';
import 'package:flutter_bili_app/barrage/barrage_switch.dart';
import 'package:flutter_bili_app/barrage/hi_barrage.dart';
import 'package:flutter_bili_app/http/core/hi_error.dart';
import 'package:flutter_bili_app/http/dao/favorite_dao.dart';
import 'package:flutter_bili_app/http/dao/video_detail_dao.dart';
import 'package:flutter_bili_app/model/video_detail_model.dart';
import 'package:flutter_bili_app/model/video_model.dart';
import 'package:flutter_bili_app/provider/theme_provider.dart';
import 'package:flutter_bili_app/util/toast_util.dart';
import 'package:flutter_bili_app/util/view_util.dart';
import 'package:flutter_bili_app/widget/appbar_widget.dart';
import 'package:flutter_bili_app/widget/expandable_content.dart';
import 'package:flutter_bili_app/widget/hi_tab.dart';
import 'package:flutter_bili_app/widget/navigation_bar.dart';
import 'package:flutter_bili_app/widget/video_header.dart';
import 'package:flutter_bili_app/widget/video_large_card.dart';
import 'package:flutter_bili_app/widget/video_tool_bar.dart';
import 'package:flutter_bili_app/widget/video_view.dart';
import 'package:flutter_overlay/flutter_overlay.dart';
import 'package:provider/provider.dart';

class VideoDetailPage extends StatefulWidget {
  final VideoModel videoModel;
  const VideoDetailPage(this.videoModel, {Key? key}) : super(key: key);

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage>
    with TickerProviderStateMixin {
  late TabController _controller;
  List tabs = ["简介", "评论2888"];
  VideoDetailModel? videoDetailModel;
  VideoModel? videoModel;
  List<VideoModel> videoList = [];
  var _barrageKey = GlobalKey<HiBarrageState>();
  bool _inoutShowing = false;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: tabs.length, vsync: this);
    videoModel = widget.videoModel;
    _loadDetail();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MediaQuery.removePadding(
            removeTop: Platform.isIOS,
            context: context,
            child: videoModel?.url != null
                ? Column(
                    children: [
                      NavigationBarPlus(
                        color: Colors.black,
                        statusStyle: StatusStyle.LIGHT_CONTENT,
                        height: Platform.isAndroid ? 0 : 46,
                      ),
                      _buildVideoView(),
                      _buildTabNavigation(context),
                      Flexible(
                          child: TabBarView(
                        controller: _controller,
                        children: [
                          _buildDetailList(),
                          Container(
                            child: Text("敬请期待..."),
                          )
                        ],
                      ))
                    ],
                  )
                : Container()));
  }

  _buildVideoView() {
    var model = videoModel;
    return VideoView(
      model!.url!,
      cover: model.cover,
      overlayUI: videoAppBar(),
      barrageUI: HiBarrage(
        key: _barrageKey,
        vid: model.vid,
        autoPlay: true,
      ),
    );
  }

  _buildTabNavigation(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    Color? color =
        themeProvider.isDark() ? Colors.transparent : Colors.grey[100];
    // 使用 Material 实现阴影效果
    return Material(
      elevation: 5,
      shadowColor: color,
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 10, right: 10),
        height: 39,
        // color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_tabBar(), _buildBarrageBtn()],
        ),
      ),
    );
  }

  _tabBar() {
    return HiTab(
      tabs.map<Tab>((name) {
        return Tab(
          text: name,
        );
      }).toList(),
      controller: _controller,
    );
  }

  _buildDetailList() {
    return ListView(
      padding: EdgeInsets.all(0),
      children: [...buildContents(), ..._buildVideoList()],
    );
  }

  buildContents() {
    return [
      VideoHeader(
        owner: videoModel!.owner,
      ),
      ExpandableContent(mo: videoModel!),
      VideoToolBar(
        detailModel: videoDetailModel,
        videoModel: videoModel!,
        onLike: _doLike,
        onUnLike: _onUnLike,
        onFavorite: _onFavorite,
      )
    ];
  }

  void _loadDetail() async {
    try {
      VideoDetailModel result = await VideoDetailDao.get(videoModel!.vid);
      setState(() {
        videoDetailModel = result;
        // print('------videoInfo-----:${result.videoInfo.owner.name}');
        videoModel = result.videoInfo;
        videoList = result.videoList;
      });
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      print(e);
    }
  }

  void _doLike() {}

  void _onUnLike() {}
  // 收藏
  void _onFavorite() async {
    try {
      var result = await FavoriteDao.favorite(
          videoModel!.vid, !videoDetailModel!.isFavorite);
      print(result);
      videoDetailModel!.isFavorite = !videoDetailModel!.isFavorite;
      if (videoDetailModel!.isFavorite) {
        videoModel!.favorite += 1;
      } else {
        videoModel!.favorite -= 1;
      }
      setState(() {
        videoDetailModel = videoDetailModel;
        videoModel = videoModel;
      });
      showToast(result['msg']);
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      print(e);
    }
  }

  _buildVideoList() {
    return videoList.map((VideoModel mo) => VideoLargeCard(videoModel: mo));
  }

  _buildBarrageBtn() {
    return BarrageSwitch(
        inoutShowing: _inoutShowing,
        onShowInput: () {
          setState(() {
            _inoutShowing = true;
          });
          HiOverlay.show(context, child: BarrageInput(onTabClose: () {
            setState(() {
              _inoutShowing = false;
            });
          })).then((value) {
            print("---input: $value");
            _barrageKey.currentState!.send(value!);
          });
        },
        onBarrageSwitch: (open) {
          if (open) {
            _barrageKey.currentState!.play();
          } else {
            _barrageKey.currentState!.pause();
          }
        });
  }
}
