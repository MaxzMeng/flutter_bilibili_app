import 'package:shared_preferences/shared_preferences.dart';

class HiCache {
  late SharedPreferences _prefs;

  HiCache._() {
    init();
  }

  HiCache._pre(SharedPreferences prefs) {
    this._prefs = prefs;
  }

  static HiCache? _instance;

  static Future<HiCache> preInit() async {
    if (_instance == null) {
      var prefs = await SharedPreferences.getInstance();
      _instance = HiCache._pre(prefs);
    }
    return _instance!;
  }

  static HiCache getInstance() {
    if (_instance == null) {
      _instance = HiCache._();
    }
    return _instance!;
  }

  void init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  setString(String key, String value) {
    _prefs.setString(key, value);
  }

  setDouble(String key, double value) {
    _prefs.setDouble(key, value);
  }

  setInt(String key, int value) {
    _prefs.setInt(key, value);
  }

  setBool(String key, bool value) {
    _prefs.setBool(key, value);
  }

  setStringList(String key, List<String> value) {
    _prefs.setStringList(key, value);
  }

  dynamic get(String key) {
    return _prefs.get(key);
  }
}
