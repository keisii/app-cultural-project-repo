import 'dart:convert';

import 'package:intl/intl.dart';

Board boardFromJson(String str) => Board.fromJson(json.decode(str));

String boardToJson(Board data) => json.encode(data.toJson());

class Board {
  String title;
  String content;
  DateTime createAt;
  DateTime updateAt;

  Board({
    required this.title,
    required this.content,
    required this.createAt,
    required this.updateAt,
  });

  factory Board.fromJson(Map<String, dynamic> json) {

    DateFormat format = DateFormat("yyyy-MM-dd");

    String createAtString = json["createAt"];
    DateTime createAtDateTime = format.parse(createAtString);

    String updateAtString = json["updateAt"];
    DateTime updateAtDateTime = format.parse(updateAtString);

    return Board(
      title: json["title"],
      content: json["content"],
      createAt: createAtDateTime,
      updateAt: updateAtDateTime,
    );
  }

  Map<String, dynamic> toJson() => {
    "title": title,
    "content": content,
    "createAt": "${createAt.year.toString().padLeft(4, '0')}-${createAt.month.toString().padLeft(2, '0')}-${createAt.day.toString().padLeft(2, '0')}",
    "updateAt": updateAt != null ? "${updateAt!.year.toString().padLeft(4, '0')}-${updateAt!.month.toString().padLeft(2, '0')}-${updateAt!.day.toString().padLeft(2, '0')}" : null,
  };

// board의 자료형을 Map<String, dynamic>으로 변환
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'createAt': createAt,
      'updateAt' : updateAt
    };
  }

  Map<String, dynamic> titleAndCreateAtToJson() {
    return {
      'title': title,
      'createAt': createAt,
      // Add other properties if needed
    };
  }



} // board.dart // model폴더에 넣고 사용