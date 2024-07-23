import 'package:flutter/material.dart';
import 'package:mapmapmap/src/list/board_list.dart';
import 'package:mapmapmap/src/list/board_list_newpage.dart';
import 'package:mapmapmap/src/list/performance_list.dart';
import 'package:mapmapmap/src/list/performance_list_newpage.dart';
import 'package:mapmapmap/src/main/carousel.dart';

class RealHome extends StatelessWidget {
  const RealHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 8,
            child: CarouselEx(),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey[300],
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15,0,0,0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.article_outlined),
                    SizedBox(width: 10,),
                    Text(
                      "공지사항",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),Expanded(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BoardListNewPage(), // BoardListNewPage로 이동
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                  ],
                )
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Align(alignment: Alignment.topLeft, child: BoardList()),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey[300],
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(15,0,0,0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.campaign_outlined),
                      SizedBox(width: 10,),
                      Text(
                        "이달의 행사",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PerformanceListNewPage(), // BoardListNewPage로 이동
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  )
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child:
                Align(alignment: Alignment.topLeft, child: PerformanceList()),
          ),
        ],
      ),
    );
  }
}
