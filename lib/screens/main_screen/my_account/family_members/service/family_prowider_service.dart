import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:heal_u/Global/global_variable_for_show_messge.dart';
import 'package:heal_u/screens/main_screen/my_account/family_members/model/family_list_model.dart';
import 'package:heal_u/service/http_service/http_service.dart';
import 'package:heal_u/service/navigation_service.dart';
import 'package:heal_u/service/shared_pref_service/user_pref_service.dart';
import 'package:heal_u/widgets/general_widget.dart';

class FamilyMemberService with ChangeNotifier {
  List<FamilyData>? familyMemberList = [];
  bool isSelectFamilyMember = false;
  FamilyData? currentFamilyMember;
  selectCurrentMember(bool value, FamilyData? data) {
    isSelectFamilyMember = value;
    if (value) {
      currentFamilyMember = data;
      UserPrefService().setCurrentMember(familyData: data);
    } else {
      currentFamilyMember = null;
      UserPrefService().removeCurrentMember();
    }
    notifyListeners();
  }

  Future getFamilyMemberList({required BuildContext context}) async {
    try {
      Map<String, String> queryParameters = {
        "serach": "",
      };
      var response = await HttpService.httpPost("members", queryParameters,
          context: context);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = json.decode(response.body);

        if (body['success'].toString() == "1" &&
            body['status'].toString() == "200") {
          FamilyListModel data = FamilyListModel.fromJson(body);

          familyMemberList = data.data;
          if (isSelectFamilyMember) {
            var tempData = familyMemberList!
                .firstWhere((element) => element.id == currentFamilyMember!.id);

            currentFamilyMember = tempData;

            notifyListeners();
            return;
          }
        } else {
          throw body['message'].toString();
        }
        // return places;
      } else if (response.statusCode == 401) {
        showToast(GlobalVariableForShowMessage.unauthorizedUser);
        await UserPrefService().removeUserData();
        NavigationService().navigatWhenUnautorized();
        throw "";
      } else {
        throw GlobalVariableForShowMessage.internalservererror;
      }
    } catch (e) {
      if (e is SocketException) {
        throw GlobalVariableForShowMessage.socketExceptionMessage;
      } else if (e is TimeoutException) {
        throw GlobalVariableForShowMessage.timeoutExceptionMessage;
      } else {
        debugPrint("--- getFamilyMemberList ---");
        throw e.toString();
      }
    }
  }
}
