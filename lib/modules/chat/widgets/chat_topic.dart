import 'package:flutter/material.dart';
import 'package:wingai/core/themes/styles.dart';
import 'package:wingai/modules/chat/models/chat_topic_model.dart';
import 'package:wingai/widgets/popup_menu_widget.dart';

class ChatTopic extends StatelessWidget {
  final String? currentTopicId;
  final ChatTopicModel topicModel;
  final Function()? onTap;
  final Function(dynamic)? onItemPress;
  final Function(dynamic)? onEditTopicPress;

  final TextEditingController? textEditingController;
  const ChatTopic({
    super.key,
    required this.topicModel,
    this.currentTopicId,
    this.onTap,
    this.onItemPress,
    this.textEditingController,
    this.onEditTopicPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 6,
        top: 0,
      ),
      decoration: BoxDecoration(
        color: currentTopicId == topicModel.chatId ? const Color.fromARGB(255, 23, 23, 26) : null,
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        minTileHeight: 0.1,
        minLeadingWidth: 10,
        iconColor: Colors.white,
        onTap: onTap,
        trailing: currentTopicId == topicModel.chatId
            ? PopupMenuWidget(
                items: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.edit_outlined,
                        color: AppColors.lightGreyIconColor,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Rename",
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.delete_outline,
                        color: AppColors.lightGreyIconColor,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Delete",
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                    ],
                  ),
                ],
                offset: const Offset(0, 25),
                onSelected: (value) => onItemPress!(value),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.more_horiz,
                    size: 18,
                  ),
                ),
              )
            : const SizedBox(),
        title: Text(
          topicModel.topic.toString(),
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontFamilyFallback: ['Noto Color Emoji', 'Segoe UI Emoji'],
          ),
          textAlign: TextAlign.left,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
