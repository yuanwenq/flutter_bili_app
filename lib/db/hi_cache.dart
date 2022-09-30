import 'package:shared_preferences/shared_preferences.dart';

/// 缓存管理类
class HiCache {
  SharedPreferences? prefs;
  // 单例
  HiCache._() {
    init();
  }

  static HiCache? _instace;

  HiCache._pre(SharedPreferences prefs) {
    this.prefs = prefs;
  }
  static Future<HiCache> preInit() async {
    if (_instace == null) {
      var prefs = await SharedPreferences.getInstance();
      _instace = HiCache._pre(prefs);
    }
    return _instace!;
  }

  static HiCache getInstance() {
    _instace ??= HiCache._();
    return _instace!;
  }

  void init() async {
    prefs ??= await SharedPreferences.getInstance();
  }

  setString(String key, String value) {
    prefs?.setString(key, value);
  }

  setDouble(String key, double value) {
    prefs?.setDouble(key, value);
  }

  setInt(String key, int value) {
    prefs?.setInt(key, value);
  }

  setBool(String key, bool value) {
    prefs?.setBool(key, value);
  }

  setStringList(String key, List<String> value) {
    prefs?.setStringList(key, value);
  }

  T? get<T>(String key) {
    var result = prefs?.get(key);
    if (result != null) {
      return result as T;
    }
    return null;
  }
}
