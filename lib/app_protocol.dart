import 'package:ari_plugin/ari_plugin.dart';
import 'note/note_provider.dart';

class NotepadProtocol {
  final NoteProvider noteProvider;

  NotepadProtocol(this.noteProvider);

  AppProtocolHandler build() {
    return AppProtocolHandler(
      appId: 'notepad',
      onCommand: _onCommand,
      onGetState: _onGetState,
    );
  }

  Future<Map<String, dynamic>> _onCommand(
    String command,
    Map<String, dynamic> params,
  ) async {
    switch (command) {
      case 'UPDATE':
        final text = params['text']?.toString() ?? '';
        noteProvider.updateText(text);
        return {'status': 'success', 'message': 'Text updated'};
      case 'SET_RICH_MODE':
        if (params.containsKey('isRichText')) {
          noteProvider.updateRichMode(params['isRichText'] as bool);
          return {'status': 'success', 'message': 'Rich mode updated'};
        }
        return {'status': 'error', 'message': 'isRichText parameter missing'};
      case 'SET_EDIT_MODE':
        if (params.containsKey('isReadOnly')) {
          noteProvider.updateEditMode(params['isReadOnly'] as bool);
          return {'status': 'success', 'message': 'Edit mode updated'};
        }
        return {'status': 'error', 'message': 'isReadOnly parameter missing'};
      default:
        return {'status': 'error', 'message': 'Unknown command: $command'};
    }
  }

  Map<String, dynamic> _onGetState() {
    return {
      'text': noteProvider.textController.text,
      'isRichText': noteProvider.isRichText,
      'isReadOnly': noteProvider.isReadOnly,
    };
  }

}
