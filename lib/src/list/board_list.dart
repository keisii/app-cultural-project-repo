import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mapmapmap/src/list/board_newpage.dart';
import 'package:mapmapmap/src/model/board.dart';

class BoardList extends StatelessWidget {
  BoardList({Key? key}) : super(key: key);

  DateTime tenDaysAgo = DateTime.now().subtract(Duration(days: 10));

  Future<List<Board>> findAll() async {
    try {
      final url = Uri.parse(
          "http://192.168.100.221:9000/board-service/list"); // 각자 본인 컴퓨터의 localhost로 설정
      print(url);

      final response = await http.get(url);
      print(response.body);

      if (response.statusCode == 200) {
        List<Board> boardList = [];
        var jsonBody = jsonDecode(response.body);

        var jsonResult = jsonBody["result"];

        for (var jsonBoard in jsonResult) {
          if (jsonBoard != null) {
            Board board = Board.fromJson(jsonBoard);
            boardList.add(board);
          }
        }
        print(boardList);

        return boardList;
      } else {
        throw Exception('에러 : ${response.statusCode}');
      }
    } catch (e) {
      print('$e');
      throw Exception("공지사항 가져오기 실패");
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Board>>(
        future: findAll(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Board> dataList = snapshot.data!;
            return Padding(
              padding: EdgeInsets.fromLTRB(0,0,0,20),
              child: ListView.builder(
                itemExtent: 50, // 각 ListTile의 높이
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  Board item = dataList[index];
                  return ListTile(
                    contentPadding: EdgeInsets.fromLTRB(10, 0, 16, 0),
                    // 내용 주위 여백 조정, B:title-subtitle간격!
                    // 기본값 EdgeInsets.fromLTRB(16, 8, 16, 8),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                  Expanded(
                  child: item.createAt != null && item.createAt.isAfter(tenDaysAgo)
                  ? Icon(Icons.fiber_new_outlined, color: Colors.red)
                      : SizedBox(),
                  ),
                        SizedBox(width: 25,),
                        Container(
                          width: 265, // 원하는 최대 너비로 지정
                          child: Text(
                            item.title,
                            overflow: TextOverflow.clip, // 일정 길이 이상의 텍스트는 자르고 숨김
                          ),
                        ),
                        Text(
                          DateFormat('yyyy-MM-dd').format(item.createAt),
                          style: TextStyle(fontSize: 13), // 원하는 스타일 설정
                        ),
                      ],
                    ),
                    onTap: () {
                      // 클릭된 리스트 타일에 대한 동작 처리
                      print('Clicked item: ${item.title}');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BoardNewPage(board: item),
                        ),
                      );
                      // 원하는 동작을 여기에 추가
                    },
                  );
                },
              ),
            );
          } else if (snapshot.hasError) {
            return Text("Error"); // 데이터 로딩 중 오류가 발생한 경우 오류 메시지 출력
          } else {
            return CircularProgressIndicator(); // 데이터 로딩 중일 때 로딩 표시기 표시
          }
        },
      ),
    );
  }
}

// board_list.dart