import 'package:flutter/material.dart';
import 'package:mapmapmap/src/getx/board_detail.dart';

class BoardMain extends StatefulWidget {
  const BoardMain({super.key});

  @override
  State<BoardMain> createState() => _BoardMainState();
}

class _BoardMainState extends State<BoardMain> {

  DataSourceBoard dataSource=DataSourceBoard();

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
