import 'package:shared_preferences/shared_preferences.dart';

enum SharedPreferencesKey { token, translation, image, chatSessionId, wallet }

class SharedPreferencesManager {
  Future<SharedPreferences> get _instance => SharedPreferences.getInstance();

  Future<bool> containsKey(String key) async => (await _instance).containsKey(key);

  Future<dynamic> get(String key) async => (await _instance).get(key);

  Future<bool> remove(String key) async => (await _instance).remove(key);

  Future<bool> setValue(String key, dynamic value) async {
    switch (value.runtimeType) {
      case const (int):
        return (await _instance).setInt(key, value);
      case const (double):
        return (await _instance).setDouble(key, value);
      case const (bool):
        return (await _instance).setBool(key, value);
      case const (String):
        return (await _instance).setString(key, value);
      case const (List<String>):
        return (await _instance).setStringList(key, value);
      default:
        return false;
    }
  }

  Future<void> deleteAll() async {
    for (var key in [
      SharedPreferencesKey.chatSessionId,
    ]) {
      await remove(key.name);
    }
  }
}
//  final _storageKey = SharedPreferencesKey.token.name;

//  final localAuthEncoded = await SharedPreferencesManager().get(_storageKey);

// void _saveUserInfo() {
//   SharedPreferencesManager().setValue(
//     _storageKey,
//     jsonEncode({'user': _userInfo?.toJson(), 'env': AppConfig.shared.env.name}),
//   );
// }
