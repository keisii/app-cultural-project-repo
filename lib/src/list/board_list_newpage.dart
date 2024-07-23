import 'package:flutter/material.dart';
import 'package:mapmapmap/src/list/board_list.dart';
import 'package:mapmapmap/src/list/board_newpage.dart';
import 'package:mapmapmap/src/model/board.dart';
import 'package:intl/intl.dart';

class BoardListNewPage extends StatelessWidget {
  BoardListNewPage({Key? key}) : super(key: key);

  BoardList boardLi = new BoardList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("공지사항"),
        backgroundColor: Colors.grey[500],
      ),
      body: FutureBuilder<List<Board>>(
        future: getBoardList(),
        builder: (BuildContext context, AsyncSnapshot<List<Board>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Board> boardList = snapshot.data!;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    color: Colors.grey[300],
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 18, 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 270,
                            alignment: Alignment.center,
                            child: Text(
                              "제목",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 20,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 10,),
                          Text(
                            "작성일",
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: BoardList()
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Future<List<Board>> getBoardList() async {
    final List<Board> boardList = await boardLi.findAll();
    return boardList;
  }

}

// board_newpage.dart
