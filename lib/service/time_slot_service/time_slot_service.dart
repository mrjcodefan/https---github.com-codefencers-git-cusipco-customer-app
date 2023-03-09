import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:heal_u/Global/global_variable_for_show_messge.dart';
import 'package:heal_u/service/http_service/http_service.dart';
import 'package:heal_u/service/navigation_service.dart';
import 'package:heal_u/service/shared_pref_service/user_pref_service.dart';
import 'package:heal_u/service/time_slot_service/time_slot_model.dart';
import 'package:heal_u/widgets/general_widget.dart';

class TimeSlotService with ChangeNotifier {
  bool isLoading = false;
  String errorMessage = "";
  bool isError = false;

  List<TimeSlot> timeSlotList = [];

  Future<void> getTimeSlot(
      {required String id,
      required String date,
      required String mode,
      required BuildContext context}) async {
    isLoading = true;
    try {
      Map<String, String> queryParameters = {
        "id": id,
        "date": date,
        "mode_of_booking": mode
      };

      var response = await HttpService.httpPost(
          "get-availability", queryParameters,
          context: context);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = json.decode(response.body);

        if (body['success'].toString() == "1" &&
            body['status'].toString() == "200") {
          timeSlotList = [];
          TimingSlotModel data = TimingSlotModel.fromJson(body);
          timeSlotList = data.data!.toList();
          isError = false;
          errorMessage = "";
        } else {
          isError = true;
          errorMessage = body['message'].toString();
        }
      } else if (response.statusCode == 401) {
        showToast(GlobalVariableForShowMessage.unauthorizedUser);
        await UserPrefService().removeUserData();
        NavigationService().navigatWhenUnautorized();
      } else {
        isError = true;
        errorMessage = GlobalVariableForShowMessage.internalservererror;
      }
    } catch (e) {
      if (e is SocketException) {
        isError = true;
        errorMessage = GlobalVariableForShowMessage.socketExceptionMessage;
      } else if (e is TimeoutException) {
        isError = true;
        errorMessage = GlobalVariableForShowMessage.timeoutExceptionMessage;
      } else {
        isError = true;
        errorMessage = e.toString();
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
