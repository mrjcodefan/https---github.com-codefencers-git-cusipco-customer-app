import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:heal_u/Global/global_variable_for_show_messge.dart';
import 'package:heal_u/model/slider_list_model.dart';
import 'package:heal_u/screens/main_screen/cart/cart_prowider_service.dart';
import 'package:heal_u/screens/main_screen/my_account/family_members/service/family_prowider_service.dart';
import 'package:heal_u/screens/main_screen/my_account/referrals/referrals_service.dart';
import 'package:heal_u/service/http_service/http_service.dart';
import 'package:heal_u/service/navigation_service.dart';
import 'package:heal_u/service/prowider/general_information_service.dart';
import 'package:heal_u/service/prowider/location_prowider_service.dart';
import 'package:heal_u/service/prowider/payment_method_service.dart';
import 'package:heal_u/service/shared_pref_service/user_pref_service.dart';
import 'package:heal_u/widgets/general_widget.dart';
import 'package:provider/provider.dart';

class InitialDataService with ChangeNotifier {
  SliderListData? globalSliderList = null;

  bool isUnautorized = false;

  Future loadInitData(BuildContext context) async {
    var familyPro = Provider.of<FamilyMemberService>(context, listen: false);

    var provider1 = Provider.of<CardProviderService>(context, listen: false);

    var providerForRef = Provider.of<ReferralsService>(context, listen: false);

    var locationProwider =
        Provider.of<LocationProwiderService>(context, listen: false);
    var paymentMethodProwider =
        Provider.of<PaymentMethodSerivce>(context, listen: false);

    try {
      await locationProwider.getCityList();
      await Future.wait([
        getSliderDataHome(),
        familyPro.getFamilyMemberList(context: context),
        provider1.getCart(),
        providerForRef.getReferralData(),
        Provider.of<GeneralInfoService>(context, listen: false)
            .getGeneralData(),
        locationProwider.getCurrentCityLocation()
      ]);

      await paymentMethodProwider.getPaymentMethod();
    } catch (e) {
      print("---1 ${e}");
    }

    updateDeviceData();
    try {
      var member = await UserPrefService().getCurrentMember();
      if (member != null) {
        await familyPro.selectCurrentMember(true, member);
      }
    } catch (e) {
      print("---2 ${e}");
    }

    notifyListeners();
  }

  Future<void> getSliderDataHome() async {
    try {
      var url = "sliders";

      var response = await HttpService.httpGetWithoutToken(url);

      if (response.statusCode == 200) {
        SliderListModel sliderData =
            SliderListModel.fromJson(jsonDecode(response.body));

        if (sliderData != null) {
          if (sliderData.data != null) {
            if (sliderData.data! != null) {
              globalSliderList = sliderData.data!;
              notifyListeners();
              return;
            }
          }
        }
      }
    } catch (e) {
      debugPrint("--- getSliderDataHome --- ${e.toString()}");
      debugPrint(e.toString());
    }
  }

  updateDeviceData() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      print("firebase token -----------${token}");

      if (Platform.isAndroid) {
        var data = deviceInfoPlugin.androidInfo.then((value) {
          _updateDeviceDataApi(
              model: value.model.toString(),
              token: token.toString(),
              version: value.version.release.toString(),
              deviceType: "Android");
        });
      } else if (Platform.isIOS) {
        var data = deviceInfoPlugin.iosInfo.then((value) {
          _updateDeviceDataApi(
              model: value.model.toString(),
              token: token.toString(),
              version: value.systemVersion.toString(),
              deviceType: "Android");
        });
      }
    } catch (e) {
      print("------while update device data = $e");
    }
  }

  _updateDeviceDataApi({
    required String token,
    required String version,
    required String model,
    required String deviceType,
  }) async {
    try {
      Map<String, String> queryParameters = {
        "device_type": deviceType,
        "notification_type": "Flutter",
        "token": token,
        "uuid": "0",
        "ip": "0",
        "os_version": version,
        "model_name": model,
      };
      var response = await HttpService.httpPostWithoutContext(
        "update-device-details",
        queryParameters,
      );
      var res = jsonDecode(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        if (res['success'].toString() == "1" &&
            res['status'].toString() == "200") {
        } else {
          showToast(res['message']);
        }
      } else if (response.statusCode == 401) {
        showToast(GlobalVariableForShowMessage.unauthorizedUser);
        await UserPrefService().removeUserData();
        NavigationService().navigatWhenUnautorized();
      } else {
        showToast(GlobalVariableForShowMessage.somethingwentwongMessage);
      }
    } catch (e) {
      if (e is SocketException) {
        showToast(GlobalVariableForShowMessage.socketExceptionMessage);
      } else if (e is TimeoutException) {
        showToast(GlobalVariableForShowMessage.timeoutExceptionMessage);
      } else {
        showToast(e.toString());
      }
    } finally {}
  }
}
