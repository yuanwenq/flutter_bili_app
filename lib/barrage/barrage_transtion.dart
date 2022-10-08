import 'package:flutter/material.dart';

/// 弹幕移动动效
class BarrageTranstion extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final ValueChanged onComplete;

  const BarrageTranstion(
      {Key? key,
      required this.child,
      required this.duration,
      required this.onComplete})
      : super(key: key);

  @override
  State<BarrageTranstion> createState() => BarrageTranstionState();
}

class BarrageTranstionState extends State<BarrageTranstion>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    // 创建动画控制器
    _animationController =
        AnimationController(duration: widget.duration, vsync: this)
          ..addStatusListener((status) {
            // 动画执行完毕之后的回调
            if (status == AnimationStatus.completed) {
              widget.onComplete('');
            }
          });
    // 定义从右向左的补间动画
    var begin = Offset(1.0, 0);
    var end = Offset(-1.0, 0);
    _animation = Tween(begin: begin, end: end).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(position: _animation, child: widget.child);
  }
}
