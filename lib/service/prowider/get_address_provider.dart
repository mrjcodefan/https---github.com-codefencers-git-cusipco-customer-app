import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:heal_u/Global/global_variable_for_show_messge.dart';
import 'package:heal_u/model/get_address_model.dart';
import 'package:heal_u/service/http_service/http_service.dart';

class GetAddressService with ChangeNotifier {
  GetAddressModel? getAddressModel;
  bool loading = false;

  bool isError = false;
  String errorMessage = "";
  Future<void> getAddressData() async {
    try {
      var url = "get_addresses";
      loading = true;
      var response = await HttpService.httpGet(url);

      if (response.statusCode == 200) {}

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = json.decode(response.body);
        if (body['success'].toString() == "1" &&
            body['status'].toString() == "200") {
          getAddressModel = GetAddressModel.fromJson(jsonDecode(response.body));
          loading = false;
          notifyListeners();
          isError = false;
          errorMessage = "";
        } else {
          isError = true;
          errorMessage = body['message'].toString();
        }
      } else {
        isError = true;
        errorMessage = GlobalVariableForShowMessage.internalservererror;
      }
    } catch (e) {
      debugPrint(e.toString());

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
