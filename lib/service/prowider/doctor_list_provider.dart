import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:heal_u/Global/global_variable_for_show_messge.dart';

import 'package:heal_u/model/doctor_list_model.dart';

import 'package:heal_u/service/http_service/http_service.dart';
import 'package:heal_u/service/navigation_service.dart';
import 'package:heal_u/service/shared_pref_service/user_pref_service.dart';

class DoctorListServices with ChangeNotifier {
  // late DoctorListModel doctorListModel;

  // bool loading = false;

  // List<DoctorData> doctoreList = [];
  // bool isLoadMoreRunning = false;
  // bool isnotMoreData = false;
  // bool isFirstCall = true;

  // bool isError = false;
  // String errorMessage = "";

  // Future<void> getDoctorsList(
  //   String id,
  //   String search, {
  //   required String page,
  //   required BuildContext context,
  //   required String mode,
  //   required bool isInit,
  // }) async {
  //   Map<dynamic, dynamic> temp = {
  //     'page': page,
  //     'count': 10,
  //     'category_id': id,
  //     'search': search,
  //     'mode_of_booking': mode
  //   };

  //   try {
  //     var url = "doctors";

  //     if (isFirstCall) {
  //       loading = true;
  //       notifyListeners();
  //     } else {
  //       isLoadMoreRunning = true;
  //       notifyListeners();
  //     }

  //     var response = await HttpService.httpPost(url, temp, context: context);

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       final body = json.decode(response.body);

  //       if (body['success'].toString() == "1" &&
  //           body['status'].toString() == "200") {
  //         doctorListModel = DoctorListModel.fromJson(body);
  //         if (doctorListModel.data != null) {
  //           isError = false;
  //           isFirstCall = false;

  //           if (doctorListModel.data.isNotEmpty) {
  //             if (isInit) {
  //               doctoreList = [];
  //               notifyListeners();
  //             }

  //             doctorListModel.data.forEach((element) {
  //               doctoreList.add(element);
  //             });
  //             notifyListeners();
  //           } else {
  //             isnotMoreData = true;
  //           }
  //         } else {
  //           isError = true;
  //           errorMessage = GlobalVariableForShowMessage.internalservererror;
  //         }
  //       } else {
  //         isError = true;
  //         errorMessage = GlobalVariableForShowMessage.somethingwentwongMessage;
  //       }
  //     } else if (response.statusCode == 401) {
  //       isError = true;
  //       errorMessage = GlobalVariableForShowMessage.unauthorizedUser;
  //       await UserPrefService().removeUserData();
  //       NavigationService().navigatWhenUnautorized();
  //     } else if (response.statusCode == 500) {
  //       isError = true;
  //       errorMessage = GlobalVariableForShowMessage.internalservererror;
  //     } else {
  //       isError = true;
  //       errorMessage = GlobalVariableForShowMessage.internalservererror;
  //     }
  //   } catch (e) {
  //     if (e is SocketException) {
  //       isError = true;
  //       errorMessage = GlobalVariableForShowMessage.socketExceptionMessage;
  //     } else if (e is TimeoutException) {
  //       isError = true;
  //       errorMessage = GlobalVariableForShowMessage.timeoutExceptionMessage;
  //     } else {
  //       isError = true;
  //       errorMessage = e.toString();
  //     }
  //   } finally {
  //     if (isInit) {
  //       loading = false;
  //       notifyListeners();
  //     } else {
  //       isLoadMoreRunning = false;
  //       notifyListeners();
  //     }
  //   }
  // }
}
