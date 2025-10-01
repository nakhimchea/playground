import 'package:wingai/core/constants/enum.dart';

class TokenManager {
  TokenManager._privateConstructor();

  // Static instance of the class
  static final TokenManager _instance = TokenManager._privateConstructor();

  // Factory constructor to provide the instance
  factory TokenManager() {
    return _instance;
  }

  // Tokens for different endpoints
  final String openAIToken = const String.fromEnvironment('OPENAI_TOKEN');
  final String lamaToken = const String.fromEnvironment('LAMA_TOKEN');
  final String grokToken = const String.fromEnvironment('GROK_TOKEN');

  // Current token that will be used
  String _currentToken = '';

  // Method to set the token based on user selection
  void setToken(ModelType selectedModel) {
    switch (selectedModel) {
      case ModelType.ChatGPT:
        _currentToken = openAIToken;
        break;
      case ModelType.Meta_FaceBook:
        _currentToken = lamaToken;
        break;
      case ModelType.Tesla_AI:
        _currentToken = grokToken;
        break;
      default:
        _currentToken = '';
    }
  }

  // Method to get the current token
  String getCurrentToken() {
    if (_currentToken.isEmpty) {
      throw Exception('No token selected');
    }
    return _currentToken;
  }
}
