import 'dart:convert';
import 'package:http/http.dart' as http;

class MemoService {
  static const String baseUrl = 'http://10.0.2.2:3000/api/memos';
  // static const String baseUrl = 'http://192.168.0.25:3000/api/memos';//로컬 핸드폰

  // 모든 메모 조회
  static Future<List<Map<String, String>>> fetchMemos() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> memosJson = json.decode(response.body);
      return memosJson.map<Map<String, String>>((json) {
        return {
          'id': json['id']?.toString() ?? '',
          'title': json['title'] ?? 'Untitled',
          'content': json['content'] ?? 'No Content',
          'createdAt': json['createdAt'] ?? '',
          'updatedAt': json['updatedAt'] ?? '',
        };
      }).toList();
    } else {
      throw Exception(
          '메모 로드 실패. 상태 코드: ${response.statusCode}');
    }
  }

  // 메모 추가
  static Future<void> addMemo(String title, String content) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'title': title, 'content': content}),
    );
    if (response.statusCode != 201) {
      throw Exception(
          '메모 추가 실패. 상태 코드: ${response.statusCode}');
    }
  }

  // 메모 수정
  static Future<void> updateMemo(String id, String title, String content) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'title': title, 'content': content}),
    );
    if (response.statusCode != 200) {
      throw Exception(
          '메모 수정 실패. 상태 코드: ${response.statusCode}');
    }
  }

  // 메모 삭제
  static Future<void> deleteMemo(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception(
          '메모 삭제 실패. 상태 코드: ${response.statusCode}');
    }
  }
}
