import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:heal_u/model/user_model.dart';
import 'package:heal_u/screens/main_screen/my_account/family_members/model/family_list_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPrefService with ChangeNotifier {
  static SharedPreferences? preferences;

  UserModel? globleUserModel;
  String? token;

  Future<void> setUserData({required UserModel? userModel}) async {
    preferences = await SharedPreferences.getInstance();
    preferences!.setString('userModelCustomer', jsonEncode(userModel));
    globleUserModel = userModel;

    notifyListeners();
  }

  Future<void> setToken(value) async {
    preferences = await SharedPreferences.getInstance();
    preferences!.setString('tokenCustomer', value);
    token = value;
    notifyListeners();
  }

  Future<String?> getToken() async {
    preferences = await SharedPreferences.getInstance();
    var data = preferences!.getString('tokenCustomer');
    return data;
  }

  Future<void> removeToken(value) async {
    preferences = await SharedPreferences.getInstance();
    preferences!.remove('tokenCustomer');

    notifyListeners();
  }

  Future<UserModel> getUserData() async {
    preferences = await SharedPreferences.getInstance();
    var temp = preferences!.getString("userModelCustomer");
    var dataToRetun = UserModel.fromJson(jsonDecode(temp.toString()));
    globleUserModel = dataToRetun;
    // print(userData);
    notifyListeners();

    return dataToRetun;
  }

  Future<void> removeUserData() async {
    preferences = await SharedPreferences.getInstance();
    preferences!.remove('userModelCustomer');
  }

  Future<void> setCurrentMember({required FamilyData? familyData}) async {
    preferences = await SharedPreferences.getInstance();
    preferences!.setString('currentMemberCustomer', jsonEncode(familyData));
  }

  Future<FamilyData?> getCurrentMember() async {
    preferences = await SharedPreferences.getInstance();
    var temp = preferences!.getString("currentMemberCustomer");
    var dataToRetun = FamilyData.fromJson(jsonDecode(temp.toString()));
    return dataToRetun;
  }

  Future<void> removeCurrentMember() async {
    preferences = await SharedPreferences.getInstance();
    preferences!.remove('currentMemberCustomer');
  }
}
