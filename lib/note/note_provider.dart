import 'package:flutter/material.dart';

class NoteProvider extends ChangeNotifier {
  bool _isRichText = false;
  bool _isReadOnly = false;

  late final TextEditingController textController;

  NoteProvider({String initialContent = ''}) {
    textController = TextEditingController(text: initialContent);
    textController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    // 더 이상 능동적으로 서버에 텍스트를 보고하지 않음 (Pull 방식)
    notifyListeners();
  }


  void updateText(String text) {
    // 무한 루프 방지: 현재 텍스트와 다를 때만 업데이트
    if (textController.text != text) {
      textController.text = text;
      notifyListeners();
    }
  }

  void updateEditMode(bool isReadOnly) {
    _isReadOnly = isReadOnly;
    notifyListeners();
  }

  void updateRichMode(bool isRichText) {
    _isRichText = isRichText;
    notifyListeners();
  }

  bool get isRichText => _isRichText;
  bool get isReadOnly => _isReadOnly;

  void toggleRichText() {
    _isRichText = !_isRichText;
    notifyListeners();
  }

  void toggleReadOnly() {
    _isReadOnly = !_isReadOnly;
    notifyListeners();
  }

  @override
  void dispose() {
    textController.removeListener(_onTextChanged);
    textController.dispose();
    super.dispose();
  }
}
