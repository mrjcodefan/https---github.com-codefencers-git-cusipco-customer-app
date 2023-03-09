import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:heal_u/Global/global_variable_for_show_messge.dart';
import 'package:heal_u/screens/main_screen/cart/cart_model.dart';
import 'package:heal_u/service/http_service/http_service.dart';
import 'package:heal_u/service/navigation_service.dart';
import 'package:heal_u/service/shared_pref_service/user_pref_service.dart';
import 'package:heal_u/widgets/general_widget.dart';

class CardProviderService with ChangeNotifier {
  CartData? cartData;

  bool isError = false;
  String errorMessage = "";
  bool loading = false;

  bool isLoadProductDetails = false;
  bool isLoadStoreProductDetails = false;

  Future getCart() async {
    try {
      var response = await HttpService.httpGet("carts");
      loading = true;
      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = json.decode(response.body);

        if (body['success'].toString() == "1" &&
            body['status'].toString() == "200") {
          CartsModel data = CartsModel.fromJson(body);
          isError = false;
          errorMessage = "";
          cartData = data.data;
          isLoadProductDetails = true;
          isLoadStoreProductDetails = true;
          Future.delayed(Duration(seconds: 1), () {
            isLoadProductDetails = false;
            isLoadStoreProductDetails = false;
          });
          notifyListeners();
          return;
        } else {
          print("---------- issue in get cart -----------");
          cartData = null;
          print("cart issue--------------------------");
          isLoadProductDetails = true;
          isLoadStoreProductDetails = true;
          Future.delayed(Duration(seconds: 1), () {
            isLoadProductDetails = false;
            isLoadStoreProductDetails = false;
          });
          notifyListeners();
          isError = true;
          errorMessage = body['message'].toString();
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

  addRemoveCartItem(
      bool isAdding, CartItem cartItem, qu, context, bool isFromCart) async {
    try {
      Map<String, String> queryParameters = {
        "product_id": cartItem.productId.toString(),
        "quantity": qu.toString(),
      };

      var response = await HttpService.httpPost("updateCart", queryParameters,
          context: context);

      if (response.statusCode == 201 || response.statusCode == 200) {
        var res = jsonDecode(response.body);

        if (res['success'].toString() == "1" &&
            res['status'].toString() == "200") {
          // isLoadProductDetails = true;
          // isLoadStoreProductDetails = true;
          // Future.delayed(Duration(seconds: 1), () {
          //   isLoadProductDetails = false;
          //   isLoadStoreProductDetails = false;
          // });
          // notifyListeners();
          await getCart();

          if (isAdding) {
            return GlobalVariableForShowMessage.itemAddedSuccessFully;
          } else {
            return GlobalVariableForShowMessage.itemRemovedSuccessFully;
          }
        } else {
          return res['message'];
        }
      } else if (response.statusCode == 401) {
        await UserPrefService().removeUserData();
        NavigationService().navigatWhenUnautorized();

        return GlobalVariableForShowMessage.unauthorizedUser;
      } else {
        print("add remvo issue--------------------------");
        print("----------> ${response.body}");
        return GlobalVariableForShowMessage.internalservererror;
      }
    } catch (e) {
      print("------error ${e}");
      if (e is SocketException) {
        return GlobalVariableForShowMessage.socketExceptionMessage;
      } else if (e is TimeoutException) {
        return GlobalVariableForShowMessage.timeoutExceptionMessage;
      } else {
        return e.toString();
      }
    }
  }

  removeItem(CartItem cartItem, context, bool isFromCart) async {
    try {
      Map<String, String> queryParameters = {
        "product_id": cartItem.productId.toString(),
      };

      print(queryParameters);
      var response = await HttpService.httpPost("deleteCart", queryParameters,
          context: context);

      if (response.statusCode == 201 || response.statusCode == 200) {
        var res = jsonDecode(response.body);

        if (res['success'].toString() == "1" &&
            res['status'].toString() == "200") {
          await getCart();

          return res['message'];
        } else {
          return res['message'];
        }
      } else if (response.statusCode == 401) {
        await UserPrefService().removeUserData();
        NavigationService().navigatWhenUnautorized();
        return GlobalVariableForShowMessage.unauthorizedUser;
      } else {
        return GlobalVariableForShowMessage.somethingwentwongMessage;
      }
    } catch (e) {
      if (e is SocketException) {
        return GlobalVariableForShowMessage.socketExceptionMessage;
      } else if (e is TimeoutException) {
        return GlobalVariableForShowMessage.timeoutExceptionMessage;
      } else {
        return e.toString();
      }
    }
  }
}
