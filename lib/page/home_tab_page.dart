import 'package:flutter/material.dart';

class HomeTabPage extends StatefulWidget {
  final String name;
  const HomeTabPage({Key? key, required this.name}) : super(key: key);

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(widget.name),
    );
  }
}
