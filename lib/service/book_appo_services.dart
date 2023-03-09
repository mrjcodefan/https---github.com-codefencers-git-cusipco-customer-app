import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:heal_u/Global/global_variable_for_show_messge.dart';
import 'package:heal_u/model/book_appo_model.dart';

import 'package:heal_u/service/http_service/http_service.dart';

Future<BookAppoModel?> bookAppo(
  String id,
  String date,
  String time,
  String module,
  BuildContext context, {
  String? mode,
  required String paymentMethodId,
}) async {
  try {
    var url = "book-appointment";
    Map<dynamic, dynamic> data;
    if (mode != null) {
      data = {
        'module': module,
        'id': id,
        'date': date,
        'time': time,
        'mode_of_booking': mode,
        'payment_method_id': paymentMethodId
      };
    } else {
      data = {
        'module': module,
        'id': id,
        'date': date,
        'time': time,
        'payment_method_id': paymentMethodId
      };
    }

    var response = await HttpService.httpPost(url, data, context: context);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == "200" && data['success'] == "1") {
        return BookAppoModel.fromJson(data);
      } else {
        throw data['message'].toString();
      }
    } else if (response.statusCode == 500) {
      throw GlobalVariableForShowMessage.internalservererror;
    } else {
      throw GlobalVariableForShowMessage.somethingwentwongMessage;
    }
  } catch (e) {
    throw e;
    // debugPrint(e.toString());
  }
}
