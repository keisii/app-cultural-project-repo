import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

// class MyApp extends StatelessWidget {
//    MyApp({Key? key}) : super(key: key);
//
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Carousel(),
//     );
//   }
// }

class CarouselEx extends StatefulWidget {
  const CarouselEx({Key? key});

  @override
  State<CarouselEx> createState() => _CarouselExState();
}

class _CarouselExState extends State<CarouselEx> {
  int current = 0;
  final CarouselController controller = CarouselController();

  List imageList = [
    "assets/img11.jpg",
    "assets/img14.jpg",
    "assets/img13.jpg",
    "assets/img12.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 360,
            child: Stack(
              children: [
                sliderWidget(),
                sliderIndicator(),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget sliderIndicator() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: imageList
            .asMap()
            .entries
            .map((e) => GestureDetector(
          onTap: () => controller.animateToPage(e.key),
          child: Container(
            width: 10,
            height: 10,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white
                  .withOpacity(current == e.key ? 1.0 : 0.4),
            ),
          ),
        ))
            .toList(),
      ),
    );
  }

  Widget sliderWidget() {
    return CarouselSlider(
      carouselController: controller,
      items: imageList
          .map((filename) => Builder(builder: (context) {
        return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Image(
              fit: BoxFit.cover,
              image: AssetImage(filename),
            ));
      }))
          .toList(),
      options: CarouselOptions(
          height: 400,
          viewportFraction: 1.0,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 10),
          onPageChanged: (index, reason) {
            setState(() {
              current = index;
            });
          }),

    );
  }
}

