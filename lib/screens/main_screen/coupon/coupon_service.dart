import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:heal_u/Global/global_variable_for_show_messge.dart';
import 'package:heal_u/screens/main_screen/coupon/coupon_list_model.dart';
import 'package:heal_u/service/http_service/http_service.dart';
import 'package:heal_u/service/navigation_service.dart';
import 'package:heal_u/service/shared_pref_service/user_pref_service.dart';
import 'package:heal_u/widgets/general_widget.dart';

class CouponService with ChangeNotifier {
  bool isError = false;
  String errorMessage = "";
  bool loading = false;

  List<CouponData> mainCouponList = [];
  List<CouponData> couponList = [];

  filterData(value) {
    if (value == "") {
      couponList = mainCouponList;
    } else {
      couponList = mainCouponList
          .where((element) => element.code!.toLowerCase().contains(value))
          .toList();
    }
    notifyListeners();
  }

  Future getCoupons(BuildContext context) async {
    loading = true;
    var queryParameters = {};

    try {
      var response = await HttpService.httpPost("coupons", queryParameters,
          context: context);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = json.decode(response.body);

        if (body['success'].toString() == "1" &&
            body['status'].toString() == "200") {
          var data = CouponListModel.fromJson(body);
          mainCouponList = [];
          couponList = [];
          data.data!.forEach((element) {
            mainCouponList.add(element);
          });

          couponList.addAll(mainCouponList);

          isError = false;
          errorMessage = "";
        } else {
          isError = true;
          errorMessage = body['message'].toString();
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
      debugPrint("--- getCart --- ${e.toString()}");

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
