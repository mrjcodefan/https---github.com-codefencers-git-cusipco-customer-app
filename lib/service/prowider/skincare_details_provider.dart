import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:heal_u/Global/global_variable_for_show_messge.dart';
import 'package:heal_u/model/skincare_detail_model.dart';
import 'package:heal_u/service/http_service/http_service.dart';

class SkincareDetailsService with ChangeNotifier {
  SkincareDetailsModel? skincareDetailsModel;
  bool loading = false;
  bool isError = false;
  String cerrorMessage = "";

  Future<void> getskincareDetails(String id, String typePerameter) async {
    try {
      var url = "$typePerameter/$id";
      // var url = "SkinCare/$id";
      var loading = true;
      print(url);
      var response = await HttpService.httpGet(url);

      if (response.statusCode == 200) {
        isError = false;
        skincareDetailsModel =
            SkincareDetailsModel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 500) {
        isError = true;
        cerrorMessage = GlobalVariableForShowMessage.internalservererror;
      } else {
        isError = true;
        cerrorMessage = GlobalVariableForShowMessage.somethingwentwongMessage;
      }
    } catch (e) {
      debugPrint(e.toString());
      isError = true;
      cerrorMessage = e.toString();
    } finally {
      loading = false;
    }
    notifyListeners();
  }
}
