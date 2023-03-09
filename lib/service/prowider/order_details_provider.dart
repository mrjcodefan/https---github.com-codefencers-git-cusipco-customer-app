import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:heal_u/Global/global_variable_for_show_messge.dart';

import 'package:heal_u/model/order_details_model.dart';
import 'package:heal_u/service/http_service/http_service.dart';
import 'package:heal_u/service/navigation_service.dart';
import 'package:heal_u/service/shared_pref_service/user_pref_service.dart';
import 'package:heal_u/widgets/general_widget.dart';

class GetOrderDetailsService with ChangeNotifier {
  OrderDetailsModel? orderDetailsModel;

  bool isLoading = false;
  bool isError = false;
  String errorMessage = "";

  Future<void> getOrderDetails(String id) async {
    isLoading = true;
    try {
      var url = "order/$id";

      var response = await HttpService.httpGet(url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = json.decode(response.body);

        if (body['success'].toString() == "1" &&
            body['status'].toString() == "200") {
          isError = false;
          orderDetailsModel =
              OrderDetailsModel.fromJson(jsonDecode(response.body));
        } else {
          isError = true;
          // showToast(body['message'].toString());
          errorMessage = body['message'].toString();
        }
      } else if (response.statusCode == 401) {
        showToast(GlobalVariableForShowMessage.unauthorizedUser);
        UserPrefService().removeUserData();
        NavigationService().navigatWhenUnautorized();
      } else {
        isError = true;
        errorMessage = GlobalVariableForShowMessage.internalservererror;
      }
    } catch (e) {
      isError = true;
      // debuge(e);
      if (e is SocketException) {
        errorMessage = GlobalVariableForShowMessage.socketExceptionMessage;
      } else if (e is TimeoutException) {
        errorMessage = GlobalVariableForShowMessage.timeoutExceptionMessage;
      } else {
        errorMessage = e.toString();
      }
    } finally {
      isLoading = false;
    }
    notifyListeners();
  }
}
