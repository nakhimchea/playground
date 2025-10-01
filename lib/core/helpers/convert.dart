String capitalizeFirstLetter(String input) {
  if (input.isEmpty) return input;
  return input[0].toUpperCase();
}

String removeSurroundingQuotes(String input) {
  if (input.length >= 2 && input.startsWith('"') && input.endsWith('"')) {
    return input.substring(1, input.length - 1);
  }
  return input;
}

String aiModelImage(String modelType) {
  switch (modelType) {
    case 'ModelType.ChatGPT':
      return "assets/images/chatgpt.png";
    case 'ModelType.DEEPSEEK':
      return "assets/images/deepseek.png";
    case 'ModelType.WebhookTalk':
      return "assets/images/rnd_logo.jpeg";
    case 'ModelType.HR_Policy':
      return 'assets/images/support.png';
    case 'ModelType.Meta_FaceBook':
      return "assets/images/meta.png";
    default:
      return "assets/images/rnd_logo.jpeg";
  }
}
