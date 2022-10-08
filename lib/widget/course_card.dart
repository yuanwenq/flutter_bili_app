import 'package:flutter/material.dart';
import 'package:flutter_bili_app/model/profile_model.dart';
import 'package:flutter_bili_app/navigator/hi_navigator.dart';
import 'package:flutter_bili_app/util/view_util.dart';

/// 职场进阶
class CourseCard extends StatelessWidget {
  final List<Course> courseList;

  const CourseCard({Key? key, required this.courseList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 5, top: 5),
      child: Column(
        children: [_buildTitle(), ..._buildCardList(context)],
      ),
    );
  }

  _buildTitle() {
    return Container(
      padding: EdgeInsets.only(bottom: 10, top: 10),
      child: Row(
        children: [
          Text(
            '职场进阶',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            '   带你突破技术瓶颈',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          )
        ],
      ),
    );
  }

  /// 动态布局
  _buildCardList(BuildContext context) {
    var courseGroup = Map();
    // 将课程进行分组
    courseList.forEach((mo) {
      if (!courseGroup.containsKey(mo.group)) {
        courseGroup[mo.group] = [];
      }
      List list = courseGroup[mo.group];
      list.add(mo);
    });
    return courseGroup.entries.map((e) {
      List list = e.value;
      // 根据卡片数据计算出每个卡片的宽度
      var width =
          (MediaQuery.of(context).size.width - 20 - (list.length - 1) * 5) /
              list.length;
      var height = width / 16 * 6;
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [...list.map((mo) => _buildCard(mo, width, height)).toList()],
      );
    });
  }

  _buildCard(Course mo, double width, double height) {
    return InkWell(
      onTap: () {
        print(mo.url);
        HiNavigator.getInstance().openH5(mo.url);
      },
      child: Padding(
        padding: EdgeInsets.only(right: 5, bottom: 7),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: cachedImage(mo.cover, width: width, height: height),
        ),
      ),
    );
  }
}
