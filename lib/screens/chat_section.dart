import 'dart:convert' show jsonDecode;

import 'package:animated_text_kit/animated_text_kit.dart' show AnimatedTextKit, FadeAnimatedText;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show LogicalKeyboardKey;

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../config/constant.dart' show kHPadding, kVPadding;
import '../helpers/custom_scroll_physics.dart';
import '../helpers/time_translator.dart';
import '../services/mock_chat_service.dart';
import '../widgets/custom_divider.dart';
import '../widgets/custom_markdown.dart';

class ChatSection extends StatefulWidget {
  final String chatId;
  final String? initialMessage;
  const ChatSection({super.key, required this.chatId, this.initialMessage});

  @override
  State<ChatSection> createState() => _ChatSectionState();
}

class _ChatSectionState extends State<ChatSection> {
  String? _status;
  final MockChatService _chatService = MockChatService();

  void _changeStatus(BuildContext context, String? status) {
    if (context.mounted) setState(() => _status = status);
  }

  @override
  void initState() {
    super.initState();
    _chatService.clearMessages();
    Future.delayed(const Duration(microseconds: 10), () async {
      if (widget.initialMessage != null) {
        _chatService.addMessage('user', widget.initialMessage!);
        await Future.delayed(const Duration(seconds: 1));
        _chatService.addBotResponse('user');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        _MessageStreamer(
          status: _status,
          statusCallback: (status) => _changeStatus(context, status),
          chatService: _chatService,
        ),
        _MessageSender(
          status: _status,
          statusCallback: (status) => _changeStatus(context, status),
          chatService: _chatService,
        ),
      ],
    );
  }
}

class _MessageStreamer extends StatelessWidget {
  final String? status;
  final void Function(String?) statusCallback;
  final MockChatService chatService;

  const _MessageStreamer({
    required this.status,
    required this.statusCallback,
    required this.chatService,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: chatService.messageStream,
      builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
          );
        }

