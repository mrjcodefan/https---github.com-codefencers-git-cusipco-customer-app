import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:heal_u/model/general_information_model.dart';
import 'package:heal_u/service/http_service/http_service.dart';

class GeneralInfoService with ChangeNotifier {
  GeneralInformation? generalData;

  GeneralInformation? getData() {
    return generalData;
  }

  String getConsultaionChages() {
    return generalData!.consultationCharges.toString();
  }

  double getConsultaionChagesTax() {
    return double.parse(generalData!.consultationCharges.toString()) * 18 / 100;
  }

  double getConsultaionChagesPayableAmount() {
    double charges = double.parse(getConsultaionChages());
    double tax = getConsultaionChagesTax();

    return charges + tax;
  }

  Future getGeneralData() async {
    try {
      var response = await HttpService.httpGetWithoutToken("get_general_info");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = json.decode(response.body);
        GeneralInformationModel data = GeneralInformationModel.fromJson(body);
        if (data.status == "200") {
          generalData = data.data;
          notifyListeners();
          return;
        }
      }
    } catch (e) {
      debugPrint("--- getConsultaionChages --- ${e.toString()}");
    }
  }
}
