import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toastification/toastification.dart';
import 'package:uuid/uuid.dart';

import 'session_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _uuidController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String? _sessionUuid;

  @override
  void initState() {
    super.initState();
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
      _sessionUuid = const Uuid().v4();

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
      _sessionUuid = inputUuid;
    }

    // Navigate to chat screen with the session UUID
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SessionScreen(sessionUuid: _sessionUuid!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          const _BackdropAura(),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: 24, right: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const _LogoBadge(),
                  const SizedBox(height: 20),
                  Text(
                    'LLM Playground',
                    style: textTheme.displayLarge?.copyWith(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: theme.primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Experiment with AI conversations, iterate on prompts, and keep every session organised.',
                    style: textTheme.bodyLarge?.copyWith(
                      color: textTheme.bodyMedium?.color?.withValues(alpha: 0.85),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Card(
                    elevation: 18,
                    shadowColor: theme.primaryColor.withValues(alpha: 0.35),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    color: theme.cardColor.withValues(alpha: 0.9),
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Start a new playground session',
                            style: textTheme.displayMedium?.copyWith(
                              color: textTheme.displayLarge?.color,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Use an existing session ID to continue where you left off, or leave it blank and we\'ll mint a fresh one for you.',
                            style: textTheme.bodyMedium?.copyWith(
                              color: textTheme.bodyMedium?.color?.withValues(alpha: 0.9),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          CallbackShortcuts(
                            bindings: <ShortcutActivator, VoidCallback>{
                              const SingleActivator(LogicalKeyboardKey.enter): () => _handleLogin(context),
                            },
                            child: TextField(
                              controller: _uuidController,
                              focusNode: _focusNode,
                              onSubmitted: (_) => _handleLogin(context),
                              cursorColor: theme.primaryColor,
                              style: textTheme.bodyLarge,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              autocorrect: false,
                              enableSuggestions: false,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.key_rounded),
                                prefixIconColor: theme.primaryColor,
                                hintText: 'Paste an existing session UUID (optional)',
                                hintStyle: textTheme.bodyMedium?.copyWith(
                                  color: theme.hintColor,
                                ),
                                filled: true,
                                fillColor: theme.scaffoldBackgroundColor.withValues(alpha: 0.65),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: theme.dividerColor,
                                    width: 1.2,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: theme.dividerColor,
                                    width: 1.2,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: theme.primaryColor,
                                    width: 2,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Tip: keep the session ID handy to sync chats across devices.',
                            style: textTheme.bodySmall?.copyWith(
                              color: textTheme.bodySmall?.color?.withValues(alpha: 0.8),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoBadge extends StatelessWidget {
  const _LogoBadge();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 124,
      height: 124,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            theme.primaryColor.withValues(alpha: 0.65),
            theme.cardColor.withValues(alpha: 0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withValues(alpha: 0.4),
            blurRadius: 32,
            spreadRadius: 4,
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: SvgPicture.asset(
        'assets/images/playground_logo.svg',
        semanticsLabel: 'LLM Playground logo',
        fit: BoxFit.contain,
      ),
    );
  }
}

class _BackdropAura extends StatelessWidget {
  const _BackdropAura();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IgnorePointer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.primaryColor.withValues(alpha: 0.18),
              theme.scaffoldBackgroundColor,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -120,
              left: -60,
              child: _glowCircle(theme.primaryColor.withValues(alpha: 0.35), 260),
            ),
            Positioned(
              top: 180,
              right: -90,
              child: _glowCircle(theme.primaryColor.withValues(alpha: 0.25), 220),
            ),
            Positioned(
              bottom: -140,
              left: 40,
              child: _glowCircle(theme.primaryColor.withValues(alpha: 0.2), 280),
            ),
          ],
        ),
      ),
    );
  }

  Widget _glowCircle(Color color, double diameter) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: diameter / 2.2,
            spreadRadius: diameter / 8,
          ),
        ],
      ),
    );
  }
}
