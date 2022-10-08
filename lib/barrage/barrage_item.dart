import 'package:flutter/material.dart';
import 'package:flutter_bili_app/barrage/barrage_transtion.dart';

// 弹幕widget
class BarrageItem extends StatelessWidget {
  final String id;
  final double top;
  final Widget child;
  final ValueChanged onComplete;
  final Duration duration;

  BarrageItem(
      {Key? key,
      required this.id,
      required this.top,
      required this.child,
      required this.onComplete,
      this.duration = const Duration(milliseconds: 9000)})
      : super(key: key);

  // fix 动画状态错乱
  var _key = GlobalKey<BarrageTranstionState>();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
        top: top,
        child: BarrageTranstion(
          key: _key,
          child: child,
          onComplete: (v) {
            onComplete(id);
          },
          duration: duration,
        ));
  }
}
