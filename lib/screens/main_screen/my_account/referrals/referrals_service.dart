import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:heal_u/Global/global_variable_for_show_messge.dart';
import 'package:heal_u/screens/main_screen/my_account/referrals/share_reference_model.dart';
import 'package:heal_u/service/http_service/http_service.dart';
import 'package:heal_u/service/navigation_service.dart';
import 'package:heal_u/service/shared_pref_service/user_pref_service.dart';
import 'package:heal_u/widgets/general_widget.dart';

class ReferralsService with ChangeNotifier {
  ShareAndReferralsData? referralsData;

  bool isError = false;
  String errorMessage = "";
  bool loading = false;

  Future<void> getReferralData() async {
    try {
      var url = "get-my-code";
      loading = true;
      var response = await HttpService.httpGet(url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = json.decode(response.body);

        if (body['success'].toString() == "1" &&
            body['status'].toString() == "200") {
          ShareReferenceModel refData =
              ShareReferenceModel.fromJson(jsonDecode(response.body));

          referralsData = refData.data!;
          notifyListeners();
          isError = false;
          errorMessage = "";
          return;
        }
      } else if (response.statusCode == 401) {
        showToast(GlobalVariableForShowMessage.unauthorizedUser);
        await UserPrefService().removeUserData();
        NavigationService().navigatWhenUnautorized();
      } else {
        isError = true;
        errorMessage = GlobalVariableForShowMessage.somethingwentwongMessage;
      }
    } catch (e) {
      debugPrint("--- getReferralData --- ${e.toString()}");

      isError = true;
      if (e is SocketException) {
        errorMessage = GlobalVariableForShowMessage.socketExceptionMessage;
      } else if (e is TimeoutException) {
        errorMessage = GlobalVariableForShowMessage.timeoutExceptionMessage;
      } else {
        errorMessage = e.toString();
      }
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
