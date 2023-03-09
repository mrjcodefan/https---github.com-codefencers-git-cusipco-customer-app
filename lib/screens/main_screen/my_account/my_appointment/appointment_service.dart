import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:heal_u/Global/global_variable_for_show_messge.dart';
import 'package:heal_u/screens/main_screen/my_account/my_appointment/appointment_detail_model.dart';
import 'package:heal_u/service/http_service/http_service.dart';
import 'package:heal_u/service/navigation_service.dart';
import 'package:heal_u/service/shared_pref_service/user_pref_service.dart';
import 'package:heal_u/widgets/general_widget.dart';

class AppointMentService {
  Future<AppointmentDetailData?> getAppointmentDetails(String id) async {
    try {
      var response = await HttpService.httpGet("appointment/${id}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = json.decode(response.body);

        if (body['success'].toString() == "1" &&
            body['status'].toString() == "200") {
          AppointmentDetailsModel data = AppointmentDetailsModel.fromJson(body);
          return data.data;
        } else {
          // showToast(body['message'].toString());
          throw body['message'].toString();
        }
      } else if (response.statusCode == 401) {
        showToast(GlobalVariableForShowMessage.unauthorizedUser);
        await UserPrefService().removeUserData();
        NavigationService().navigatWhenUnautorized();
      } else {
        throw GlobalVariableForShowMessage.internalservererror;
      }
    } catch (e) {
      if (e is SocketException) {
        throw GlobalVariableForShowMessage.socketExceptionMessage;
      } else if (e is TimeoutException) {
        throw GlobalVariableForShowMessage.timeoutExceptionMessage;
        ;
      } else {
        throw e.toString();
      }
    }
  }
}
