import 'package:flutter/material.dart';

class PerformanceNewPage extends StatelessWidget {
  final Map<String, dynamic> data;

  PerformanceNewPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("행사 소개"),
        backgroundColor: Colors.grey[500],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    "${data['title']}",
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Divider(
                    height: 24,
                    thickness: 3,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "${data['content']}",
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(height: 20),
                  // 주관, 문의, 대상, 가격, 위치, 비고를 묶어 화면 아래쪽에 고정시킴
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRow("위치", "${data['add1']} ${data['add2']}"),
                      SizedBox(height: 8),
                      _buildRow("주관", "${data['location']}"),
                      SizedBox(height: 8),
                      _buildRow("문의", "${data['contact']}"),
                      SizedBox(height: 8),
                      _buildRow("대상", "${data['limit']}"),
                      SizedBox(height: 8),
                      _buildRow("가격", "${data['price']}"),
                      SizedBox(height: 8),
                      _buildRow("비고", "${data['subDate']}"),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "$label  ",
          style: TextStyle(fontSize: 15),
        ),
        Container(
          width: 1,
          height: 20,
          color: Colors.grey,
        ),
        SizedBox(width: 8),
        Text(
          value,
          style: TextStyle(fontSize: 15),
        ),
      ],
    );
  }
}