        final messages = snapshot.data!;
        Widget? addMessage;
        if (status != null) {
          addMessage = Padding(
            padding: const EdgeInsets.symmetric(vertical: kVPadding),
            child: Center(
              child: SizedBox(
                height: 30,
                child: AnimatedTextKit(
                  repeatForever: true,
                  animatedTexts: [
                    FadeAnimatedText(
                      status ?? '...',
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(fontSize: 11, color: Theme.of(context).primaryColor),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (messages.isNotEmpty && messages.first['senderUid'] == 'user') {
          addMessage = SizedBox(height: 2 * kVPadding + 15);
        }

        return ListView.builder(
          physics: const CustomScrollPhysics(),
          itemCount: messages.length,
          cacheExtent: 3 * MediaQuery.of(context).size.height,
          reverse: true,
          padding: const EdgeInsets.only(
            left: kHPadding,
            right: kHPadding,
            bottom: kBottomNavigationBarHeight + 2 * kVPadding,
          ),
          itemBuilder: (context, index) {
            final String senderUid = messages.elementAt(index)['senderUid'];
            String chatMessage = messages.elementAt(index)['message'];
            final DateTime dateTime = DateTime.fromMicrosecondsSinceEpoch(messages.elementAt(index)['dateTime']);

            final bool isObject = chatMessage.startsWith('{') && chatMessage.endsWith('}');
            if (isObject) {
              try {
                jsonDecode(chatMessage);
                // Handle object messages if needed
                return const SizedBox.shrink();
              } catch (_) {
                debugPrint("Cannot decode as object.");
              }
            }

            if (index + 1 < messages.length &&
                messages.elementAt(index + 1)['message'] == '###CLEAR_CONTEXT###' &&
                chatMessage == '###CLEAR_CONTEXT###') {
              chatMessage = '';
            }

            return Column(
              crossAxisAlignment: senderUid == 'user' ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                _MessageBubble(
                  chatMessage: chatMessage,
                  dateTime: dateTime,
                  isMe: senderUid == 'user',
                ),
                index == 0 && addMessage != null ? addMessage : const SizedBox.shrink(),
              ],
            );
          },
        );
      },
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final String chatMessage;
  final DateTime dateTime;
  final bool isMe;

  const _MessageBubble({
    required this.chatMessage,
    required this.dateTime,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return !chatMessage.contains('###CLEAR_CONTEXT###')
        ? chatMessage.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(bottom: kVPadding),
                child: Row(
                  mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Builder(builder: (context) {
                          final double charSize = Theme.of(context).textTheme.bodySmall!.fontSize!;
                          final double maxSize = MediaQuery.of(context).size.width * (isMe ? 2 / 3 : 5 / 7);
                          final double width = chatMessage.length < 10
                              ? charSize * 4
                              : 0.6 * charSize * chatMessage.length > maxSize
                                  ? maxSize
                                  : 0.6 * charSize * chatMessage.length;
                          return Container(
                            width: width,
                            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                            child: Text(
                              timeTranslator(AppLocalizations.of(context)!.localeName, dateTime),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(color: Theme.of(context).disabledColor),
                            ),
                          );
                        }),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * (isMe ? 2 / 3 : 5 / 7),
                          ),
                          child: Material(
                            borderRadius: isMe
                                ? const BorderRadius.only(
                                    bottomRight: Radius.circular(5),
                                    topLeft: Radius.circular(30),
                                    bottomLeft: Radius.circular(30),
                                    topRight: Radius.circular(30))
                                : const BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    bottomLeft: Radius.circular(30),
                                    bottomRight: Radius.circular(30),
                                    topRight: Radius.circular(30),
                                  ),
                            color: isMe
                                ? Theme.of(context).primaryColor.withValues(alpha: 0.7)
                                : Theme.of(context).cardColor,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: kHPadding,
                                vertical: kVPadding,
                              ),
                              child: !isMe
                                  ? CustomMarkdown(
                                      chatMessage,
                                      localeAware: AppLocalizations.of(context)!.localeName == 'km',
                                    )
                                  : Text(
                                      chatMessage,
                                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : const SizedBox.shrink()
        : Row(
            children: [
              Expanded(
                child: CustomDivider(
                  color: Theme.of(context).primaryColor,
                  dashWidth: 6,
                  dashHeight: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  'Context Cleared',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).primaryColor),
                ),
              ),
              Expanded(
                child: CustomDivider(
                  color: Theme.of(context).primaryColor,
                  dashWidth: 6,
                  dashHeight: 1,
                ),
              ),
            ],
          );
  }
}

class _MessageSender extends StatefulWidget {
  final String? status;
  final void Function(String?) statusCallback;
  final MockChatService chatService;

  const _MessageSender({
    required this.status,
    required this.statusCallback,
    required this.chatService,
  });

  @override
  _MessageSenderState createState() => _MessageSenderState();
}

class _MessageSenderState extends State<_MessageSender> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _sendingMessageController = TextEditingController();

  String _message = '';

  void _onSending(BuildContext context) async {
    final tempMessage = _message;
    _sendingMessageController.clear();
    if (context.mounted) setState(() => _message = '');

    if (tempMessage.isNotEmpty) {
      widget.statusCallback('Sending...');

      // Add user message
      widget.chatService.addMessage('user', tempMessage);

      // Simulate AI thinking
      await Future.delayed(const Duration(seconds: 1));

      widget.statusCallback('AI is thinking...');

      // Simulate AI response
      await Future.delayed(const Duration(seconds: 2));

      // Add bot response
      widget.chatService.addBotResponse('user');
    }
    widget.statusCallback(null);
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        margin: const EdgeInsets.only(
          left: kHPadding,
          right: kHPadding,
          bottom: kVPadding,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor,
              offset: const Offset(0, -2),
              blurRadius: 10,
            ),
          ],
        ),
        child: CallbackShortcuts(
          bindings: <ShortcutActivator, VoidCallback>{
            const SingleActivator(LogicalKeyboardKey.enter): () {
              if (widget.status == null && _sendingMessageController.text.trim().isNotEmpty) {
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
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).primaryIconTheme.color),
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
                top: 3,
                right: kHPadding,
              ),
              hintText: 'Aa',
              hintStyle: Theme.of(context).textTheme.bodyMedium,
              suffixIcon: _message != '' && widget.status == null
                  ? GestureDetector(
                      onTap: () => _onSending(context),
                      child: Icon(
                        Icons.send_rounded,
                        size: 32,
                        color:
                            widget.status != null ? Theme.of(context).iconTheme.color : Theme.of(context).primaryColor,
                      ),
                    )
                  : Wrap(
                      runAlignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 5,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            widget.chatService.clearMessages();
                            widget.chatService.addMessage('bot', 'Chat cleared! How can I help you?');
                          },
                          child: Icon(
                            Icons.cut_rounded,
                            size: 32,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(width: kVPadding),
                      ],
                    ),
            ),
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
          ),
        ),
      ),
    );
  }
}
