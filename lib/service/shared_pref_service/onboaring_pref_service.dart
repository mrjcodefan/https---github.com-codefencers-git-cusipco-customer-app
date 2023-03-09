import 'package:shared_preferences/shared_preferences.dart';

class OnBoadingPrefService {
  static SharedPreferences? preferences;

  static Future<void> setOnBoaringScreenDisable(bool data) async {
    preferences = await SharedPreferences.getInstance();
    preferences!.setBool('isOnboaringCustomer', data);
  }

  static Future<bool?> getOnBoaring() async {
    preferences = await SharedPreferences.getInstance();
    var temp = preferences!.getBool("isOnboaringCustomer");
    return temp;
  }
}
