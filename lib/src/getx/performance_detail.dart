import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';

class PerformanceDetail extends StatelessWidget {
  final String searchYear;
  final String searchMonth;

  const PerformanceDetail({Key? key, required this.searchYear, required this.searchMonth,}) : super(key: key);

 Future<Map<String, dynamic>> loadDetailData() async {

    String url =
        "http://www.cha.go.kr/cha/openapi/selectEventListOpenapi.do?searchYear=${searchYear}&searchMonth=${searchMonth}";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type" : "application/json",
      },
    );
    final getXmlData = response.body;
    final Xml2JsonData = Xml2Json()..parse(getXmlData);
    final jsonData = Xml2JsonData.toParker();

    Map<String, dynamic> data = jsonDecode(jsonData);

    List<dynamic> items = data['result']['item'];
    print(items);


    return data;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('문화재 정보'),
        backgroundColor: Colors.blueGrey[800],
      ),
      body:SingleChildScrollView(
        child: Center(
          child: FutureBuilder<Map<String, dynamic>>(
            future: loadDetailData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // 로딩 중 표시
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}'); // 에러 메시지 표시
              } else if (snapshot.hasData) {
                final data = snapshot.data!;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20,),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: ' 제목 : ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: data['result']['item']['subTitle'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '소개 : ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                                fontSize: 17
                            ),
                          ),
                          TextSpan(
                             text: data['result']['item']['subContent'].replaceAll('\\n', '').replaceAll('\\', ''),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '문화재 명칭 : ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17
                            ),
                          ),
                          TextSpan(
                            text: (data['result']['item']['contact']),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17
                            ),
                          ),
                        ],
                      ),
                    ),


                    SizedBox(
                      height: 10,
                    ),
                  ],
                );
              } else {
                return Text('No data'); // 데이터 없음 메시지 표시
              }
            },
          ),
        ),
      ),
    );
  }
}