import 'package:flutter/material.dart';
import 'package:flutter_markdown_selectionarea/flutter_markdown_selectionarea.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wingai/core/helpers/convert.dart';
import 'package:wingai/core/themes/styles.dart';
import 'package:wingai/modules/chat/controllers/chat_controller.dart';
import 'package:wingai/modules/chat/widgets/chat_text_input.dart';
import 'package:wingai/modules/chat/widgets/code_element_builder.dart';
import 'package:wingai/modules/chat/widgets/suggested_list.dart';

class Chat extends GetView<ChatController> {
  const Chat({super.key});

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(Get.context!).brightness == Brightness.dark ? Colors.grey[800] : Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(0),
                const SizedBox(width: 4),
                _buildDot(1),
                const SizedBox(width: 4),
                _buildDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Interval(index * 0.2, (index + 1) * 0.2, curve: Curves.easeInOut),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, -2 * value),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[400] : Colors.grey[600],
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double wid = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.chatBackgroundColor,
      body: LayoutBuilder(
        builder: ((context, constraints) {
          final width = constraints.maxWidth > 800 ? 800.0 : constraints.maxWidth;
          return Align(
            alignment: Alignment.center,
            child: Container(
              width: width,
              padding: EdgeInsets.symmetric(horizontal: wid * 0.01),
              child: Obx(
                () => Column(
                  children: [
                    Expanded(
                      child: Obx(
                        () => ListView.builder(
                          controller: controller.scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: controller.messages.length + (controller.isTyping.value ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == controller.messages.length) {
                              return _buildTypingIndicator();
                            }
                            final message = controller.messages[index];
                            return Align(
                              alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
                              child: Row(
                                mainAxisAlignment: message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  !message.isMe
                                      ? ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(15),
                                          ),
                                          child: Image.asset(
                                            width: 30,
                                            height: 30,
                                            aiModelImage(message.aiModelType ?? ''),
                                            // "assets/images/rnd_logo.jpeg",
                                            fit: BoxFit.contain,
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                  Flexible(
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: message.isMe ? Colors.white10 : null,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: SelectionArea(
                                        child: MarkdownBody(
                                          data: message.text, // The actual message text
                                          styleSheet: MarkdownStyleSheet.fromTheme(
                                            ThemeData(
                                              textTheme:
                                                  TextTheme(bodyMedium: Theme.of(context).textTheme.titleMedium!),
                                            ),
                                          ),
                                          builders: {
                                            'code': CodeElementBuilder(),
                                          },
                                          onTapLink: (text, href, title) async {
                                            if (href != null) {
                                              final Uri url = Uri.parse(href);
                                              if (await canLaunchUrl(url)) {
                                                await launchUrl(url);
                                              }
                                            }
                                          },
                                          imageBuilder: (uri, title, alt) {
                                            return Image.network(uri.toString()); // Custom image rendering
                                          },
                                          listItemCrossAxisAlignment: MarkdownListItemCrossAxisAlignment.start,

                                          softLineBreak: true,
                                        ),
                                      ),
                                    ),
                                  ),
                                  message.isMe
                                      ? Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: ClipRRect(
                                            borderRadius: const BorderRadius.all(
                                              Radius.circular(15),
                                            ),
                                            child: Image.asset(
                                              width: 30,
                                              height: 30,
                                              "assets/images/user.png",
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    (controller.messages.isEmpty)
                        ? Align(
                            alignment: Alignment.bottomCenter,
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: CircleAvatar(
                                        radius: 20,
                                        backgroundColor: AppColors.white,
                                        child: Obx(
                                          () => ClipRRect(
                                            borderRadius: const BorderRadius.all(Radius.circular(50)),
                                            child: Image.asset(
                                              controller.aiModels[controller.selectedModelIndex.value]["image"],
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    Flexible(
                                      child: Obx(
                                        () => Text(
                                          controller.selectedModelName.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayLarge!
                                              .copyWith(color: AppColors.white),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  "This is OpenAI 4.1 created by Innovation R&D",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(color: AppColors.lightGreyBackground),
                                  overflow: TextOverflow.visible,
                                  maxLines: 1,
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.only(bottom: 12),
                                  child: Obx(
                                    () => ChatTextInput(
                                      controller: controller.textEditingController,
                                      loading: controller.isTyping.value,
                                      onSend: (_) {
                                        controller.sendMessage(controller.textEditingController.text);
                                      },
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0, left: 32.0),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.bolt_outlined,
                                          color: AppColors.lightGreyIconColor,
                                          size: 18,
                                        ),
                                        Text(
                                          "Suggested",
                                          textAlign: TextAlign.start,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(color: AppColors.lightGreyIconColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 18, right: 18),
                                  height: 148,
                                  child: SuggestedList(
                                    items: controller.suggesteds,
                                    onTextSelected: (value) {
                                      controller.textEditingController.text = value;
                                    },
                                  ),
                                )
                              ],
                            ),
                          )
                        : Align(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 24.0),
                                child: Obx(
                                  () => ChatTextInput(
                                    controller: controller.textEditingController,
                                    loading: controller.isTyping.value,
                                    onSend: (_) {
                                      controller.sendMessage(controller.textEditingController.text);
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                    (controller.messages.isEmpty) ? const Spacer() : const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
