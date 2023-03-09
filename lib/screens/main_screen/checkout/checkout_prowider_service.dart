import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:heal_u/Global/global_variable_for_show_messge.dart';
import 'package:heal_u/screens/main_screen/cart/cart_prowider_service.dart';
import 'package:heal_u/screens/main_screen/checkout/checkout_model.dart';
import 'package:heal_u/service/http_service/http_service.dart';
import 'package:heal_u/service/navigation_service.dart';
import 'package:heal_u/service/shared_pref_service/user_pref_service.dart';
import 'package:heal_u/widgets/general_widget.dart';
import 'package:provider/provider.dart';

class CheckOutProwider with ChangeNotifier {
  CheckOutData? checkOutData;
  bool isLoading = false;

  Future getCheckData(
      {required String coupon,
      required String addressId,
      required String ownerId,
      required BuildContext context}) async {
    isLoading = true;
    try {
      Map<String, String> queryParameters = {
        "coupon_code": coupon,
        "address_id": addressId,
        "owner_id": ownerId
      };

      var response = await HttpService.httpPost("checkout", queryParameters,
          context: context);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = json.decode(response.body);

        if (body['success'].toString() == "1" &&
            body['status'].toString() == "200") {
          CheckOutModel data = CheckOutModel.fromJson(body);
          checkOutData = data.data;
        } else {
          throw body['message'];
        }

        // return places;
      } else if (response.statusCode == 401) {
        showToast(GlobalVariableForShowMessage.unauthorizedUser);
        await UserPrefService().removeUserData();
        NavigationService().navigatWhenUnautorized();
      } else {
        throw GlobalVariableForShowMessage.internalservererror;
      }
    } catch (e) {
      if (e is SocketException) {
        throw GlobalVariableForShowMessage.socketExceptionMessage;
      } else if (e is TimeoutException) {
        throw GlobalVariableForShowMessage.timeoutExceptionMessage;
        ;
      } else {
        throw e.toString();
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  createOrder(
    String addressId,
    String paymentId,
    String couponcode,
    context,
  ) async {
    try {
      Map<String, String> queryParameters = {
        "address_id": addressId.toString(),
        "payment_method_id": paymentId.toString(),
        "coupon_code": couponcode
      };

      print(queryParameters);
      var response = await HttpService.httpPost("place_order", queryParameters,
          context: context);

      if (response.statusCode == 201 || response.statusCode == 200) {
        var res = jsonDecode(response.body);

        if (res['success'].toString() == "1" &&
            res['status'].toString() == "200") {
          var provider1 =
              Provider.of<CardProviderService>(context, listen: false);
          await provider1.getCart();

          if (paymentId == "2") {
            return res['data']['payment_url'];
          }
          if (paymentId == "3") {
            return res;
          } else {
            return res['message'];
          }
        } else {
          throw res['message'];
        }
      } else if (response.statusCode == 401) {
        await UserPrefService().removeUserData();
        NavigationService().navigatWhenUnautorized();

        throw GlobalVariableForShowMessage.unauthorizedUser;
      } else {
        throw GlobalVariableForShowMessage.somethingwentwongMessage;
      }
    } catch (e) {
      if (e is SocketException) {
        throw GlobalVariableForShowMessage.socketExceptionMessage;
      } else if (e is TimeoutException) {
        throw GlobalVariableForShowMessage.timeoutExceptionMessage;
      } else {
        throw e.toString();
      }
    }
  }
}
