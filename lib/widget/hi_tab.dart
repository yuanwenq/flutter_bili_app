import 'package:flutter/material.dart';
import 'package:flutter_bili_app/util/color.dart';
import 'package:underline_indicator/underline_indicator.dart';

// 顶部tab切换组件
class HiTab extends StatelessWidget {
  final List<Widget> tabs;
  final TabController? controller;
  final double? fontSize;
  final double? borderWidth;
  final double? insets;
  final Color? unselectedLabelColor;

  const HiTab(this.tabs,
      {Key? key,
      this.controller,
      this.fontSize = 13,
      this.borderWidth = 2,
      this.insets = 15,
      this.unselectedLabelColor = Colors.grey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBar(
        controller: controller,
        isScrollable: true,
        labelColor: primary,
        unselectedLabelColor: unselectedLabelColor,
        labelStyle: TextStyle(
          fontSize: fontSize,
        ),
        indicator: UnderlineIndicator(
            strokeCap: StrokeCap.square,
            borderSide: BorderSide(color: primary, width: borderWidth!),
            insets: EdgeInsets.only(left: insets!, right: insets!)),
        tabs: tabs);
  }
}
