// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:notepad_2/EditMemoDialog.dart';
// import 'package:notepad_2/edit_memo.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:notepad_2/memo_service.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   _HomePageState createState() => _HomePageState(); // 이렇게 명시적으로 해줘야 바꿀 수 있음.
// }
//
// class _HomePageState extends State<HomePage> {
//   final TextEditingController controller = TextEditingController();
//   final TextEditingController _searchController =
//       TextEditingController(); // final은 참조를 막기위해
//   // List<Map<String, String>> memos = [];
//   List<Map<String, String>> _filteredMemo = [];
//   bool _isSearching = false;
//
//   void AddMemo() {
//     String text = controller.text.trim();
//     if (text.isNotEmpty) {
//       setState(() {
//         String currentTime = MemoStage.getCurrentTime();
//         MemoStage.memos.insert(0, {'text': text, 'time': currentTime});
//         _filteredMemo = MemoStage.memos;
//       });
//       controller.clear();
//       SaveMemos();
//     }
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     LaodMemos();
//     _filteredMemo = MemoStage.memos;
//   }
//
//
//
//   Future<void> SaveMemos() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String encodedData = jsonEncode(MemoStage.memos);
//     await prefs.setString('memos', encodedData);
//   }
//
//
//   Future<void> LaodMemos() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? encodedData = prefs.getString('memos');
//     if (encodedData != null) {
//       List<dynamic> decodedData = jsonDecode(encodedData);
//       setState(() {
//         MemoStage.memos = decodedData
//             .map<Map<String, String>>(
//               (e) => Map<String, String>.from(e as Map<dynamic, dynamic>),
//             )
//             .toList();
//       });
//     }
//
//   }
//
//   void searchmemos(String query) {
//     setState(() {
//       if (query.isEmpty) {
//         _filteredMemo = MemoStage.memos;
//       } else {
//         _filteredMemo = MemoStage.memos
//             .where((memo) =>
//                 memo['text']!.toLowerCase().contains(query.toLowerCase()) ||
//                 memo['time']!.contains(query))
//             .toList();
//       }
//     });
//   }
//
//
//   void EditMemo(int index) async {
//     final TextEditingController controller =
//         TextEditingController(text: MemoStage.memos[index]['text']);
//
//     final updatedMemo = await showDialog<String>(
//       context: context,
//
//       builder: (context) =>
//           EditMemoDialog(editedcontroller: controller), //여기 주의
//     );
//     if (updatedMemo != null && updatedMemo.trim().isNotEmpty) {
//       setState(() {
//         MemoStage.memos[index] = {
//           'text': updatedMemo,
//           'time': DateTime.now().toString().substring(0, 16)
//         };
//       });
//       SaveMemos();
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: _isSearching
//             ? TextField(
//                 controller: _searchController,
//                 onChanged: searchmemos,
//                 decoration: const InputDecoration(
//                   hintText: '검색어를 입력하세요.',
//                   border: InputBorder.none,
//                 ),
//               )
//             : Text('메모장'),
//         actions: [
//           // 앱바 버튼들 리딩 타이틀 액션
//           IconButton(
//             icon: Icon(_isSearching ? Icons.close : Icons.search),
//             onPressed: () {
//               setState(() {
//                 _isSearching = !_isSearching; // 역으로 바꿈
//                 if (!_isSearching) {
//                   _searchController.clear();
//                   _filteredMemo = MemoStage.memos;
//                 }
//               });
//             },
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: controller,
//               decoration: InputDecoration(
//                 labelText: '메모 입력',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             ElevatedButton(
//               onPressed: AddMemo,
//               child: Text('저장'),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _filteredMemo.length,
//                 itemBuilder: (context, index) {
//                   final sortedMemos =
//                       List<Map<String, String>>.from(_filteredMemo)
//                         ..sort((a, b) => b['time']!.compareTo(a['time']!));
//                   return Container(
//                     margin: EdgeInsets.symmetric(vertical: 4),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(
//                         color: Colors.grey,
//                         width: 1,
//                       ),
//                     ),
//                     child: ListTile(
//                       title: Text(sortedMemos[index]['text']!),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           if (sortedMemos[index]['text']!.length > 20)
//                             Text(
//                                 "${sortedMemos[index]['text']!.substring(0, 20)}..."),
//                           if (sortedMemos[index]['text']!.length <= 20)
//                             Text(sortedMemos[index]['text']!),
//                           Text(
//                             '작성 시간: ${sortedMemos[index]['time']!}',
//                             style: TextStyle(fontSize: 12, color: Colors.grey),
//                           ),
//                         ],
//                       ),
//                       trailing: IconButton(
//                         icon: Icon(Icons.delete),
//                         onPressed: () {
//                           setState(() {
//                             _filteredMemo.removeAt(index);
//                             _filteredMemo = MemoStage.memos;
//                           });
//                           SaveMemos();
//                         },
//                       ),
//                       onTap: () => EditMemo(index),
//                     ),
//                   );
//                 },
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// //final:
// // 한 번만 값 할당 가능.
// // 런타임에 할당된 값을 변경할 수 없음.
// // 참조하는 객체의 상태는 변경 가능.
// // const:
// // 컴파일 타임에 값이 고정.
// // 참조하는 객체의 상태도 변경 불가.
// // 불변 객체를 생성할 때 사용.
// //MemoStage.memos는 static 변수:
// //
// // static 변수는 클래스에 직접 속하기 때문에, 클래스명.변수명 형태로 접근할 수 있습니다.
// // 이 경우 MemoStage.memos는 전역적으로 데이터를 공유합니다.
