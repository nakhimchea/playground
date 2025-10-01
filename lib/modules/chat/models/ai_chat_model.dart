import 'dart:convert';
import 'dart:typed_data';

class AIChatModel {
  int? index;
  AIMessage? aImessage;
  Null logprobs;
  String? finishReason;

  AIChatModel({this.index, this.aImessage, this.logprobs, this.finishReason});

  AIChatModel.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    aImessage = json['message'] != null ? AIMessage.fromJson(json['message']) : null;
    logprobs = json['logprobs'];
    finishReason = json['finish_reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['index'] = index;
    if (aImessage != null) {
      data['message'] = aImessage!.toJson();
    }
    data['logprobs'] = logprobs;
    data['finish_reason'] = finishReason;
    return data;
  }
}

class AIMessage {
  String? role;
  String? content;

  AIMessage({
    this.role,
    this.content,
  });

  AIMessage.fromJson(Map<String, dynamic> json) {
    role = json['role'];
    content = (json['content'] is Uint8List) ? utf8.decode(json['content']) : json['content'];
  }
  factory AIMessage.fromJsonx(Map<String, dynamic> json) {
    var content = json['content'];

    if (content is String) {}
    return AIMessage(role: json['role'], content: content);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['role'] = role;
    data['content'] = content;
    return data;
  }
}
