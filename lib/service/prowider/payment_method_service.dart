import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:heal_u/Global/global_variable_for_show_messge.dart';
import 'package:heal_u/model/payment_method_model.dart';
import 'package:heal_u/service/http_service/http_service.dart';
import 'package:heal_u/service/navigation_service.dart';
import 'package:heal_u/service/shared_pref_service/user_pref_service.dart';
import 'package:heal_u/widgets/general_widget.dart';

class PaymentMethodSerivce with ChangeNotifier {
  List<PaymentDataModel>? paymentDataList = [];

  bool isError = false;
  bool isLoading = false;
  String errorMessage = "";

  getPaymentMethod() async {
    try {
      var url = "payment-methods";
      isLoading = true;
      notifyListeners();
      var response = await HttpService.httpGet(url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = json.decode(response.body);

        if (body['success'].toString() == "1" &&
            body['status'].toString() == "200") {
          PaymentMethodModel data =
              PaymentMethodModel.fromJson(jsonDecode(response.body));
          paymentDataList = [];

          paymentDataList = data.data;

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
      isLoading = false;
      notifyListeners();
    }
  }
}
