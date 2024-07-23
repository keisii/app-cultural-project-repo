import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';

class TreasureDetail extends StatelessWidget {
  final String ccbaAsno;
  final String ccbaCtcd;

  const TreasureDetail({Key? key, required this.ccbaAsno, required this.ccbaCtcd,}) : super(key: key);

 Future<Map<String, dynamic>> loadDetailData() async {

    String url =
        "https://www.cha.go.kr/cha/SearchKindOpenapiDt.do?ccbaKdcd=12&ccbaAsno=${ccbaAsno}&ccbaCtcd=${ccbaCtcd}";

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
    print(ccbaAsno);
    print(ccbaCtcd);


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
                            text: '보물 ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: data['result']['item']['crltsnoNm'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: ' 호',
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
                            text: '문화재 명칭 : ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                                fontSize: 17
                            ),
                          ),
                          TextSpan(
                             text: data['result']['item']['ccbaMnm1'],
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
                    Container(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        data['result']['item']['content'].replaceAll('\\n', '').replaceAll('\\', ''),
                        style: TextStyle(fontSize: 15),
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.all(15),
                      child: Image.network(data['result']['item']['imageUrl']),
                    ),

                    Text(data['result']['item']['ccbaMnm1']),

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