import 'dart:convert';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapmapmap/src/getx/treasure_detail.dart';

import 'package:xml2json/xml2json.dart';
import 'package:http/http.dart' as http;


class TreasureListController extends GetxController{
  var isToggleActive = false.obs;
  RxDouble zoomValue = 7.0.obs;
  Set<Marker> markers = Set<Marker>();

  void toggleMarkers() {
    isToggleActive.value = !isToggleActive.value;

  }
  Future<Set<Marker>> loadData() async {
    markers = await LoadTreasureListData(); // TreasureListData() 함수 호출하여 마커 데이터를 가져옵니다.
    return markers;
  }

}



Future<Set<Marker>> LoadTreasureListData() async {


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

  Set<Marker> tempMarkers = {};

  for (var item in items) {
    String ccbaAsno = item['ccbaAsno'];
    String ccbaCtcd = item['ccbaCtcd'];

    Marker marker = Marker(

      markerId: MarkerId(item['no']),
      infoWindow: InfoWindow(
          title: "${item['ccbaMnm1']}",
          snippet: "${item['ccbaAdmin']}",
          onTap: () {
            Get.to(TreasureDetail(ccbaAsno: ccbaAsno, ccbaCtcd: ccbaCtcd));
          }
      ),
      position: LatLng(
          double.parse(item['latitude']),
          double.parse(item['longitude'])),
    );
    tempMarkers.add(marker);
  }
  markers = tempMarkers;
  return markers;
}