import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:mapmapmap/main.dart';
import 'package:mapmapmap/src/getx/national_treasure_detail.dart';
import 'package:mapmapmap/src/getx/treasure_detail.dart';
import 'package:mapmapmap/src/list/national_treasure_list.dart';
import 'package:xml2json/xml2json.dart';
import 'dart:convert';
import 'package:get/get.dart';

class TreasureList extends StatelessWidget {
  const TreasureList({Key? key}) : super(key: key);

  Future<Set<Marker>> loadData() async {

    String url = "http://www.cha.go.kr/cha/SearchKindOpenapiList.do?ccbaKdcd=12&pageUnit=1500";

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

    List<dynamic> items = data['result']['item'];




    Set<Marker> markers = {};
    for (var item in items) {
      String ccbaAsno = item['ccbaAsno'];
      String ccbaCtcd = item['ccbaCtcd'];

      Marker marker = Marker(
        markerId: MarkerId(item['no']),
        infoWindow: InfoWindow(
            title: "${item['ccbaMnm1']}",
            snippet: "${item['ccbaAdmin']}",
            onTap: (){
              Get.to(TreasureDetail(ccbaAsno: ccbaAsno, ccbaCtcd: ccbaCtcd));
            }
        ),
        position: LatLng(double.parse(item['latitude']), double.parse(item['longitude'])),
      );
      markers.add(marker);
    }
    return markers;
  }




  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Set<Marker>>(
      future: loadData(),
      builder: (BuildContext context, AsyncSnapshot<Set<Marker>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator()); // or some other widget
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(36.5275, 128.0575),
                    zoom: 7,
                  ),
                  markers: snapshot.data!,
                );
        }
      },
    );
  }
}