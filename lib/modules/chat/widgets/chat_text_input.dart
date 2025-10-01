import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wingai/core/themes/styles.dart';
import 'package:wingai/modules/chat/widgets/icon_image.dart';

class ChatTextInput extends StatefulWidget {
  final TextEditingController controller;
  final void Function(String text) onSend;
  final bool loading;

  const ChatTextInput({
    super.key,
    required this.onSend,
    required this.controller,
    this.loading = false,
  });

  @override
  _ChatTextInputState createState() => _ChatTextInputState();
}

class _ChatTextInputState extends State<ChatTextInput> {
  final FocusNode _textFieldFocus = FocusNode();
  final FocusNode _keyboardFocus = FocusNode();
  @override
  void initState() {
    super.initState();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    final isEnter = event.logicalKey == LogicalKeyboardKey.enter;
    final isShift = RawKeyboard.instance.keysPressed.contains(LogicalKeyboardKey.shiftLeft) ||
        RawKeyboard.instance.keysPressed.contains(LogicalKeyboardKey.shiftRight);

    if (isEnter && !isShift) {
      // Unfocus to prevent the newline
      _textFieldFocus.unfocus();

      final text = widget.controller.text.trim();
      if (text.isNotEmpty && widget.loading == false) {
        widget.onSend(text);
        widget.controller.clear();
      }

      // Refocus after a short delay to keep UX smooth
      Future.delayed(
        const Duration(milliseconds: 100),
        () {
          _textFieldFocus.requestFocus();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 8, right: 8, left: 3),
      // margin: const EdgeInsets.only(bottom: 24),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(24),
        ),
        color: AppColors.chatTextInputBackgroundColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 200,
            ),
            child: KeyboardListener(
              focusNode: _keyboardFocus,
              onKeyEvent: _handleKeyEvent,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: TextField(
                  controller: widget.controller,
                  focusNode: _textFieldFocus,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: AppColors.lightGreyBackground,
                      ),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: 'Send a Message',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  children: [
                    Flexible(
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.add,
                          color: AppColors.lightGreyIconColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      flex: 6,
                      child: SizedBox(
                        width: 155,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.all(8),
                            side: const BorderSide(width: 0.0, color: Colors.transparent),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () {},
                          child: Row(
                            children: [
                              const Flexible(
                                child: IconImage(
                                  imagePath: 'assets/images/terminal.png',
                                  onTap: null,
                                  size: 20.0,
                                ),
                                //  Icon(
                                //   Icons.terminal,
                                //   color: AppColors.lightGreyIconColor,
                                // ),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                flex: 6,
                                child: Text(
                                  "Code Interpreter",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                        color: AppColors.grey,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // const Spacer(),
              const Icon(
                Icons.mic,
                color: AppColors.lightGreyIconColor,
              ),
              const SizedBox(
                width: 6,
              ),
              CircleAvatar(
                radius: 15,
                backgroundColor: Colors.white,
                child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.arrow_upward,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      if (widget.loading == false) {
                        widget.onSend(widget.controller.text);
                        widget.controller.clear();
                      }
                    }),
              )
            ],
          )
        ],
      ),
    );
  }
}
