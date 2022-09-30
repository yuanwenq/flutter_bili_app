import 'package:flutter/material.dart';
import 'package:flutter_bili_app/model/video_model.dart';

class HomePage extends StatefulWidget {
  final ValueChanged<VideoModel>? onJumpToDetail;
  const HomePage({Key? key, this.onJumpToDetail}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            Text("首页"),
            MaterialButton(
              onPressed: () => widget.onJumpToDetail!(VideoModel(1)),
              child: Text('详情'),
            ),
          ],
        ),
      ),
    );
  }
}
