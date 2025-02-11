import 'package:flutter/material.dart';
import 'package:notepad_2/memo_service.dart';

import 'EditMemoDialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController titleController = TextEditingController(); // 제목 입력 컨트롤러
  final TextEditingController contentController = TextEditingController(); // 내용 입력 컨트롤러
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, String>> memos = [];
  List<Map<String, String>> filteredMemos = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    fetchMemosFromApi();
  }

  // API로부터 메모를 불러옴
  Future<void> fetchMemosFromApi() async {
    try {
      final fetchedMemos = await MemoService.fetchMemos();
      print('Fetched Memos: $fetchedMemos');
      print('메모 개수: ${fetchedMemos.length}');
      setState(() {
        memos = fetchedMemos;
        filteredMemos = List.from(fetchedMemos);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('메모 로드 실패: $e')),
      );
    }
  }


  // 새로운 메모 추가
  Future<void> addMemo() async {
    final title = titleController.text.trim();
    final content = contentController.text.trim();

    if (title.isNotEmpty && content.isNotEmpty) {
      try {
        await MemoService.addMemo(title, content);
        titleController.clear();
        contentController.clear();
        fetchMemosFromApi();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('메모 추가 실패: $e')),
        );
      }
    }
  }

  // 메모 편집 (한 번의 다이얼로그에서 제목과 내용을 동시에 편집)
  Future<void> editMemo(int index) async {
    // filteredMemos에서 선택한 메모를 가져옴
    final currentMemo = filteredMemos[index];
    final memoId = currentMemo['id']!;

    final updatedData = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => EditMemoDetailDialog(
        initialTitle: currentMemo['title'] ?? '',
        initialContent: currentMemo['content'] ?? '',
      ),
    );

    if (updatedData != null &&
        updatedData['title']!.trim().isNotEmpty &&
        updatedData['content']!.trim().isNotEmpty) {
      try {
        await MemoService.updateMemo(
          memoId,
          updatedData['title']!,
          updatedData['content']!,
        );
        fetchMemosFromApi();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('메모 수정 실패: $e')),
        );
      }
    }
  }

  // 메모 삭제
  Future<void> deleteMemo(String id) async {
    try {
      await MemoService.deleteMemo(id);
      fetchMemosFromApi();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('메모 삭제 실패: $e')),
      );
    }
  }

  // 메모 검색
  void searchMemos(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredMemos = List.from(memos);
      } else {
        filteredMemos = memos.where((memo) {
          return (memo['title']?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
              (memo['content']?.toLowerCase().contains(query.toLowerCase()) ?? false);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
          controller: _searchController,
          onChanged: searchMemos,
          decoration: const InputDecoration(
            hintText: '검색어를 입력하세요.',
            border: InputBorder.none,
          ),
        )
            : const Text('메모장'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  filteredMemos = List.from(memos);
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 메모 추가 폼
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: '제목',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(
                    labelText: '내용',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: addMemo,
                  child: const Text('저장'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // 메모 리스트
          Expanded(
            child: ListView.builder(
              itemCount: filteredMemos.length,
              itemBuilder: (context, index) {
                final memo = filteredMemos[index];
                return ListTile(
                  title: Text(memo['title'] ?? 'No Title'),
                  subtitle: Text(memo['content'] ?? 'No Content'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => deleteMemo(memo['id']!),
                  ),
                  onTap: () => editMemo(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
