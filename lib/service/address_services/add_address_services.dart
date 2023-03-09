import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:heal_u/model/common_model.dart';
import 'package:heal_u/model/get_address_model.dart';

import 'package:heal_u/service/http_service/http_service.dart';

Future<CommonModel?> addNewAddress(String name, String type, String address,
    String pincode, String lattitude, String longitide, String phone,
    {required BuildContext context}) async {
  try {
    var url = "save_address";
    // UserModel? model = await UserPrefService().getUserData();

    // String phone = model.data!.phoneNumber.toString();

    Map<dynamic, dynamic> data = {
      'name': name,
      'phone_number': phone,
      'address_type': type,
      'address': address,
      'pincode': pincode,
      "latitude": lattitude,
      "longitude": longitide,
    };

    var response = await HttpService.httpPost(url, data, context: context);

    if (response.statusCode == 200) {
      return CommonModel.fromJson(jsonDecode(response.body));
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}

Future<CommonModel?> updateNewAddress(
    {required BuildContext context, required AddressData address}) async {
  try {
    var url = "save_address";

    Map<dynamic, dynamic> data = {
      'name': address.name,
      'phone_number': address.phoneNumber,
      'address_type': address.addressType,
      'address': address.address,
      'pincode': address.pincode,
      "latitude": address.latitude,
      "longitude": address.longitude,
      "address_id": address.id
    };

    var response = await HttpService.httpPost(url, data, context: context);

    if (response.statusCode == 200) {
      return CommonModel.fromJson(jsonDecode(response.body));
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}
