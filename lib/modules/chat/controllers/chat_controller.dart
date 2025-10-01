import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:wingai/core/constants/base_url.dart';
import 'package:wingai/core/constants/enum.dart';
import 'package:wingai/core/helpers/convert.dart';
import 'package:wingai/core/service/api/connect.dart';
import 'package:wingai/core/service/api/endpoint.dart';
import 'package:wingai/core/service/firebase/api.service.dart';
import 'package:wingai/core/service/token_service.dart';
import 'package:wingai/core/utils/exception_handler.dart';
import 'package:wingai/modules/chat/controllers/topic_controller.dart';
import 'package:wingai/modules/chat/models/ai_chat_model.dart';
import 'package:wingai/modules/chat/models/chat_topic_model.dart';
import 'package:wingai/modules/chat/models/message_model.dart';
import 'package:wingai/modules/chat/models/web_hook_talk_model.dart';
import 'package:wingai/widgets/dialog/custom_form_field_widget.dart';

class ChatController extends GetxController {
  final topicController = Get.find<TopicController>();
  final _firebaseService = Get.find<FirebaseService>();
  TokenManager tokenManager = TokenManager();

  final TextEditingController textEditingController = TextEditingController();
  final GlobalKey<AnimatedListState> suggestslistKey = GlobalKey<AnimatedListState>();
  final ScrollController scrollController = ScrollController();
  final RxList<Message> messages = <Message>[].obs;
  final RxBool isTyping = false.obs;

  RxInt selectedModelIndex = 0.obs;
  RxString selectedModelName = 'ChatGPT-41'.obs;
  Rx<ModelType> model = ModelType.ChatGPT.obs;
  List<Map<String, dynamic>> aiModels = [
    {
      "image": "assets/images/rnd_logo.jpeg",
      "title": "N8N Webhook Talk",
      "subFetures": ["BRAINSTORM", "IDEA", "SEARCH"],
      "model": ModelType.WebhookTalk,
    },
    {
      "image": "assets/images/support.png",
      "title": "HR policy Agent",
      "subFetures": ["BRAINSTORM", "IDEA", "SEARCH"],
      "model": ModelType.HR_Policy,
    },
    {
      "image": "assets/images/deepseek.png",
      "title": "DeepSeek-V3",
      "subFetures": ["BRAINSTORM", "IDEA", "SEARCH"],
      "model": ModelType.DEEPSEEK,
    },
    {
      "image": "assets/images/meta.png",
      "title": "Meta",
      "subFetures": ["BRAINSTORM", "IDEA", "SEARCH"],
      "model": ModelType.Meta_FaceBook,
    },
    // {
    //   "image": "assets/images/grok.png",
    //   "title": "Grok",
    //   "subFetures": ["BRAINSTORM", "IDEA", "SEARCH"],
    //   "model": ModelType.Tesla_AI,
    // },
    // {
    //   "image": "assets/images/deepseek.png",
    //   "title": "DeepSeek-R1",
    //   "subFetures": ["HIGHLOGIC", "MATHEMATICS", "REASONING"],
    //   "model": ModelType.DEEPSEEK,
    // },
  ];

  List<String> suggesteds = [
    "What is Wing Bank?",
    "Write me an email for ...",
    "Do you think AI is the good way?",
    "Tell me a good way open Wing Bank account",
  ];
  // RxString suggested = ''.obs;
  List previousChats = [];

  @override
  void onInit() async {
    await topicController.setChatTopics();
    await topicController.userInfo();
    switchAIModel(0);
    await getChatMessagesByTopic();
    super.onInit();
  }

