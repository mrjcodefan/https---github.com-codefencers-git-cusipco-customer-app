import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:heal_u/Global/global_variable_for_show_messge.dart';
import 'package:heal_u/model/skin_categories_model.dart';

import 'package:heal_u/service/http_service/http_service.dart';

class SkinCategoryService with ChangeNotifier {
  late SkinCategoriesModel skinCategoriesModel;
  bool loading = false;

  String errorMessage = "";
  bool isError = false;
  Future<void> getSkinCategories({required BuildContext context}) async {
    Map<dynamic, dynamic> temp = {
      'module': 'SkinCare',
      'search': '',
    };
    try {
      var url = "categories";

      loading = true;
      var response = await HttpService.httpPost(url, temp, context: context);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = json.decode(response.body);
        if (body['success'].toString() == "1" &&
            body['status'].toString() == "200") {
          skinCategoriesModel =
              SkinCategoriesModel.fromJson(jsonDecode(response.body));

          loading = false;
          isError = false;
          errorMessage = "";
          notifyListeners();
        } else {
          isError = true;
          errorMessage = body['message'].toString();
        }
      } else {
        isError = true;
        errorMessage = GlobalVariableForShowMessage.internalservererror;
      }
    } catch (e) {
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
