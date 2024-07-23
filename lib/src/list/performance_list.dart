import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mapmapmap/src/list/performance_newpage.dart';
import 'package:xml2json/xml2json.dart';

class PerformanceList extends StatelessWidget{

  PerformanceList({Key? key}) : super(key: key);

  Future<List<Map<String, dynamic>>> loadTitleData() async {
    try{
      DateTime dateTime=DateTime.now();
      String searchYear=dateTime.year.toString();
      String searchMonth=dateTime.month.toString();

      String url = "http://www.cha.go.kr/cha/openapi/selectEventListOpenapi.do?searchYear=${searchYear}&searchMonth=${searchMonth}";

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
      );
      final getXmlData = response.body;
      final Xml2JsonData = Xml2Json()..parse(getXmlData);
      final jsonData = Xml2JsonData.toParker();

      Map<String, dynamic> data = jsonDecode(jsonData);

      List<Map<String, dynamic>> dataList = [];

      for (dynamic item in data['result']['item']) {
        Map<String, dynamic> moreData = {
          'title' : item['subTitle'],
          'content': item['subContent'],
          'location': item['groupName'],
          'contact': item['contact'],
          'limit': item['subDesc_2'],
          'price': item['subDesc_3'],
          'add1': item['sido'],
          'add2': item['gugun'],
          'subDate':item['subDate'],
          'StartDate' : int.tryParse(item['sDate'] ?? '') ?? 0,
          'EndDate' : int.tryParse(item['eDate'] ?? '') ?? 0,
        };

        if(moreData['EndDate']!=0){
          dataList.add(moreData);
        }
      }

      dataList = removeDuplicates(dataList);

      print(dataList);

      return dataList;

    } catch (error) {
      print(error);
      throw Exception("Failed to load title data"); // 오류 발생 시 예외를 던져줌
    }

  }


  List<Map<String, dynamic>> removeDuplicates(List<Map<String, dynamic>> list) {
    Map<String, Map<String, dynamic>> uniqueMap = {};

    for (var item in list) {
      String title = item['title'];
      int endDate = item['EndDate'];

      if (!uniqueMap.containsKey(title) || endDate > uniqueMap[title]!['EndDate']) {
        uniqueMap[title] = item;
      }
    }

    List<Map<String, dynamic>> uniqueList = uniqueMap.values.toList();
    uniqueList.sort((a, b) => a['EndDate'].compareTo(b['EndDate'])); // 마감일 오름차순으로 정렬

    return uniqueList;
  }


  // //record 사용
  // (String, int, int) titleAndDates(Map<String, dynamic> json) {
  //   return (json['title'] as String, json['sDate'] as int, json['eDate'] as int);
  // }
  //
  // final result = titleAndDates({
  //   'title': '전시회',
  //   'sDate': 230623,
  //   'eDate': 230626
  // });
  // print(result);
  // print(result.$1);
  // print(result.$2);
  // }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: loadTitleData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Map<String, dynamic>> dataList = snapshot.data!;
            return Padding(
              padding: EdgeInsets.fromLTRB(0,0,0,15),
              child: ListView.builder(
                itemExtent: 50,
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> item = dataList[index];

                  String startDate = item['StartDate'].toString();
                  String formattedStartDate = '${startDate.substring(0, 4)}-${startDate.substring(4, 6)}-${startDate.substring(6, 8)}';

                  return ListTile(
                    // contentPadding: EdgeInsets.fromLTRB(30, 5, 20, 24),
                    contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 8),
                    // 기본값 EdgeInsets.fromLTRB(16, 8, 16, 8),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 280, // 원하는 최대 너비로 지정
                          child: Text(
                            item['title'],
                            overflow: TextOverflow.clip, // 일정 길이 이상의 텍스트는 자르고 숨김
                          ),
                        ),
                        Text(
                          // '${item.updateAt}'
                            formattedStartDate,
                            style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                    onTap: () {
                      // 클릭된 리스트 타일에 대한 동작 처리
                      print('Clicked item: ${item['title']}');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PerformanceNewPage(data: item),
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