import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mapmapmap/src/model/board.dart';

class BoardNewPage extends StatelessWidget {
  final Board board;

  BoardNewPage({required this.board});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("공지사항"),
        backgroundColor: Colors.grey[500],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${board.title}",
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${DateFormat('yyyy-MM-dd').format(board.createAt)}",
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(width: 8),
                Container(
                  width: 1, // 세로선의 너비
                  height: 20, // 세로선의 높이
                  color: Colors.grey, // 세로선의 색상
                ),
                SizedBox(width: 8),
                Text(
                  "${DateFormat('yyyy-MM-dd').format(board.updateAt)}",
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),

            Divider(
              height: 24, // 가로선의 높이
              thickness: 3, // 가로선의 두께
            ),
            SizedBox(height: 8),
            Text(
              "${board.content}",
              style: TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}

// board_newpage.dart
