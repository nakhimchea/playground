class Message {
  final String text;
  final String? aiModelType;
  final bool isMe;
  final DateTime timestamp;

  Message({required this.text, this.aiModelType, required this.isMe, required this.timestamp});
}
