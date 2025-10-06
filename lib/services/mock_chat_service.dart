import 'dart:async';
import 'dart:math';

class MockChatService {
  static final MockChatService _instance = MockChatService._internal();
  factory MockChatService() => _instance;
  MockChatService._internal();

  final List<Map<String, dynamic>> _messages = [];
  final StreamController<List<Map<String, dynamic>>> _messageController =
      StreamController<List<Map<String, dynamic>>>.broadcast();

  Stream<List<Map<String, dynamic>>> get messageStream => _messageController.stream;

  void addMessage(String userId, String message) {
    final newMessage = {
      'senderUid': userId,
      'message': message,
      'dateTime': DateTime.now().microsecondsSinceEpoch,
    };
    _messages.insert(0, newMessage);
    _messageController.add(List.from(_messages));
  }

  void addBotResponse(String userId) {
    final responses = [
      "## Welcome to AI Chat!\n\nHow can I help you today?\n",
      "Here's a quick example of **Markdown** formatting:\n\n- Bullet list item 1\n- Bullet list item 2\n\n> This is a blockquote.\n",
      "You can use *italic* or **bold** text, and even `inline code`.\n",
      "Here's a code block:\n\n```dart\nprint('Hello, world!');\n```\n",
      "Let's try some LaTeX math:\n\nInline: \$E = mc^2\$\n\nBlock:\n\n\$\$\n\\int_{a}^{b} x^2 dx\n\$\$\n",
      "You can also create numbered lists:\n\n1. First item\n2. Second item\n3. Third item\n",
      "Tables are supported too:\n\n| Name   | Value |\n|--------|-------|\n| Alice  | 42    |\n| Bob    | 99    |\n",
      "Feel free to ask me anything, or try sending me some Markdown or LaTeX to see how it renders!",
    ];

    final random = Random();
    final response = responses[random.nextInt(responses.length)];

    addMessage('bot', response);
  }

  void clearMessages() {
    _messages.clear();
    _messageController.add([]);
  }

  void dispose() {
    _messageController.close();
  }
}
