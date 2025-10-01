import 'package:get/get.dart';
import 'package:wingai/modules/chat/controllers/chat_controller.dart';
import 'package:wingai/modules/chat/controllers/topic_controller.dart';
import 'package:wingai/modules/chat/controllers/layout_controller.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatController>(() => ChatController());
    Get.lazyPut<TopicController>(() => TopicController());
    Get.lazyPut<LayoutController>(() => LayoutController());
  }
}
