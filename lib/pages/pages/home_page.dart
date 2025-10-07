import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toastification/toastification.dart';
import 'package:uuid/uuid.dart';

import '../chat_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _uuidController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String? _sessionUuid;

  @override
  void initState() {
    super.initState();
    // Auto-focus the text field when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _uuidController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleLogin(BuildContext context) {
    // Check if the widget is still mounted
    if (!context.mounted) return;

    final inputUuid = _uuidController.text.trim();

    if (inputUuid.isEmpty) {
      // Generate a new UUID if no input provided
      _sessionUuid = const Uuid().v4();

      // Show a dialog to the user and click okay to close and can be copied to the clipboard
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('New Session ID', style: Theme.of(context).textTheme.displaySmall),
          content: Text('The new session ID is: $_sessionUuid', style: Theme.of(context).textTheme.bodyMedium),
          actions: [
            TextButton(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: _sessionUuid!));
                if (context.mounted) {
                  Navigator.of(context).pop();

                  toastification.show(
                    context: context,
                    type: ToastificationType.success,
                    autoCloseDuration: const Duration(seconds: 2),
                    closeButton: ToastCloseButton(showType: CloseButtonShowType.none),
                    title: Text(
                      'Session ID copied to clipboard',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).cardColor),
                    ),
                  );
                }
              },
              style: TextButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
              child: Text(
                'Copy Session ID',
                style:
                    Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).primaryIconTheme.color),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close', style: Theme.of(context).textTheme.bodyMedium),
            ),
          ],
        ),
      );
    } else {
      // Use the provided UUID
      _sessionUuid = inputUuid;
    }

    // Navigate to chat screen with the session UUID
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatScreen(sessionUuid: _sessionUuid!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title
              Text(
                'Welcome to AI Chat',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Enter your session ID or press Enter to continue.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Login TextField
              CallbackShortcuts(
                bindings: <ShortcutActivator, VoidCallback>{
                  const SingleActivator(LogicalKeyboardKey.enter): () => _handleLogin(context),
                },
                child: TextField(
                  controller: _uuidController,
                  focusNode: _focusNode,
                  onSubmitted: (_) => _handleLogin(context),
                  cursorColor: Theme.of(context).primaryColor,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  autocorrect: false,
                  enableSuggestions: false,
                  decoration: InputDecoration(
                    hintText: 'Enter session ID (Optional)',
                    hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).hintColor,
                        ),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).dividerColor,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).dividerColor,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Info text
              Text(
                'Leave empty to generate a new session ID.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
