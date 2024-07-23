import 'package:flutter/material.dart';
import 'package:mapmapmap/src/list/reservation_form.dart';
import 'package:mapmapmap/src/list/reservation_info.dart';

class ReservationMain extends StatefulWidget {
  const ReservationMain({super.key});

  @override
  State<ReservationMain> createState() => _ReservationMainState();
}

class _ReservationMainState extends State<ReservationMain> {

  ReservationForm reservationForm = ReservationForm();
  ReservationInfo reservationInfo = ReservationInfo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: buildReservationContainer(),
            ),
          ],
        ),
      ),
    );
  }


  Widget buildReservationContainer() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: buildContainerDecoration(),
          child: Align(
            alignment: Alignment.center,
            child: buildReservationContent(),
          ),
        ),
      ],
    );
  }

  BoxDecoration buildContainerDecoration() {
    if (MediaQuery.of(context).viewInsets.bottom > 0) {
      // 키보드가 나타날 때는 bottom의 테두리를 삭제
      return BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.black.withOpacity(0.4),
            width: 90, // 가로 테두리 두께
          ),
          bottom: BorderSide.none,
          left: BorderSide(
            color: Colors.black.withOpacity(0.4),
            width: 30, // 가로 테두리 두께
          ),
          right: BorderSide(
            color: Colors.black.withOpacity(0.4),
            width: 30, // 세로 테두리 두께
          ),
        ),
        color: Colors.transparent,
      );
    } else {

      return BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.black.withOpacity(0.4),
            width: 90, // 가로 테두리 두께
          ),
          bottom: BorderSide(
            color: Colors.black.withOpacity(0.4),
            width: 70, // 세로 테두리 두께
          ),
          left: BorderSide(
            color: Colors.black.withOpacity(0.4),
            width: 30, // 가로 테두리 두께
          ),
          right: BorderSide(
            color: Colors.black.withOpacity(0.4),
            width: 30, // 세로 테두리 두께
          ),
        ),
        color: Colors.transparent,
      );
    }
  }


  Widget buildReservationContent() {
    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.white.withOpacity(0.7),
      child: Column(
        children: [
          SizedBox(height: 40),
          Text(
            "문화 체험 예약 안내",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 50),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    "문화 체험 예약을 원하시는 분들께서는 "
                        "하단의 예약하기 버튼을 클릭해주십시오.\n\n"
                        "결제가 필요한 프로그램은 당일 현장에서 "
                        "예약 내역 확인 후 이루어집니다.\n\n"
                        "상세 가격은 각 프로그램 관련 홈페이지를 참고하세요.\n\n"
                        "취소는 체험 전날까지 가능합니다.\n\n많은 관심 바랍니다.\n\n",
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0), // 원하는 패딩 값 설정
                child: reservationForm,
              ),
              Padding(
                padding: EdgeInsets.all(8.0), // 원하는 패딩 값 설정
                child: reservationInfo,
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