  @override
  void onClose() {
    textEditingController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void switchAIModel(int modelIndex) {
    selectedModelIndex.value = modelIndex;
    selectedModelName.value = aiModels[modelIndex]["title"];
    model.value = aiModels[modelIndex]["model"];
    tokenManager.setToken(model.value);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> getChatMessagesByTopic() async {
    String currentTopicId = topicController.currentTopic.value.chatId.toString();

    List dataRespond = await _firebaseService.getsubColletionDocuments(
      'chats',
      currentTopicId,
      'messages',
    );
    if (dataRespond.isNotEmpty) {
      final List<Message> message0 = [];
      for (var chat in dataRespond) {
        {
          final message = Message(
            text: chat.data()['text'],
            isMe: chat.data()['sender'] == 'user' ? true : false,
            aiModelType: chat.data()['aiModel'],
            timestamp: DateTime.fromMicrosecondsSinceEpoch(
              chat.data()['createdAt'],
            ),
          );
          message0.add(message);
        }
      }
      messages.value = message0;
      _scrollToBottom();
    } else {
      messages.value = [];
    }
  }

  Future getPreviousChat() async {
    try {
      previousChats = [];
      final chatTpics = await getTopicId();
      List dataRespond = await _firebaseService.getLimitSubColletionDocuments('chats', chatTpics, 'messages', 10);
      if (dataRespond.isNotEmpty) {
        for (var chat in dataRespond) {
          {
            var data = {
              "role": chat.data()['sender'] == 'user' ? 'user' : 'assistant',
              "content": chat.data()['text'],
            };
            previousChats.add(data);
          }
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future getTopicId({String? topicTitle}) async {
    String currentTopicId = topicController.currentTopic.value.chatId.toString();
    if (currentTopicId == 'null') {
      await topicController.createChatTopic(topicTitle: 'New Conversation');
      String tempTopicId = topicController.currentTopic.value.chatId.toString();

      // Generate real topic in background
      aiGenerateTopic(topicTitle!).then((generatedTitle) async {
        await topicController.updateChatTopicTitle(
          generatedTitle,
          tempTopicId,
        );
      });
      return tempTopicId;
    } else {
      return topicController.currentTopic.value.chatId.toString();
    }
  }
  // Future getTopicId({String? topicTitle}) async {
  //   String currentTopicId = topicController.currentTopic.value.chatId.toString();
  //   if (currentTopicId == 'null') {
  //     String topic = await aiGenerateTopic(topicTitle!);
  //     await topicController.createChatTopic(topicTitle: topic);
  //     return topicController.currentTopic.value.chatId.toString();
  //   } else {
  //     return topicController.currentTopic.value.chatId.toString();
  //   }
  // }

  Future<void> sendMessage(String text) async {
    try {
      if (text.trim().isEmpty) return;
      String currentTopicId = await getTopicId(topicTitle: text.trim());
      var sendData = {
        "createdAt": DateTime.now().millisecondsSinceEpoch,
        "sender": 'user',
        "aiModel": model.value.toString(),
        "text": text.trim(),
      };
      textEditingController.clear();
      // get 10 previouse chats for ai chat memory so it know what are we chat about
      await getPreviousChat();
      // save current chat to firebase
      await _firebaseService.setSub('chats', currentTopicId, 'messages', sendData);

      final message = Message(text: text, isMe: true, timestamp: DateTime.now());
      messages.add(message);
      _scrollToBottom();
      getAIRespondMessage(text);
    } catch (exception, trace) {
      exceptionHandler(exception, trace, alert: true);
    }
  }

  Future<String> aiGenerateTopic(String userInput) async {
    String chatTitleProm =
        "create one sentence for chat communication title base on user input, here is what user input:$userInput. the chat title should be a short sentence that have colorful noto-emoji infront that represent the title. i expect to see the return only one sentence with sticker in front topic title with no Double quotes";
    var data = {"role": 'user', "content": chatTitleProm};
    String title = await chatWitDEEPSEEK([data]);
    return removeSurroundingQuotes(title);
  }

  Future<void> getAIRespondMessage(String userMesage) async {
    try {
      isTyping.value = true;
      String currentTopicId = await getTopicId();
      var data = {"role": 'user', "content": userMesage};
      previousChats.add(data);
      String respondMessage = await aiModel(previousChats, message: userMesage);
      String response = respondMessage;
      var aiRespond = {
        "createdAt": DateTime.now().millisecondsSinceEpoch,
        "sender": 'bot',
        "aiModel": model.value.toString(),
        "text": response,
      };
      await _firebaseService.setSub('chats', currentTopicId, 'messages', aiRespond);
      final message = Message(
        text: response,
        aiModelType: model.value.toString(),
        isMe: false,
        timestamp: DateTime.now(),
      );
      isTyping.value = false;
      messages.add(message);
      _scrollToBottom();
    } catch (exception, trace) {
      isTyping.value = false;
      exceptionHandler(exception, trace, alert: true);
    }
  }

  Future aiModel(List<dynamic> chatLists, {String? message}) async {
    switch (model.value) {
      case ModelType.ChatGPT:
        return chatWithGPT(chatLists);
      case ModelType.DEEPSEEK:
        return chatWitDEEPSEEK(chatLists);
      case ModelType.WebhookTalk:
        return chatWithN8NWebhookTalk(message!);
      case ModelType.HR_Policy:
        return chatWithHR(message!);
      case ModelType.Meta_FaceBook:
        return chatWithLAMA(chatLists);
      default:
        return chatWitDEEPSEEK(chatLists);
    }
  }

  Future<String> chatWithN8NWebhookTalk(String userMessage) async {
    var dataRespond = await Get.find<ApiService>().post(
      Endpoints.webhookTalk,
      baseUrl: AppBaseUrl.n8nWebhookTalkUrl,
      {
        "last_question": "",
        "session_id": "e67cf800-d56a-14dc-9330-23b5d2e1db0a-1752201916723422",
        "e_wac_id":
            "S5B179faaNecVpO6n1Z01R3lRiqi5ek7sJ0pw3qfIg5rXtLVPAcRk2mE9K8Q0K+AqjGFfb4QjTaSlpUUwT6yDSd8x96r0K58aYkKDDSN0+wmoi79yQA4REI3vfSexIilURoKPW6BXiy1VF8hTbvIf9es18D2bui8Rr//4lyD8Tjia0XWXYHptQqMkv11oEO/JfD+EDWhejcSqkXj9w2Fe22ailB5puiwjFGngMAu/72PMR5SFA0v2I5nPBU4NEXAWqL81Yn6pgS5gxDMhe1nzyVb9fVPRcq8imSKL2slKBTTEnD46c0m7ujvtAlaUzEyhU3DJz3wxLHlQTaKZ9Bh8Q==",
        "e_phone_number":
            "ZNLKqVKzeS3004gE5nFSiS62ZCwx6mxcl35ZaZi1+emWGv9MfhrPVaIKb43h6iJz4iMTX94S+u+aAxk2EQPkRmzsipaoxsc7CoTS4P9IRdyzdSs3fdSF8PN7zCcGHFzhV4U8FqYPg8iarymCEcbxVuOBh90Sq58Nru5MI0Xw+MJXG/qIHZwpWZ4dNB0WBbDiRgsqoELXBvmR8Hp1t1zsCBRm90JxJVL5odizgW6lxlt1AF7WkIpN+SnBn7MFpyoJdblPx1SioFSTx7enXrhSuYuXKj1I9UMi5u+8IbdkRHuM6Yt2gtZuyre5GLbuICYlfE/5XarC8YvQkNr029maUA==",
        "is_only_text": true,
        "speaker_name": "tevi",
        "special_input": userMessage
      },
      cusHeaders: {
        "Content-Type": "application/json",
        "Authorization": "Basic bjhuOmdlbmVyYXRpdmVBSQ==",
      },
    );
    WebhookTalkModel aiChatModel = WebhookTalkModel.fromJson(dataRespond.data[0]);

    return aiChatModel.resText.toString();
  }

  Future<String> chatWitDEEPSEEK(List<dynamic> chatLists) async {
    var url = Uri.https('api.fireworks.ai', '/inference/v1/chat/completions');

    var body = jsonEncode({
      "model": "accounts/fireworks/models/deepseek-v3",
      "max_tokens": 16384,
      "top_p": 1,
      "top_k": 40,
      "presence_penalty": 0,
      "frequency_penalty": 0,
      "temperature": 0.6,
      "messages": chatLists,
    });

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer fw_3ZJaNMsyDWzmLqrcY9LSTYpS',
    };

    var response = await http.post(url, body: body, headers: headers);

    var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

    AIChatModel aiChatModel = AIChatModel.fromJson(jsonResponse["choices"][0]);
    return aiChatModel.aImessage!.content.toString();
  }

  Future<String> chatWithLAMA(List<dynamic> chatLists) async {
    var url = Uri.https('api.fireworks.ai', '/inference/v1/chat/completions');

    var body = jsonEncode({
      "model": "accounts/fireworks/models/llama-v3p3-70b-instruct",
      "max_tokens": 16384,
      "top_p": 1,
      "top_k": 40,
      "presence_penalty": 0,
      "frequency_penalty": 0,
      "temperature": 0.6,
      "messages": chatLists
    });

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer fw_3ZJaNMsyDWzmLqrcY9LSTYpS',
    };

    var response = await http.post(url, body: body, headers: headers);
    var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

    AIChatModel aiChatModel = AIChatModel.fromJson(jsonResponse["choices"][0]);
    return aiChatModel.aImessage!.content.toString();
  }

  Future<String> chatWithHR(String userMessage) async {
    var url = Uri.https('uat-flowise.winginnovation.com', '/api/v1/prediction/d0ce396f-2302-433c-a6c7-5427811e42db');

    var body = jsonEncode({
      "question": userMessage,
    });

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    var response = await http.post(url, body: body, headers: headers);
    var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

    // AIChatModel aiChatModel = AIChatModel.fromJson(jsonResponse["text"]);
    return jsonResponse["text"].toString();
  }

  Future<String> chatWithGPT(List<dynamic> chatLists) async {
    var dataRespond = await Get.find<ApiService>().post(
      Endpoints.chat,
      baseUrl: AppBaseUrl.openAIBaseUrl,
      {"model": "gpt-4o-mini", "messages": chatLists},
    );
    AIChatModel aiChatModel = AIChatModel.fromJson(dataRespond.data["choices"][0]);
    return aiChatModel.aImessage!.content.toString();
  }

  Future changeTopic(ChatTopicModel topic) async {
    topicController.switchTopic(topic);
    await getChatMessagesByTopic();
  }

  Future newTopic() async {
    RxList<ChatTopicModel> topics = topicController.topics;

    if (topics.isNotEmpty) {
      var chats = await _firebaseService.getsubColletionDocuments(
        'chats',
        topics[0].chatId.toString(),
        'messages',
      );
      if ((messages.isNotEmpty || topicController.currentTopic.value.chatId.toString() == 'null') && chats.isNotEmpty) {
        // await topicController.createChatTopic();
        topicController.clearCurrentTopic();
        messages.value = [];
      }
    }
  }

  Future deleteTopic(String topicId) async {
    await topicController.deleteChatTopic(topicId);
    messages.value = [];
  }

  Future updateTopic(String chatTitle, chatId) async {
    if (chatTitle.trim() != "") {
      await topicController.updateChatTopicTitle(chatTitle, chatId);
      Get.close(1);
    }
  }

  void showTopicEditDialog(String chatId) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: CustomDialogFormFieldWidget(
            title: "Edit Chat Topic",
            controller: topicController.chatTopicController,
            onSubmit: () {
              updateTopic(topicController.chatTopicController.text, chatId);
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Close", style: TextStyle(fontSize: 16)),
            ),
          ],
        );
      },
    );
  }

  Future signOut() async {
    topicController.signOut();
  }
}
