import 'package:flutter/material.dart';
import 'package:flutter_bili_app/http/core/hi_error.dart';
import 'package:flutter_bili_app/http/dao/home_dao.dart';
import 'package:flutter_bili_app/model/home_model.dart';
import 'package:flutter_bili_app/model/video_model.dart';
import 'package:flutter_bili_app/util/color.dart';
import 'package:flutter_bili_app/util/hi_banner.dart';
import 'package:flutter_bili_app/util/toast_util.dart';
import 'package:flutter_bili_app/widget/video_card.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomeTabPage extends StatefulWidget {
  final String categoryName;
  final List<BannerModel>? bannerList;
  const HomeTabPage({Key? key, required this.categoryName, this.bannerList})
      : super(key: key);

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage>
    with AutomaticKeepAliveClientMixin {
  List<VideoModel> videoList = [];
  int pageIndex = 1;
  bool _loading = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      var dis = _scrollController.position.maxScrollExtent -
          _scrollController.position.pixels;
      print('dis:${dis}');
      if (dis < 300 && !_loading) {
        print("--------loading-----");
        ;
        _loadData(loadMore: true);
      }
    });
    _loadData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
        onRefresh: _loadData,
        color: primary,
        child: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: Container(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: EdgeInsets.only(left: 10, top: 10, right: 10),
              physics: const AlwaysScrollableScrollPhysics(),
              child: StaggeredGrid.count(
                crossAxisCount: 2,
                axisDirection: AxisDirection.down,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                children: [
                  if (widget.bannerList != null)
                    StaggeredGridTile.fit(
                        crossAxisCellCount: 2, child: _banner()),
                  ...videoList.map((VideoModel videoModel) {
                    return StaggeredGridTile.fit(
                        crossAxisCellCount: 1,
                        child: VideoCard(
                          videoMo: videoModel,
                        ));
                  })
                ],
              ),
            ),
          ),
        ));
  }

  _banner() {
    return Padding(
      padding: EdgeInsets.only(left: 0, right: 0),
      child: HiBanner(widget.bannerList!),
    );
  }

  Future<void> _loadData({loadMore = false}) async {
    _loading = true;
    if (!loadMore) {
      pageIndex = 1;
    }
    var currentIndex = pageIndex + (loadMore ? 1 : 0);
    print("loading:currentIndex:$currentIndex");
    try {
      HomeModel result = await HomeDao.get(widget.categoryName,
          pageIndex: currentIndex, pageSize: 10);
      setState(() {
        if (loadMore) {
          if (result.videoList.isNotEmpty) {
            // 合成一个新数组
            videoList = [...videoList, ...result.videoList];
            pageIndex++;
          }
        } else {
          videoList = result.videoList;
        }
      });
      Future.delayed(Duration(milliseconds: 1000), () {
        _loading = false;
      });
    } on NeedAuth catch (e) {
      _loading = false;
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      _loading = false;
      print(e);
      showWarnToast(e.message);
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
