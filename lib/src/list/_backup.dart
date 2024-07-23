import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatelessWidget {
  static final LatLng companyLatLng = LatLng(
    37.5233273,
    126.921252,
  );

  static final Marker marker = Marker(
    markerId:  MarkerId('company'),
    position: companyLatLng,
  );
  static final Circle circle = Circle(
      circleId: CircleId('choolCheckCircle'),
    center: companyLatLng,
    fillColor: Colors.blue.withOpacity(0.5),
    radius: 100,
    strokeColor: Colors.blue,
    strokeWidth: 1,
  );
  const HomeScreen({Key? key}) :  super(key: key);

  @override
  Widget build(BuildContext context) {
    Set<Marker> markers = {};
  return Scaffold(
  appBar: renderAppBar(),
  body: FutureBuilder<String>(
    future: checkPermission(),
    builder: (context, snapshot) {
      if(!snapshot.hasData &&
      snapshot.connectionState == ConnectionState.waiting) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      if ( snapshot.data == '위치 권한이 허가 되었습니다'){

        return Column(
            children: [
              Expanded(
                flex: 2,
                child: GoogleMap(
                  onTap: (LatLng) {
                  markers.add(Marker(
                    markerId: MarkerId('${LatLng}'),
                    position: LatLng,


                  ));
                  },
                    initialCameraPosition: CameraPosition(
                      target: companyLatLng,
                      zoom: 16,
                    ),
                  myLocationEnabled: true,
                  markers: markers,
                  circles: Set.from([circle]),
                ),
              ),

            ]
        );
      }
      return Center(
        child: Text(
          snapshot.data.toString(),
        ),
      );
    },

  ),
  );
  }


  AppBar renderAppBar() {
  return AppBar(
  centerTitle: true,
  title: Text(
  '오늘도 출첵',
  style: TextStyle(
  color: Colors.blue,
  fontWeight: FontWeight.w700,
  ),
  ),
  backgroundColor: Colors.white,
  );
  }
}
  Future<String> checkPermission() async {
    final isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    if(!isLocationEnabled) {
      return '위치 서비스를 활성화 해주세요';
    }

    LocationPermission checkedPermission = await Geolocator.checkPermission();

    if(checkedPermission == LocationPermission.denied) {
      checkedPermission = await Geolocator.requestPermission();

      if(checkedPermission == LocationPermission.denied) {
        return '위치 권한을 허가해주세요';
      }
    }
    if( checkedPermission == LocationPermission.deniedForever) {
      return '앱의 위치 권한을 설정에서 허가해주세요';
    }
    return '위치 권한이 허가 되었습니다';

  }


