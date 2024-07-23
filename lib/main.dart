import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapmapmap/src/list/national_treasure_list.dart';
import 'package:mapmapmap/src/list/real_home.dart';
import 'package:mapmapmap/src/list/reservation_main.dart';
import 'package:mapmapmap/src/list/treasure_list.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp ({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'MapMapMap',
      theme: ThemeData(
    ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = <Widget>[
    RealHome(),
    NationalTreasureList(),
    ReservationMain(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _screens.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[200],
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black54,),
            label: '메인 홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flag, color: Colors.black54,),
            label: '보물/국보 위치',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today, color: Colors.black54,),
            label: '체험 예약',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black87,
        selectedFontSize: 13,
        unselectedItemColor: Colors.black87,
        unselectedFontSize: 13,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}




