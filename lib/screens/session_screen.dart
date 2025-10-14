import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart' show SvgPicture;

import '../config/constant.dart' show kHPadding, kVPadding;
import '../icons/icons.dart';
import 'chat_section.dart';

class SessionScreen extends StatefulWidget {
  final String sessionUuid;
  const SessionScreen({super.key, required this.sessionUuid});

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  bool isNewChat = true;
  bool isColapsed = true;
  bool isHover = false;

  void _toggleNewChat({bool? thisOne}) => setState(() => isNewChat = thisOne ?? !isNewChat);

  void _toggleColapsed() => setState(() {
        isColapsed = !isColapsed;
        if (!isColapsed) {
          isHover = false;
        }
      });

  void _handleHoverChanged(bool value) {
    if (isHover == value) return;
    setState(() {
      isHover = value;
    });
  }

  String _message = '';
  void _onMessageSending(String text) => setState(() => _message = text);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            layoutBuilder: (currentChild, previousChildren) {
              return Stack(
                alignment: Alignment.centerLeft,
                children: [
                  ...previousChildren,
                  if (currentChild != null) currentChild,
                ],
              );
            },
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SizeTransition(
                  sizeFactor: animation,
                  axis: Axis.horizontal,
                  axisAlignment: -1,
                  child: child,
                ),
              );
            },
            child: isColapsed
                ? _Colapsed(
                    key: const ValueKey('collapsed-panel'),
                    isColapsed: isColapsed,
                    isHover: isHover,
                    onHoverChanged: _handleHoverChanged,
                    onToggleColapsed: _toggleColapsed,
                    onToggleNewChat: _toggleNewChat,
                  )
                : _Expanded(
                    key: const ValueKey('expanded-panel'),
                    isColapsed: isColapsed,
                    onToggleColapsed: _toggleColapsed,
                    sessionUuid: widget.sessionUuid,
                    onToggleNewChat: _toggleNewChat,
                  ),
          ),
          Expanded(
            child: isNewChat
                ? _StartNewChat(
                    toggleNewChat: _toggleNewChat,
                    onMessageSending: _onMessageSending,
                  )
                : ChatSection(
                    chatId: 'user',
                    initialMessage: _message,
                  ),
          ),
        ],
      ),
    );
  }
}

class _StartNewChat extends StatefulWidget {
  final void Function({bool? thisOne}) toggleNewChat;
  final void Function(String) onMessageSending;
  const _StartNewChat({required this.toggleNewChat, required this.onMessageSending});

  @override
  State<_StartNewChat> createState() => __StartNewChatState();
}

class __StartNewChatState extends State<_StartNewChat> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _sendingMessageController = TextEditingController();
  String _message = '';

  void _onSending(BuildContext context) async {
    _focusNode.unfocus();
    _sendingMessageController.clear();
    if (context.mounted) {
      widget.onMessageSending(_message);
      setState(() => _message = '');
      Future.delayed(const Duration(milliseconds: 333), () => widget.toggleNewChat());
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Let's get you started with a model.",
            style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: kHPadding),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth / 5),
            child: Wrap(
              spacing: kHPadding,
              runSpacing: kHPadding,
              children: List.generate(
                4,
                (index) {
                  return Container(
                    height: 100,
                    width: constraints.maxWidth / 4,
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: kHPadding),
          Text(
            "What can I help you with?",
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(height: kHPadding),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth / 5),
            child: CallbackShortcuts(
              bindings: <ShortcutActivator, VoidCallback>{
                const SingleActivator(LogicalKeyboardKey.enter): () {
                  if (_sendingMessageController.text.trim().isNotEmpty) {
                    _onSending(context);
                  }
                },
              },
              child: TextField(
                minLines: 1,
                maxLines: 5,
                controller: _sendingMessageController,
                focusNode: _focusNode,
                onTapOutside: (_) => _focusNode.unfocus(),
                onChanged: (text) => setState(() => _message = text.trim()),
                cursorColor: Theme.of(context).primaryColor,
                style:
                    Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).primaryIconTheme.color),
                autocorrect: false,
                enableSuggestions: false,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).iconTheme.color!, width: 1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).iconTheme.color!, width: 1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  contentPadding: const EdgeInsets.only(
                    left: kHPadding,
                    top: 3 + kHPadding,
                    right: kHPadding,
                    bottom: kHPadding,
                  ),
                  hintText: 'Aa',
                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                  suffixIcon: _message != ''
                      ? GestureDetector(
                          onTap: () => _onSending(context),
                          child: Icon(
                            Icons.send_rounded,
                            size: 32,
                            color: Theme.of(context).primaryColor,
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
              ),
            ),
          ),
        ],
      );
    });
  }
}

