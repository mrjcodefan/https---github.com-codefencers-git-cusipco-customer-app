import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:heal_u/Global/global_variable_for_show_messge.dart';
import 'package:heal_u/screens/main_screen/home/Food/model/my_subscription_model.dart';
import 'package:heal_u/service/http_service/http_service.dart';
import 'package:heal_u/service/navigation_service.dart';
import 'package:heal_u/service/shared_pref_service/user_pref_service.dart';
import 'package:heal_u/widgets/general_widget.dart';

class MySubscriptionService with ChangeNotifier {
  List<MySubscriptionDataRestaurant>? restaurants = [];
  List<MySubscriptionDataDietPlan>? dietPlans = [];

  getMySubscription() async {
    try {
      var response = await HttpService.httpGet("my_subscriptions");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = json.decode(response.body);

        if (body['success'].toString() == "1" &&
            body['status'].toString() == "200") {
          MySubscriptionModel data = MySubscriptionModel.fromJson(body);
          if (data.data != null) {
            restaurants = data.data!.restaurants;
            dietPlans = data.data!.dietPlans;
            notifyListeners();
          }
        }
      } else if (response.statusCode == 401) {
        showToast(GlobalVariableForShowMessage.unauthorizedUser);
        await UserPrefService().removeUserData();
        NavigationService().navigatWhenUnautorized();
      } else {
        // throw "internal server error";
      }
    } catch (e) {
      if (e is SocketException) {
        debugPrint("socket exception screen :------ $e");

        // throw "Socket exception";
      } else if (e is TimeoutException) {
        debugPrint("time out exp :------ $e");

        // throw "Time out exception";
      } else {
        debugPrint("attraction details screen:------ $e");

        // throw e.toString();
      }
    }
  }
}
