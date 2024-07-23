import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapmapmap/src/getx/performance_date_detail.dart';
import 'package:mapmapmap/src/getx/reservation_detail.dart';
import 'package:mapmapmap/src/model/reservation.dart';

class ReservationForm extends StatefulWidget {
  const ReservationForm({super.key});

  @override
  State<ReservationForm> createState() => _ReservationFormState();
}

class _ReservationFormState extends State<ReservationForm> {

  DateTime selectedDate = DateTime.now();
  DataSource dataSource=DataSource();

  String? boardId = "";
  String name = "";
  int count = 0;
  String phoneNum= "";
  String? selectedLocation = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: () async {
          DateTime? dateTime = await showDatePicker(
            context: context,
            initialDate: DateTime.now().add(Duration(days: 1)),
            firstDate: DateTime.now().add(Duration(days: 1)), // 현재 날짜부터 선택할 수 있게
            lastDate: DateTime.now().add(Duration(days: 100)), // 현재 날짜로부터 100일 후까지 선택 가능
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            builder: (BuildContext context, Widget? child) {
              return Theme(
                data: ThemeData.light().copyWith(
                  primaryColor: Colors.blueGrey,
                  colorScheme: ColorScheme.light(primary: Colors.blueGrey),
                ),
                child: child!,
              );
            },
          );
          if (dateTime != null) {
            setState(() {
              selectedDate = dateTime;
            });
            showReservationInfoDialog();
          }
        },
        child: Text("예약하기"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueGrey[700],
        ),
      ),

    );
  }

  Future<void> showReservationInfoDialog() async {

    boardId=null;
    count=0;
    phoneNum="";
    name="";
    selectedLocation = null;


    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("예약 정보 입력"),
          content: buildDialogContent(),
          actions: buildDialogActions(),
        );
      },
    );
  }



  Widget buildDialogContent() {
    return StatefulBuilder(
      builder: (context, setState) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildSidoDropdownButton(setState),
              SizedBox(height: 10),
              buildProgramDropdownButton(setState),
              buildNameTextField(),
              SizedBox(height: 10),
              buildCountTextField(),
              SizedBox(height: 10),
              buildPhonenumTextField(),
            ],
          ),
        );
      },
    );
  }

  Widget buildSidoDropdownButton(Function setState) {
    return Align(
      alignment: Alignment.centerLeft,
      child: FutureBuilder<List<DropdownMenuItem<String>>>(
        future: buildDropdownSidos(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              width: double.infinity,
              child: Container(
                child: DropdownButton<String>(
                  items: snapshot.data,
                  onChanged: (value) {
                    setState(() {
                      selectedLocation = value;
                      print(selectedLocation);
                    });
                  },
                  value: selectedLocation,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0, // 텍스트의 크기
                  ), // DropdownButton의 텍스트 스타일
                  underline: Container(
                    height: 1.0,
                    color: Colors.grey, // 기본 언더라인 색상
                  ),
                  dropdownColor: Colors.white, // 드롭다운 메뉴의 배경색
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down), // 드롭다운 아이콘
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            return CircularProgressIndicator(); // 로딩 중인 표시
          }
        },
      ),
    );
  }


  Future<List<DropdownMenuItem<String>>> buildDropdownSidos() async {
    PerformanceDateDetail performanceDateDetail = PerformanceDateDetail();
    List<DropdownMenuItem<String>> dropdownItems = [];

    try {
      List<dynamic> uniqueSidoList =
      await performanceDateDetail.UniqueSidoList(selectedDate.year.toString(), selectedDate.month.toString());

      dropdownItems.add(
        DropdownMenuItem(
          value: null,
          child: Text(
            "위치",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
      );

      for (dynamic item in uniqueSidoList) {
        String sido = item.toString(); // sido 값 가져오기

        dropdownItems.add(
          DropdownMenuItem(
            value: sido,
            child: Text(sido),
          ),
        );
      }
    } catch (error) {
      print('Error: $error');
      // 에러 처리
    }

    return dropdownItems;
  }

  Widget buildProgramDropdownButton(Function setState) {
    return Align(
      alignment: Alignment.centerLeft,
      child: FutureBuilder<List<DropdownMenuItem<String>>>(
        future: buildDropdownPrograms(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              width: double.infinity,
              child: Container(
                child: DropdownButton<String>(
                  items: snapshot.data,
                  onChanged: (value) {
                    setState(() {
                      boardId = value;
                      print(boardId);
                    });
                  },
                  value: boardId,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0, // 텍스트의 크기
                  ), // DropdownButton의 텍스트 스타일
                  underline: Container(
                    height: 1.0,
                    color: Colors.grey, // 기본 언더라인 색상
                  ),
                  dropdownColor: Colors.white, // 드롭다운 메뉴의 배경색
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down), // 드롭다운 아이콘
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            return CircularProgressIndicator(); // 로딩 중인 표시
          }
        },
      ),
    );
  }

  Future<List<DropdownMenuItem<String>>> buildDropdownPrograms() async {
    PerformanceDateDetail performanceDateDetail = PerformanceDateDetail();
    List<DropdownMenuItem<String>> dropdownItems = [];

    try {
      List<dynamic> uniqueSubtitleList =
      await performanceDateDetail.UniqueSubtitleList(selectedDate.year.toString(), selectedDate.month.toString(), selectedDate.day, selectedLocation.toString(),);

      dropdownItems.add(
        DropdownMenuItem(
          value: null,
          child: Text(
            "프로그램명",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
      );

      for (dynamic item in uniqueSubtitleList) {
        String subtitle = item.toString(); // sido 값 가져오기

        dropdownItems.add(
          DropdownMenuItem(
            value: subtitle,
            child: Text(subtitle),
          ),
        );
      }
    } catch (error) {
      print('Error: $error');
      // 에러 처리
    }

    return dropdownItems;
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

  Widget buildCountTextField(){
    return TextField(
      onChanged: (value) {
        final onlyNumbers = RegExp(r'^[1-9][0-9]*$');
        if (onlyNumbers.hasMatch(value)) {
          setState(() {
            count = int.parse(value);
          });
        }
      },
      decoration: InputDecoration(
        hintText: "예약 인원",
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
        FilteringTextInputFormatter.digitsOnly,
        FilteringTextInputFormatter.singleLineFormatter,
        FilteringTextInputFormatter(
          RegExp(r'^[1-9]\d?$'),
          allow: true,
          replacementString: '',
        ),
      ],
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

  List<Widget> buildDialogActions() {
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
          if (name.isEmpty ||
              count <= 0 ||
              phoneNum.isEmpty ||
              selectedLocation==null||
              boardId == null ||
              name.isEmpty ||
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
            createReservation();
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

  void createReservation() async {
    try {
      Reservation reservation = await dataSource.createReservation(
        boardId,
        name,
        selectedDate,
        count,
        phoneNum,
      );
      print('예약이 성공적으로 생성되었습니다.');
      print('예약 정보: '+reservation.info());
    } catch (error) {
      print('예약 생성 오류: $error');
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

