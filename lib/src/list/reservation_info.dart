import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapmapmap/src/getx/reservation_detail.dart';
import 'package:mapmapmap/src/model/reservation.dart';
import 'package:intl/intl.dart';

class ReservationInfo extends StatefulWidget {
  const ReservationInfo({super.key});

  @override
  State<ReservationInfo> createState() => _ReservationInfoState();
}

class _ReservationInfoState extends State<ReservationInfo> {

  DataSource dataSource=DataSource();

  String phoneNum="";
  String name="";

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: () {
          showReservationCancelInfoDialog();
        },
        child: Text("예약정보확인"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueGrey[700],
        ),
      ),
    );
  }


  Future<void> showReservationCancelInfoDialog() async {

    phoneNum="";
    name="";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("예약자 정보 입력"),
          content: buildCancelContent(),
          actions: buildCancelActions(),
        );
      },
    );
  }

  Widget buildCancelContent() {
    return StatefulBuilder(
      builder: (context, setState) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildNameTextField(),
              SizedBox(height: 10),
              buildPhonenumTextField(),
            ],
          ),
        );
      },
    );
  }

  List<Widget> buildCancelActions() {
    return [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: DefaultTextStyle(
          style: TextStyle(
            color: Colors.black,
          ),
          child: Text("취소"),
        ),
      ),
      TextButton(
        onPressed: () {
          if (phoneNum.isEmpty ||
              name.isEmpty) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("경고"),
                  content: Text("모든 정보를 입력해야 합니다."),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("확인"),
                    ),
                  ],
                );
              },
            );
          } else {
            Navigator.of(context).pop();
            findAndDeleteReservation();
          }
        },
        child: DefaultTextStyle(
          style: TextStyle(
            color: Colors.black,
          ),
          child: Text("완료"),
        ),
      ),
    ];
  }

  Widget buildNameTextField() {
    return TextField(
      onChanged: (value) {
        setState(() {
          name = value;
        });
      },
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp("[0-9]")), // 숫자 입력 방지
        LengthLimitingTextInputFormatter(10), // 최대 글자 수 제한
      ],
      decoration: InputDecoration(
        hintText: "이름",
        hintStyle: TextStyle(
          fontSize: 16.0,
          color: Colors.grey,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
        contentPadding: EdgeInsets.only(bottom: -15.0),
      ),
    );
  }

  Widget buildPhonenumTextField() {
    var phoneNumberFormatter = PhoneNumberFormatter();

    return TextField(
      onChanged: (value) {
        setState(() {
          phoneNum = value;
        });
      },
      decoration: InputDecoration(
        hintText: "휴대폰 번호",
        hintStyle: TextStyle(
          fontSize: 16.0,
          color: Colors.grey,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
        contentPadding: EdgeInsets.only(bottom: -15.0),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        LengthLimitingTextInputFormatter(13), // 최대 길이 제한
        FilteringTextInputFormatter.digitsOnly, // 숫자만 입력 가능하도록 필터링
        phoneNumberFormatter, // 휴대폰 번호 형식 포맷터 추가
      ],
    );
  }

  void findAndDeleteReservation() async {
    try {
      List<Reservation> reservations = await dataSource.findReservation(
        name,
        phoneNum,
      );
      List<bool> selectedItems = List.generate(reservations.length, (index) => false); // 초기 선택 상태 리스트

      // 예약 내역 리스트를 화면에 표시
      showDialog(
        context: context,
        builder: (BuildContext context) {
          if (reservations.isEmpty) {
            // 예약 내역이 없는 경우 메시지를 표시
            return AlertDialog(
              title: Text('예약 내역'),
              content: Text('예약 내역이 없습니다.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('닫기'),
                ),
              ],
            );
          } else {
            // 예약 내역이 있는 경우 예약 내역을 표시하는 다이얼로그
            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: Text('예약 내역'),
                  content: SizedBox(
                    width: double.maxFinite,
                    height: 200,
                    child: ListView.builder(
                      itemCount: reservations.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedItems[index] =
                              !selectedItems[index]; // 선택 상태 토글
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: selectedItems[index] ? Colors.grey[300] : Colors.transparent,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            margin: EdgeInsets.only(bottom: 8.0),
                            child: ListTile(
                              title: Row(
                                children: [
                                  Text(
                                    '${index + 1}',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: 8.0),
                                  Expanded(
                                    child: Text(reservations[index].boardId),
                                  ),
                                ],
                              ),
                              subtitle: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      DateFormat('yyyy-MM-dd').format(reservations[index].reservationDate),
                                      textAlign: TextAlign.right,
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  SizedBox(width: 5.0),
                                  Text('${reservations[index].count}명', style: TextStyle(fontSize: 14)),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: DefaultTextStyle(
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        child: Text("닫기"),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('알림'),
                              content: Text('예약을 취소하시겠습니까?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // 알림 창 닫기
                                  },
                                  child: DefaultTextStyle(
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                    child: Text("취소"),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // 선택된 아이템 처리 로직 추가
                                    List<int> selectedReservations = [];
                                    for (int i = 0; i < selectedItems.length; i++) {
                                      if (selectedItems[i]) {
                                        selectedReservations.add(i);
                                      }
                                    }
                                    deleteReservation(selectedReservations, name, phoneNum);
                                    Navigator.of(context).pop(); // 다이얼로그 닫기
                                    Navigator.of(context).pop();
                                  },
                                  child: DefaultTextStyle(
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                    child: Text("확인"),
                                  ),
                                )
                              ],
                            );
                          },
                        );
                      },
                      child: DefaultTextStyle(
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        child: Text('예약 취소'),
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
      );
    } catch (error) {
      print('예약 확인 오류: $error');
      // 예약 생성 오류 처리 로직 추가
    }
  }

  Future<void> deleteReservation(List<dynamic> selectedReservations, String name, String phoneNum) async {
    try {
      await dataSource.deleteReservation(
          selectedReservations, name, phoneNum
      );
      await Future.delayed(Duration(seconds: 1)); // 임의의 지연 시간을 설정하여 확인할 수 있도록 함

      // 삭제 완료 후 알림 창 표시
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('알림'),
            content: Text('예약이 취소되었습니다.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 알림 창 닫기
                },
                child: DefaultTextStyle(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  child: Text("닫기"),
                ),
              ),
            ],
          );
        },
      );
      print('예약이 성공적으로 삭제되었습니다.');
    } catch (error) {
      print('예약 삭제 오류: $error');
      // 예약 생성 오류 처리 로직 추가
    }
  }
}


class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var newText = newValue.text;

    if (newText.length >= 4 && newText[3] != '-') {
      newText = newText.substring(0, 3) + '-' + newText.substring(3);
    }
    if (newText.length >= 9 && newText[8] != '-') {
      newText = newText.substring(0, 8) + '-' + newText.substring(8);
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length), // 커서를 맨 뒤로 설정
    );
  }
}


