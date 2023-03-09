import 'dart:convert';
import 'package:flutter/cupertino.dart';

import 'package:heal_u/model/skincare_list_model.dart';

import 'package:heal_u/service/http_service/http_service.dart';

class SkincareListService with ChangeNotifier {
  late SkinListModel skinListModel;
  bool loading = false;
  Future<void> getSkincareList(String id, String search,
      {required BuildContext context}) async {
    Map<dynamic, dynamic> temp = {
      'page': 1,
      'count': 10,
      'category_id': id,
      'search': search,
    };
    try {
      var url = "SkinCare";

      loading = true;
      var response = await HttpService.httpPost(url, temp, context: context);

      if (response.statusCode == 200) {
        skinListModel = SkinListModel.fromJson(jsonDecode(response.body));

        loading = false;
        notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
