import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ari_plugin/ari_plugin.dart';
import 'note/note_provider.dart';
import 'note/note_page.dart';
import 'app_protocol.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final initialContent = Platform.environment['NOTEPAD_CONTENT'] ?? '';
  final noteProvider = NoteProvider(initialContent: initialContent);

  // ARI Plugin 연동 설정
  String? readArg(String prefix) {
    for (final arg in args) {
      if (arg.startsWith(prefix)) return arg.substring(prefix.length);
    }
    return null;
  }

  final port = readArg('--port=') ??
      const String.fromEnvironment('ARI_PORT', defaultValue: '13000');
  final host = readArg('--host=') ??
      const String.fromEnvironment('ARI_HOST', defaultValue: '127.0.0.1');

  if (port.isNotEmpty) {
    AriAgent.init(host: host, port: int.parse(port));
    AriAgent.connect();

    // 구조도 깔끔하게: Protocol Handler 연동
    NotepadProtocol(noteProvider).build().start();
  }

  runApp(
    ChangeNotifierProvider.value(
      value: noteProvider,
      child: const NotepadApp(),
    ),
  );
}

class NotepadApp extends StatelessWidget {
  const NotepadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AriChatProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ARI Note Pad',
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: const Color(0xFF6C63FF),
          scaffoldBackgroundColor: const Color(0xFF0F0F1A),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1A1A2E),
            elevation: 0,
          ),
        ),
        home: const NotePage(),
      ),
    );
  }
}
