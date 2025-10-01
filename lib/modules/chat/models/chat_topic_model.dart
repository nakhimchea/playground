import 'package:cloud_firestore/cloud_firestore.dart';

class ChatTopicModel {
  String? topic;
  String? chatId;
  Timestamp? updatedAt;
  String? userId;

  ChatTopicModel({this.topic, this.updatedAt, this.userId, this.chatId});

  ChatTopicModel.fromJson(Map<String, dynamic> json) {
    topic = json['topic'];
    chatId = json['chatId'];
    updatedAt = json['updatedAt'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['topic'] = topic;
    data['chatId'] = chatId;
    data['updatedAt'] = updatedAt;
    data['userId'] = userId;
    return data;
  }
}
