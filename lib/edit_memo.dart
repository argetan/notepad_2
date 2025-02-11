

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class MemoStage {
  static List<Map<String, String>> memos = [];
  //static 메서드는 클래스 레벨에서 동작하며, 인스턴스 필드나 메서드에 접근할 수 없습니다

  static Future<void> SaveMemos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedData = jsonEncode(memos);
    await prefs.setString('memos', encodedData);
  }
  static String getCurrentTime(){
    final now = DateTime.now();
    return "${now.year}-${formatTwoDigits(now.month)}-${formatTwoDigits(now.day)} ${formatTwoDigits(now.hour)}:${formatTwoDigits(now.minute)}";
  }

  static String formatTwoDigits(int n) { // 스태틱
    return n.toString().padLeft(2,'0');
  }



}
// //
// 외부에서 컨트롤러를 전달받는 경우:
//
// final TextEditingController editedcontroller;를 사용하고, 생성자에서 초기화.
// 컨트롤러를 내부에서 생성하는 경우:
//
// late TextEditingController를 선언하고 initState()에서 초기화.
// 상황에 따라 초기화 방식을 선택:
//
// 위젯 내부에서만 사용하는 경우: 즉시 초기화 (final controller = TextEditingController()).
// 외부에서 데이터를 전달받아야 하는 경우: 생성자 초기화.