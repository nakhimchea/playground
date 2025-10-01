class WebhookTalkModel {
  String? audioB64;
  String? resText;
  String? reqText;
  String? sessionId;

  WebhookTalkModel({this.audioB64, this.resText, this.reqText, this.sessionId});

  WebhookTalkModel.fromJson(Map<String, dynamic> json) {
    audioB64 = json['audio_b64'];
    resText = json['res_text'];
    reqText = json['req_text'];
    sessionId = json['session_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['audio_b64'] = audioB64;
    data['res_text'] = resText;
    data['req_text'] = reqText;
    data['session_id'] = sessionId;
    return data;
  }
}
