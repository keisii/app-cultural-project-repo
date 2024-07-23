import 'dart:convert';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapmapmap/src/getx/national_treasure_detail.dart';

import 'package:xml2json/xml2json.dart';
import 'package:http/http.dart' as http;

class NationalTreasureListController extends GetxController {
  var isToggleActive = false.obs;
  Set<Marker> markers = Set<Marker>();

  void toggleMarkers() {
    isToggleActive.value = !isToggleActive.value;
  }

  Future<Set<Marker>> loadData() async {
    markers = await LoadNationalTreasureList();
    return markers;
  }
}
Future<Set<Marker>> LoadNationalTreasureList() async {

  String url = "http://www.cha.go.kr/cha/SearchKindOpenapiList.do?ccbaKdcd=11&pageUnit=400";

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
          onTap: (){
            Get.to(NationalTreasureDetail(ccbaAsno: ccbaAsno, ccbaCtcd: ccbaCtcd));
          }
      ),
      position: LatLng(double.parse(item['latitude']), double.parse(item['longitude'])),
    );
    tempMarkers.add(marker);
  }
  markers = tempMarkers;
  return markers;
}