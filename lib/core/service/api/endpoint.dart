class Endpoints {
  Endpoints._();

  static const _authBase = '/auth';

  /// Auth
  static String get customToken => '$_authBase/generate-custom-token';
  static String get accountList => '/user';

  static String get chat => '';
  static String get apiFireworks => '/inference/v1/chat/completions';
  static String get webhookTalk => '/webhook/talk';
  static String get analyzeChatFirebase => '/analyze_chat_firebase';
}
