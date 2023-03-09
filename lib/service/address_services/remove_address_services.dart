import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:heal_u/model/common_model.dart';

import 'package:heal_u/service/http_service/http_service.dart';
import 'package:heal_u/widgets/general_widget.dart';

Future removeAddress(String id, {required BuildContext context}) async {
  try {
    var url = "delete_address";

    Map<dynamic, dynamic> data = {'address_id': id};

    var response = await HttpService.httpPost(url, data, context: context);

    if (response.statusCode == 200) {
      // showToast("message.toString()");

      return 'true';
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}
