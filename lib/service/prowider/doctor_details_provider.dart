import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:heal_u/Global/global_variable_for_show_messge.dart';
import 'package:heal_u/model/doctors_detail_model.dart';

import 'package:heal_u/service/http_service/http_service.dart';

class DoctorsDetailsServices with ChangeNotifier {
  DoctorDetailsModel? doctorDetailsModel;

  bool loading = false;
  String errorMessage = "";
  bool isError = false;

  Future<void> getDoctorDetails(
    String id,
  ) async {
    try {
      var url = "doctor/$id";
      loading = true;

      var response = await HttpService.httpGet(url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = json.decode(response.body);
        if (body['success'].toString() == "1" &&
            body['status'].toString() == "200") {
          doctorDetailsModel =
              DoctorDetailsModel.fromJson(jsonDecode(response.body));

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