double measureTextHeight(BuildContext context, String text, TextStyle style) {
  final TextPainter painter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: 1,
    textDirection: Directionality.of(context),
  )..layout();
  return painter.height;
}

class _Colapsed extends StatelessWidget {
  final bool isColapsed;
  final bool isHover;
  final ValueChanged<bool> onHoverChanged;
  final VoidCallback onToggleColapsed;
  final void Function({bool? thisOne}) onToggleNewChat;

  const _Colapsed({
    super.key,
    required this.isColapsed,
    required this.isHover,
    required this.onHoverChanged,
    required this.onToggleColapsed,
    required this.onToggleNewChat,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(kHPadding),
      width: 68,
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MouseRegion(
            onEnter: (_) => onHoverChanged(true),
            onExit: (_) => onHoverChanged(false),
            child: isHover
                ? IconButton(
                    onPressed: () {
                      onHoverChanged(false);
                      onToggleColapsed();
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints.tightFor(width: 36, height: 36),
                    icon: Icon(
                      isColapsed ? Icons.arrow_forward_ios_outlined : Icons.arrow_back_ios_outlined,
                      size: 18,
                    ),
                  )
                : SvgPicture.asset(
                    'assets/images/playground_logo.svg',
                    width: 36,
                    height: 36,
                    fit: BoxFit.contain,
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 24),
            child: MaterialButton(
              onPressed: () => onToggleNewChat(thisOne: true),
              minWidth: 0,
              elevation: 0,
              highlightElevation: 0,
              padding: EdgeInsets.zero,
              child: Icon(
                CustomOutlinedIcons.new_icon,
                color: Colors.white70,
              ),
            ),
          ),
          Expanded(child: const SizedBox.shrink()),
          const SizedBox(height: 12),
          Stack(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white12,
                child: Text(
                  'GU',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                ),
              ),
              Positioned.fill(
                child: Builder(
                  builder: (buttonContext) {
                    return MaterialButton(
                      onPressed: () async {
                        final RenderBox? button = buttonContext.findRenderObject() as RenderBox?;
                        final OverlayState overlayState = Overlay.of(buttonContext);
                        final RenderBox? overlay = overlayState.context.findRenderObject() as RenderBox?;
                        if (button == null || overlay == null) {
                          return;
                        }

                        final double menuWidth = MediaQuery.of(context).size.width / 5 - 2 * kHPadding;
                        final textTheme = Theme.of(buttonContext).textTheme;
                        final TextStyle textStyle = textTheme.bodyLarge!.copyWith(color: Colors.white);
                        final menuOptions = <_MenuOption<String>>[
                          const _MenuOption<String>(
                            value: 'settings',
                            iconData: CustomOutlinedIcons.setting,
                            label: 'Settings',
                          ),
                          const _MenuOption<String>(
                            value: 'log_out',
                            iconData: CustomOutlinedIcons.logout,
                            label: 'Log out',
                          ),
                        ];

                        final List<double> itemHeights = <double>[];
                        double totalItemHeight = 0;
                        for (final option in menuOptions) {
                          final double entryHeight = measureTextHeight(buttonContext, option.label, textStyle) +
                              (menuOptions.length * kVPadding / 2);
                          itemHeights.add(entryHeight);
                          totalItemHeight += entryHeight;
                        }
                        final double menuHeight = totalItemHeight + kHPadding;

                        final Offset buttonTopLeft = button.localToGlobal(Offset.zero, ancestor: overlay);
                        double left = buttonTopLeft.dx;
                        final double overlayWidth = overlay.size.width;
                        if (left + menuWidth > overlayWidth) {
                          left = overlayWidth - menuWidth;
                        }
                        if (left < 0) {
                          left = 0;
                        }
                        final double buttonHeight = button.size.height;
                        double top = buttonTopLeft.dy - menuHeight;
                        if (top < 0) {
                          top = buttonTopLeft.dy + buttonHeight;
                        }
                        if (top + menuHeight > overlay.size.height) {
                          top = overlay.size.height - menuHeight;
                        }
                        if (top < 0) {
                          top = 0;
                        }
                        final double right = overlayWidth - left - menuWidth;

                        final completer = Completer<String?>();
                        final controller = AnimationController(
                          duration: const Duration(milliseconds: 333),
                          reverseDuration: const Duration(milliseconds: 333),
                          vsync: overlayState,
                        );
                        final animation = CurvedAnimation(
                          parent: controller,
                          curve: Curves.easeOutCubic,
                          reverseCurve: Curves.easeInCubic,
                        );

                        late OverlayEntry entry;
                        var dismissed = false;

                        Future<void> closeMenu([String? value]) async {
                          if (dismissed) {
                            return;
                          }
                          dismissed = true;
                          await controller.reverse();
                          entry.remove();
                          controller.dispose();
                          if (!completer.isCompleted) {
                            completer.complete(value);
                          }
                        }

                        entry = OverlayEntry(
                          builder: (context) {
                            return Stack(
                              children: [
                                Positioned.fill(
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () => closeMenu(),
                                    child: const SizedBox.shrink(),
                                  ),
                                ),
                                Positioned(
                                  left: left,
                                  top: top,
                                  right: right < 0 ? 0 : null,
                                  child: FadeTransition(
                                    opacity: animation,
                                    child: Material(
                                      color: Colors.transparent,
                                      child: Container(
                                        width: menuWidth,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade900,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        padding: const EdgeInsets.symmetric(vertical: kHPadding / 2),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: List.generate(menuOptions.length, (index) {
                                            final option = menuOptions[index];
                                            return SizedBox(
                                              height: itemHeights[index],
                                              child: InkWell(
                                                onTap: () => closeMenu(option.value),
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                                  child: Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Row(
                                                      children: [
                                                        Icon(option.iconData, size: 18, color: Colors.white),
                                                        const SizedBox(width: 6),
                                                        Text(option.label, style: textStyle),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                        overlayState.insert(entry);
                        controller.forward();
                        await completer.future;
                      },
                      minWidth: 0,
                      elevation: 0,
                      highlightElevation: 0,
                      padding: EdgeInsets.zero,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MenuOption<T> {
  final T value;
  final IconData iconData;
  final String label;
  const _MenuOption({required this.value, required this.iconData, required this.label});
}

class _Expanded extends StatelessWidget {
  final bool isColapsed;
  final VoidCallback onToggleColapsed;
  final String sessionUuid;
  final void Function({bool? thisOne}) onToggleNewChat;

  const _Expanded({
    super.key,
    required this.isColapsed,
    required this.onToggleColapsed,
    required this.sessionUuid,
    required this.onToggleNewChat,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(kHPadding),
      width: MediaQuery.of(context).size.width / 5,
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              MaterialButton(
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (dialogContext) {
                      return Dialog(
                        backgroundColor: Colors.grey.shade900,
                        insetPadding: EdgeInsets.symmetric(horizontal: MediaQuery.of(dialogContext).size.width / 3),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(kHPadding),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'LLM Playground',
                                    style: Theme.of(dialogContext).textTheme.titleLarge?.copyWith(color: Colors.white),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () => Navigator.of(dialogContext).pop(),
                                    icon: const Icon(Icons.close, color: Colors.white70),
                                  ),
                                ],
                              ),
                              Text(
                                'Version 1.0.0',
                                style: Theme.of(dialogContext).textTheme.bodySmall?.copyWith(color: Colors.white54),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 24),
                                child: Text(
                                  'LLM Playground is a portal to try out demo versioning of various LLM models. ',
                                  style: Theme.of(dialogContext).textTheme.bodyMedium!.copyWith(color: Colors.white),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () => Navigator.of(dialogContext).pop(),
                                  child: Text(
                                    'Close',
                                    style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                minWidth: 0,
                elevation: 0,
                highlightElevation: 0,
                padding: EdgeInsets.zero,
                child: SvgPicture.asset(
                  'assets/images/playground_logo.svg',
                  width: 36,
                  height: 36,
                  fit: BoxFit.contain,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: onToggleColapsed,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(width: 36, height: 36),
                icon: Icon(
                  isColapsed ? Icons.arrow_forward_ios_outlined : Icons.arrow_back_ios_outlined,
                  size: 18,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 24),
            child: Stack(
              children: [
                Row(
                  children: [
                    Icon(
                      CustomOutlinedIcons.new_icon,
                      color: Colors.white70,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'New chat',
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white70),
                      ),
                    ),
                  ],
                ),
                Positioned.fill(
                  child: MaterialButton(
                    onPressed: () {
                      Future.delayed(const Duration(milliseconds: 150), onToggleColapsed);
                      onToggleNewChat(thisOne: true);
                    },
                    minWidth: 0,
                    elevation: 0,
                    highlightElevation: 0,
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Chats',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return MaterialButton(
                        onPressed: () {
                          Future.delayed(const Duration(milliseconds: 150), onToggleColapsed);
                        },
                        minWidth: 0,
                        elevation: 0,
                        highlightElevation: 0,
                        padding: EdgeInsets.all(kHPadding),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        color: Colors.transparent,
                        splashColor: Colors.white.withValues(alpha: 0.1),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              "(MODEL_NAME) Some Sample Chat Title $index",
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white),
                            ),
                            Text(
                              "18999348948934",
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white70),
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: 10,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 0.2, thickness: 0.2, color: Colors.grey),
          const SizedBox(height: 12),
          Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white12,
                    child: Text(
                      'GU',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Guest User',
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                        ),
                        Text(
                          sessionUuid,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Icon(CustomOutlinedIcons.setting, color: Colors.white70),
                ],
              ),
              Positioned.fill(
                child: Builder(
                  builder: (buttonContext) {
                    return MaterialButton(
                      onPressed: () async {
                        final RenderBox? button = buttonContext.findRenderObject() as RenderBox?;
                        final OverlayState overlayState = Overlay.of(buttonContext);
                        final RenderBox? overlay = overlayState.context.findRenderObject() as RenderBox?;
                        if (button == null || overlay == null) {
                          return;
                        }

                        final double menuWidth = MediaQuery.of(context).size.width / 5 - 2 * kHPadding;
                        final textTheme = Theme.of(buttonContext).textTheme;
                        final TextStyle textStyle = textTheme.bodyLarge!.copyWith(color: Colors.white);
                        final menuOptions = <_MenuOption<String>>[
                          const _MenuOption<String>(
                            value: 'settings',
                            iconData: CustomOutlinedIcons.setting,
                            label: 'Settings',
                          ),
                          const _MenuOption<String>(
                            value: 'log_out',
                            iconData: CustomOutlinedIcons.logout,
                            label: 'Log out',
                          ),
                        ];

                        final List<double> itemHeights = <double>[];
                        double totalItemHeight = 0;
                        for (final option in menuOptions) {
                          final double entryHeight = measureTextHeight(buttonContext, option.label, textStyle) +
                              (menuOptions.length * kVPadding / 2);
                          itemHeights.add(entryHeight);
                          totalItemHeight += entryHeight;
                        }
                        final double menuHeight = totalItemHeight + kHPadding;

                        final Offset buttonTopLeft = button.localToGlobal(Offset.zero, ancestor: overlay);
                        double left = buttonTopLeft.dx;
                        final double overlayWidth = overlay.size.width;
                        if (left + menuWidth > overlayWidth) {
                          left = overlayWidth - menuWidth;
                        }
                        if (left < 0) {
                          left = 0;
                        }
                        final double buttonHeight = button.size.height;
                        double top = buttonTopLeft.dy - menuHeight;
                        if (top < 0) {
                          top = buttonTopLeft.dy + buttonHeight;
                        }
                        if (top + menuHeight > overlay.size.height) {
                          top = overlay.size.height - menuHeight;
                        }
                        if (top < 0) {
                          top = 0;
                        }
                        final double right = overlayWidth - left - menuWidth;

                        final completer = Completer<String?>();
                        final controller = AnimationController(
                          duration: const Duration(milliseconds: 333),
                          reverseDuration: const Duration(milliseconds: 333),
                          vsync: overlayState,
                        );
                        final animation = CurvedAnimation(
                          parent: controller,
                          curve: Curves.easeOutCubic,
                          reverseCurve: Curves.easeInCubic,
                        );

                        late OverlayEntry entry;
                        var dismissed = false;

                        Future<void> closeMenu([String? value]) async {
                          if (dismissed) {
                            return;
                          }
                          dismissed = true;
                          await controller.reverse();
                          entry.remove();
                          controller.dispose();
                          if (!completer.isCompleted) {
                            completer.complete(value);
                          }
                        }

                        entry = OverlayEntry(
                          builder: (context) {
                            return Stack(
                              children: [
                                Positioned.fill(
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () => closeMenu(),
                                    child: const SizedBox.shrink(),
                                  ),
                                ),
                                Positioned(
                                  left: left,
                                  top: top,
                                  right: right < 0 ? 0 : null,
                                  child: FadeTransition(
                                    opacity: animation,
                                    child: Material(
                                      color: Colors.transparent,
                                      child: Container(
                                        width: menuWidth,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade900,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        padding: const EdgeInsets.symmetric(vertical: kHPadding / 2),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: List.generate(menuOptions.length, (index) {
                                            final option = menuOptions[index];
                                            return SizedBox(
                                              height: itemHeights[index],
                                              child: InkWell(
                                                onTap: () => closeMenu(option.value),
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                                  child: Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Row(
                                                      children: [
                                                        Icon(option.iconData, size: 18, color: Colors.white),
                                                        const SizedBox(width: 6),
                                                        Text(option.label, style: textStyle),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                        overlayState.insert(entry);
                        controller.forward();
                        await completer.future;
                      },
                      minWidth: 0,
                      elevation: 0,
                      highlightElevation: 0,
                      padding: EdgeInsets.zero,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
