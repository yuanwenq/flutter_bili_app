import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bili_app/barrage/barrage_item.dart';
import 'package:flutter_bili_app/barrage/barrage_view_util.dart';
import 'package:flutter_bili_app/barrage/hi_socket.dart';
import 'package:flutter_bili_app/barrage/ibarrage.dart';
import 'package:flutter_bili_app/model/barrage_model.dart';

enum BarrageStatus { play, pause }

/// 弹幕组件
class HiBarrage extends StatefulWidget {
  final int lineCount;
  final String vid;
  final int speed;
  final double top;
  final bool autoPlay;

  const HiBarrage(
      {Key? key,
      this.lineCount = 4,
      required this.vid,
      this.speed = 800,
      this.top = 0,
      this.autoPlay = false})
      : super(key: key);

  @override
  State<HiBarrage> createState() => HiBarrageState();
}

class HiBarrageState extends State<HiBarrage> implements IBarrage {
  late HiSocket _hiSocket;
  late double _height;
  late double _width;
  int _barrageIndex = 0; // 第几条弹幕
  Random _random = Random();
  BarrageStatus? _barrageStatus;
  Timer? _timer;
  List<BarrageItem> _barrageItemList = []; // 弹幕widget集合
  List<BarrageModel> _barrageModelList = []; // 弹幕模型

  @override
  void initState() {
    super.initState();
    _hiSocket = HiSocket();
    _hiSocket.open(widget.vid).listen((value) {
      _handleMessage(value);
    });
  }

  @override
  void dispose() {
    if (_hiSocket != null) {
      _hiSocket.close();
    }
    if (_timer != null) {
      _timer?.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = _width / 16 * 9;
    return SizedBox(
      width: _width,
      height: _height,
      child: Stack(
        children: [
          // 防止Stack的child为空
          Container()
        ]..addAll(_barrageItemList),
      ),
    );
  }

  /// 处理消息，instant = true 马上发送
  void _handleMessage(List<BarrageModel> modelList, {bool instant = false}) {
    if (instant) {
      // 插入数组的第一个位置，优先显示
      _barrageModelList.insertAll(0, modelList);
    } else {
      // 添加到数组中
      _barrageModelList.addAll(modelList);
    }
    // 收到新的弹幕后播放
    if (_barrageStatus == BarrageStatus.play) {
      play();
      return;
    }
    // 收到新的弹幕后播放
    if (widget.autoPlay && _barrageStatus != BarrageStatus.pause) {
      play();
    }
  }

  void play() {
    _barrageStatus = BarrageStatus.play;
    print('action: play');
    if (_timer != null && _timer!.isActive) return;
    // 每间隔一段时间发一次弹幕
    _timer = Timer.periodic(Duration(milliseconds: widget.speed), (timer) {
      if (_barrageModelList.isNotEmpty) {
        // 将发送的弹幕将集合中剔除
        var temp = _barrageModelList.removeAt(0);
        addBarrage(temp);
        print('start: ${temp.content}');
      } else {
        print("All barrage are sent");
        // 弹幕发送完毕后关闭定时器
        _timer?.cancel();
      }
    });
  }

  void addBarrage(BarrageModel model) {
    double perRowHeight = 30;
    var line = _barrageIndex % widget.lineCount;
    _barrageIndex++;
    var top = line * perRowHeight + widget.top;
    // 为每一条弹幕生成一个id
    String id = '${_random.nextInt(10000)} : ${model.content}';
    var item = BarrageItem(
        id: id,
        top: top,
        child: BarrageViewUtil.barrageView(model),
        onComplete: _onComplete);
    _barrageItemList.add(item);
    setState(() {});
  }

  @override
  void pause() {
    _barrageStatus = BarrageStatus.pause;
    //
    _barrageItemList.clear();
    // 刷新屏幕状态
    setState(() {});
    print("action: pause");
    _timer?.cancel();
  }

  @override
  void send(String message) {
    _hiSocket.send(message);
    _handleMessage(
        [BarrageModel(content: message, vid: '-1', priority: 1, type: 1)]);
  }

  void _onComplete(id) {
    print("Done: $id");
    _barrageItemList.removeWhere((element) => element.id == id);
  }
}
