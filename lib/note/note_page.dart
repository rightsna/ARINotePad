import 'package:ari_plugin/ari_plugin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'note_provider.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  PackageInfo? _packageInfo;

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NoteProvider>();

    return Column(
      children: [
        const AriUpdateBanner(
          appId: 'notepad',
          appName: 'ARI Note Pad',
        ),
        Expanded(
          child: Scaffold(
            appBar: AppBar(
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'ARI Note Pad',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  StreamBuilder<bool>(
                    stream: AriAgent.connectionStream,
                    initialData: AriAgent.isConnected,
                    builder: (context, snapshot) {
                      final isConnected = snapshot.data ?? false;
                      return Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isConnected ? Colors.green : Colors.red,
                        ),
                      );
                    },
                  ),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: provider.toggleRichText,
                  tooltip: provider.isRichText
                      ? 'Switch to Plain Text'
                      : 'Switch to Rich Text',
                  icon: Icon(
                    provider.isRichText ? Icons.text_fields : Icons.format_paint,
                    color: provider.isRichText
                        ? const Color(0xFF6C63FF)
                        : Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: provider.toggleReadOnly,
                  tooltip: provider.isReadOnly
                      ? 'Switch to Edit Mode'
                      : 'Switch to Read-only Mode',
                  icon: Icon(
                    provider.isReadOnly ? Icons.visibility : Icons.edit,
                    color: provider.isReadOnly
                        ? const Color(0xFF6C63FF)
                        : Colors.white,
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'version') {
                      showAboutDialog(
                        context: context,
                        applicationName: 'ARI Note Pad',
                        applicationVersion: _packageInfo != null
                            ? '${_packageInfo!.version}+${_packageInfo!.buildNumber}'
                            : '0.0.0',
                        applicationIcon: const FlutterLogo(),
                        children: [
                          const Text('A simple Note Pad bundle for ARI.'),
                        ],
                      );
                    }
                  },
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'version',
                      child: Text('Version Info'),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
              ],
            ),
            body: Container(
              color: const Color(0xFF12121F),
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              child: provider.isRichText
                  ? Markdown(
                      data: provider.textController.text.isEmpty
                          ? 'No content'
                          : provider.textController.text,
                      padding: EdgeInsets.zero,
                      styleSheet: MarkdownStyleSheet(
                        p: const TextStyle(color: Colors.white, fontSize: 14),
                        h1: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                        h2: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                        h3: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        h4: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        h5: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        h6: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                        em: const TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
                        strong: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        del: const TextStyle(color: Colors.white, decoration: TextDecoration.lineThrough),
                        blockquote: const TextStyle(color: Colors.white54, fontStyle: FontStyle.italic),
                        code: const TextStyle(color: Colors.greenAccent, fontFamily: 'Courier'),
                        codeblockDecoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    )
                  : TextField(
                      controller: provider.textController,
                      readOnly: provider.isReadOnly,
                      maxLines: null,
                      expands: true,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Courier',
                      ),
                      decoration: InputDecoration(
                        hintText: provider.isReadOnly
                            ? 'Read only mode'
                            : 'Type something...',
                        hintStyle: const TextStyle(color: Colors.white24),
                        border: InputBorder.none,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
