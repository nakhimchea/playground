import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wingai/core/service/firebase/api.service.dart';
import 'package:wingai/modules/authentication/controllers/authentication_controller.dart';
import 'package:wingai/modules/chat/models/chat_topic_model.dart';

class TopicController extends GetxController {
  final authController = Get.find<AuthenticationController>();
  final _firebaseService = Get.find<FirebaseService>();

  final RxList<ChatTopicModel> _topics = <ChatTopicModel>[].obs;
  RxString get email => _email;
  final RxString _email = "".obs;
  final Rx<ChatTopicModel> _currentTopic = ChatTopicModel().obs;
  RxList<ChatTopicModel> get topics => _topics;
  Rx<ChatTopicModel> get currentTopic => _currentTopic;

  TextEditingController chatTopicController = TextEditingController();
  RxString topicEditId = ''.obs;

  Future<void> setChatTopics() async {
    try {
      _topics.value = await _firebaseService.getAllTopicsByUser('chats', authController.getUser!.uid);
      if (_topics.isNotEmpty) {
        _currentTopic.value = _topics[0];
      } else {
        _currentTopic.value = ChatTopicModel();
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> createChatTopic({String? topicTitle}) async {
    var topicData = {
      "topic": topicTitle, // DateTime.now().millisecondsSinceEpoch.toString(),
      "updatedAt": DateTime.now(),
      "isActive": true,
      "userId": authController.getUser!.uid,
    };
    await _firebaseService.createTopic('chats', topicData);
    await setChatTopics();
    try {} catch (e) {}
  }

  Future<void> updateChatTopicTitle(String title, String chatId) async {
    var topicData = {
      "topic": title,
    };
    await _firebaseService.set('chats', chatId, topicData);
    _topics.value = await _firebaseService.getAllTopicsByUser('chats', authController.getUser!.uid);
  }

  Future<void> deleteChatTopic(String chatId) async {
    var topicData = {
      "isActive": false,
    };
    await _firebaseService.set('chats', chatId, topicData);
    clearCurrentTopic();
    _topics.value = await _firebaseService.getAllTopicsByUser('chats', authController.getUser!.uid);
  }

  Future<void> switchTopic(ChatTopicModel topic) async {
    _currentTopic.value = topic;
  }

  Future<void> userInfo() async {
    _email.value = authController.getUser!.email.toString();
  }

  void clearCurrentTopic() {
    _currentTopic.value = ChatTopicModel();
  }

  Future<void> signOut() async {
    await authController.signOut();
  }
}
