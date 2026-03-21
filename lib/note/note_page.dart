import 'package:ari_plugin/ari_plugin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'note_provider.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NoteProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'ARI Note Pad',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: WsManager.isConnected ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
        actions: [
          // Rich/Plain Toggle
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
          // Read-only/Edit Toggle
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
          const SizedBox(width: 8),
        ],
      ),
      body: Container(
        color: const Color(0xFF12121F),
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        child: TextField(
          controller: provider.textController,
          readOnly: provider.isReadOnly,
          maxLines: null,
          expands: true,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: provider.isRichText
                ? FontWeight.bold
                : FontWeight.normal,
            fontStyle: provider.isRichText
                ? FontStyle.italic
                : FontStyle.normal,
            fontFamily: provider.isRichText ? 'Georgia' : 'Courier',
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
    );
  }
}
