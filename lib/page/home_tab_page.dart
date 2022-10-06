import 'package:flutter/material.dart';
import 'package:flutter_bili_app/http/dao/home_dao.dart';
import 'package:flutter_bili_app/model/home_model.dart';
import 'package:flutter_bili_app/model/video_model.dart';
import 'package:flutter_bili_app/util/hi_banner.dart';
import 'package:flutter_bili_app/widget/video_card.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_bili_app/http/core/hi_base_tab_state.dart';

class HomeTabPage extends StatefulWidget {
  final String categoryName;
  final List<BannerModel>? bannerList;
  const HomeTabPage({Key? key, required this.categoryName, this.bannerList})
      : super(key: key);

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState
    extends HiBaseTabState<HomeModel, VideoModel, HomeTabPage> {
  @override
  void initState() {
    super.initState();
    print(widget.categoryName);
    print(widget.bannerList);
  }

  _banner() {
    return Padding(
      padding: EdgeInsets.only(left: 0, right: 0),
      child: HiBanner(widget.bannerList!),
    );
  }

  @override
  // TODO: implement contentChild
  get contentChild => SingleChildScrollView(
        controller: scrollController,
        padding: EdgeInsets.only(left: 10, top: 10, right: 10),
        physics: const AlwaysScrollableScrollPhysics(),
        child: StaggeredGrid.count(
          crossAxisCount: 2,
          axisDirection: AxisDirection.down,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          children: [
            if (widget.bannerList != null)
              StaggeredGridTile.fit(crossAxisCellCount: 2, child: _banner()),
            ...dataList.map((VideoModel videoModel) {
              return StaggeredGridTile.fit(
                  crossAxisCellCount: 1,
                  child: VideoCard(
                    videoMo: videoModel,
                  ));
            })
          ],
        ),
      );

  @override
  Future<HomeModel> getData(int pageIndex) async {
    HomeModel result = await HomeDao.get(widget.categoryName,
        pageIndex: pageIndex, pageSize: 10);
    return result;
  }

  @override
  List<VideoModel> parseList(HomeModel result) {
    return result.videoList;
  }
}
