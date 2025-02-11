
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notepad_2/homepage_2.dart';


void main() {
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

//MaterialApp
// Flutter 앱의 최상위 구조를 제공.
// 앱의 전체적인 설정(테마, 네비게이션, 로컬화 등)을 관리.
//Scaffold
// 화면의 기본 레이아웃을 제공.
// 앱 화면 내에서 상단 바(AppBar), 본문(Body), 하단 네비게이션 바 등을 쉽게 구성.
//Container
// 단순한 **박스(Box)**처럼 UI 요소를 배치하거나 스타일링할 때 사용.
// 단독으로 앱을 구성하기에는 제한적.
//MaterialApp**은 앱 전체를 관리하는 "컨테이너".
// **Scaffold**는 화면 하나를 구성하는 "페이지 레이아웃".
// MaterialApp 안에 Scaffold를 포함하여 사용.
//MaterialApp**은 Flutter 앱의 최상위 위젯으로, 앱 전체를 관리하는 역할을 합니다.
// **Scaffold**는 화면 하나의 레이아웃을 구성하며, MaterialApp 내부에 포함됩니다.
// **Container**는 단순한 UI 요소이며, 앱의 구조를 관리하지 못합니다.