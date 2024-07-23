import 'package:flutter/material.dart';
import 'package:mapmapmap/src/list/performance_list.dart';
import 'package:mapmapmap/src/list/performance_newpage.dart';
import 'package:intl/intl.dart';

class PerformanceListNewPage extends StatelessWidget {
  PerformanceListNewPage({Key? key}) : super(key: key);

  PerformanceList performanceLi = new PerformanceList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("이달의 행사"),
        backgroundColor: Colors.grey[500],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getPerformanceList(),
        builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Map<String, dynamic>> performanceList = snapshot.data!;
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
                  child: PerformanceList()
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> getPerformanceList() async {
    final List<Map<String, dynamic>> performanceList = await performanceLi.loadTitleData();
    return performanceList;
  }
}

// board_newpage.dart
