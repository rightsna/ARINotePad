import 'package:ari_plugin/ari_plugin.dart';
import 'package:flutter/material.dart';

class NoteProvider extends ChangeNotifier {
  bool _isRichText = false;
  bool _isReadOnly = false;

  late final TextEditingController textController;

  NoteProvider({String initialContent = ''}) {
    textController = TextEditingController(text: initialContent);
    textController.addListener(_onTextChanged);
    // 연결 상태 변경 리스너 등록
    WsManager.connectionNotifier.addListener(_onConnectionChanged);
  }

  void _onTextChanged() {
    // 더 이상 능동적으로 서버에 텍스트를 보고하지 않음 (Pull 방식)
    notifyListeners();
  }

  void _onConnectionChanged() {
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
    WsManager.connectionNotifier.removeListener(_onConnectionChanged);
    textController.removeListener(_onTextChanged);
    textController.dispose();
    super.dispose();
  }
}
