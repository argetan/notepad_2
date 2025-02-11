import 'package:flutter/material.dart';

class EditMemoDetailDialog extends StatefulWidget {
  final String initialTitle;
  final String initialContent;

  const EditMemoDetailDialog({
    Key? key,
    required this.initialTitle,
    required this.initialContent,
  }) : super(key: key);

  @override
  State<EditMemoDetailDialog> createState() => _EditMemoDetailDialogState();
}

class _EditMemoDetailDialogState extends State<EditMemoDetailDialog> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _contentController = TextEditingController(text: widget.initialContent);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _save() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    if (title.isEmpty || content.isEmpty) {
      // 입력값이 빈 경우에는 저장하지 않고 null을 반환
      Navigator.of(context).pop(null);
      return;
    }
    Navigator.of(context).pop({
      'title': title,
      'content': content,
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('메모 수정'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: '제목',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: '내용',
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: const Text('취소'),
        ),
        TextButton(
          onPressed: _save,
          child: const Text('저장'),
        ),
      ],
    );
  }
}
