import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:mapmapmap/src/controller/national_treasure_list_controller.dart';
import 'package:mapmapmap/src/controller/treasure_list_controller.dart';

class NationalTreasureList extends StatefulWidget {
  NationalTreasureList({Key? key}) : super(key: key);

  RxBool isToggleActive = false.obs;

  // 토글 상태 변경 메서드
  void toggleMarkers() {
    isToggleActive.value = !isToggleActive.value;
  }

  @override
  State<NationalTreasureList> createState() => _NationalTreasureListState();
}

final NationalTreasureListController nationalTreasureListController =
    Get.put(NationalTreasureListController());
final TreasureListController treasureListController =
    Get.put(TreasureListController());
late GoogleMapController googleMapController;

void _onMapCreated(GoogleMapController controller) {
  googleMapController = controller;
}

class _NationalTreasureListState extends State<NationalTreasureList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => nationalTreasureListController.isToggleActive.value
              ? Text("보물 위치")
              : Text("국보 위치"),
        ),
        backgroundColor: Colors.grey[500],
      ),
      body: Center(
        child: Obx(
          () => nationalTreasureListController.isToggleActive.value
              ? FutureBuilder<Set<Marker>>(
                  future: treasureListController.loadData(),
                  builder: (BuildContext context,
                      AsyncSnapshot<Set<Marker>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Stack(
                        children: [
                          GoogleMap(
                            onMapCreated: _onMapCreated,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(36.5275, 128.0575),
                              zoom: 7,
                            ),
                            markers: snapshot.data!,
                            onTap: (LatLng latLng) {
                              googleMapController.animateCamera(
                                CameraUpdate.newCameraPosition(
                                  CameraPosition(
                                    target: latLng,
                                    zoom: 15, // 원하는 zoom 수치로 변경하세요
                                  ),
                                ),
                              );
                            },
                          ),
                          Positioned(
                            bottom: MediaQuery.of(context).size.height * 0.15,
                            right: MediaQuery.of(context).size.width * 0.01,
                            child: FloatingActionButton(
                              onPressed: () {
                                nationalTreasureListController.toggleMarkers();
                              },
                              child: Icon(
                                nationalTreasureListController
                                        .isToggleActive.value
                                    ? Icons.toggle_on_outlined
                                    : Icons.toggle_off_outlined,
                              ),
                            ),
                          )
                        ],
                      );
                    }
                  },
                )
              : FutureBuilder<Set<Marker>>(
                  future: nationalTreasureListController.loadData(),
                  builder: (BuildContext context,
                      AsyncSnapshot<Set<Marker>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Stack(
                        children: [
                          GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(36.5275, 128.0575),
                              zoom: 7,
                            ),
                            markers: snapshot.data!,
                          ),
                          Positioned(
                            bottom: MediaQuery.of(context).size.height * 0.15,
                            right: MediaQuery.of(context).size.width * 0.01,
                            child: FloatingActionButton(
                              onPressed: () {
                                nationalTreasureListController.toggleMarkers();
                              },
                              backgroundColor: Colors.orange,
                              child: Icon(
                                nationalTreasureListController
                                        .isToggleActive.value
                                    ? Icons.toggle_on_outlined
                                    : Icons.toggle_off_outlined,
                              ),
                            ),
                          )
                        ],
                      );
                    }
                  },
                ),
        ),
      ),
    );
  }
}
