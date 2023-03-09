import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:heal_u/Global/global_variable_for_show_messge.dart';
import 'package:heal_u/model/user_model.dart';
import 'package:heal_u/routes.dart';
import 'package:heal_u/screens/authentication_screen/change_password_screen.dart';
import 'package:heal_u/screens/main_screen/main_screen.dart';
import 'package:heal_u/service/http_service/http_service.dart';
import 'package:heal_u/service/prowider/initial_data_prowider.dart';
import 'package:heal_u/service/shared_pref_service/user_pref_service.dart';
import 'package:heal_u/themedata.dart';
import 'package:heal_u/widgets/button_widget/rounded_button_widget.dart';
import 'package:heal_u/widgets/general_widget.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class VerifyMobileScreen extends StatefulWidget {
  VerifyMobileScreen(
      {Key? key, required this.phoneNumber, this.isfromResetPass = false})
      : super(key: key);
  final String phoneNumber;
  final bool isfromResetPass;
  @override
  State<VerifyMobileScreen> createState() => _VerifyMobileScreenState();
}

class _VerifyMobileScreenState extends State<VerifyMobileScreen> {
  TextEditingController textEditingController = TextEditingController();
  bool isShowResend = false;

  StreamController<ErrorAnimationType>? errorController;

  int timerValue = 60;
  Timer? periodicTimer;
  @override
  void initState() {
    super.initState();
    periodicTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() {
          if (timerValue == 1) {
            stopTimer();
          } else {
            timerValue--;
          }
        });
        // Update user about remaining time
      },
    );
  }

  stopTimer() {
    periodicTimer!.cancel();
    setState(() {
      isShowResend = true;
    });
  }

  startTimer() {
    setState(() {
      timerValue = 60;
      isShowResend = false;
    });

    periodicTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() {
          if (timerValue == 1) {
            stopTimer();
          } else {
            timerValue--;
          }
        });
        // Update user about remaining time
      },
    );
  }

  @override
  void dispose() {
    periodicTimer!.cancel();

    super.dispose();
  }

  _resendOtp() async {
    EasyLoading.show();
    try {
      var mapData = Map<String, dynamic>();

      mapData['country_code'] = "+91";
      mapData['phone_number'] = "${widget.phoneNumber}";
      var response = await HttpService.httpPostWithoutToken("sendOTP", mapData,
          context: context);

      if (response.statusCode == 201 || response.statusCode == 200) {
        var res = jsonDecode(response.body);

        if (res['success'].toString() == "1" &&
            res['status'].toString() == "200") {
          showToast(GlobalVariableForShowMessage.otpSendsuccess);
        } else {
          showToast(res['message'].toString());
        }
      } else if (response.statusCode == 401) {
        showToast(GlobalVariableForShowMessage.unauthorizedUser);
        // await UserPrefService().removeUserData();

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
    } finally {
      EasyLoading.dismiss();
    }
  }

  _checkOtp(String otp) async {
    EasyLoading.show();
    try {
      var mapData = Map<String, dynamic>();
      mapData['otp'] = otp;

      mapData['country_code'] = "+91";
      mapData['phone_number'] = "${widget.phoneNumber}";
      var response = await HttpService.httpPostWithoutToken(
          "activeAccount", mapData,
          context: context);

      if (response.statusCode == 201 || response.statusCode == 200) {
        var res = jsonDecode(response.body);

        if (res['success'].toString() == "1" &&
            res['status'].toString() == "200") {
          showToast(GlobalVariableForShowMessage.successfullyLogin);
          UserModel userData = UserModel.fromJson(res);
          var prowider = Provider.of<UserPrefService>(context, listen: false);
          await prowider.setUserData(userModel: userData);
          await prowider.setToken(userData.data!.token);

          var initdataService =
              Provider.of<InitialDataService>(context, listen: false);
          await initdataService.loadInitData(context);
          Navigator.pushAndRemoveUntil<void>(
            context,
            MaterialPageRoute<void>(
                builder: (BuildContext context) => MainScreen()),
            ModalRoute.withName(Routes.mainRoute),
          );
        } else {
          showToast(res['message'].toString());
        }
      } else if (response.statusCode == 401) {
        showToast(GlobalVariableForShowMessage.unauthorizedUser);
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
    } finally {
      EasyLoading.dismiss();
    }
  }

  _checkOtpForResetPAss(String otp) async {
    EasyLoading.show();
    try {
      var mapData = Map<String, dynamic>();
      mapData['otp'] = otp;
      // mapData['country_code'] = "+91";
      mapData['username'] = "${widget.phoneNumber}";
      var response = await HttpService.httpPostWithoutToken(
          "verifyOTP", mapData,
          context: context);

      if (response.statusCode == 201 || response.statusCode == 200) {
        var res = jsonDecode(response.body);

        if (res['success'].toString() == "1" &&
            res['status'].toString() == "200") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ChangePasswordScreen(
                  username: widget.phoneNumber.toString(), otp: otp),
            ),
          );
        } else {
          showToast(res['message'].toString());
        }
      } else if (response.statusCode == 401) {
        showToast(GlobalVariableForShowMessage.unauthorizedUser);
        // await UserPrefService().removeUserData();

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
    } finally {
      EasyLoading.dismiss();
    }
  }

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      color: ThemeClass.safeareBackGround,
      child: SafeArea(
        child: Scaffold(
          body: Container(
              color: ThemeClass.whiteColor,
              height: height,
              width: width,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height * 0.4,
                      child: _buildHeaderImage(height),
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    _buildView()
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Container _buildView() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Verify mobile number",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: ThemeClass.blueColor),
          ),
          SizedBox(
            height: 20,
          ),
          Text.rich(
            TextSpan(
                text: "A 6 digit code has been sent on your mobile number ",
                style: TextStyle(fontSize: 14, color: ThemeClass.greyDarkColor),
                children: <InlineSpan>[
                  TextSpan(
                    text: widget.phoneNumber.toString(),
                    style: TextStyle(fontSize: 14, color: ThemeClass.blueColor),
                  )
                ]),
          ),
          SizedBox(
            height: 50,
          ),
          Text(
            "Enter the verification code here",
            style: TextStyle(fontSize: 14, color: ThemeClass.greyDarkColor),
          ),
          SizedBox(
            height: 30,
          ),
          _buildOtpTextBox(),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(
                "Didn't get the code? ",
                style: TextStyle(fontSize: 14, color: ThemeClass.greyDarkColor),
              ),
              isShowResend
                  ? InkWell(
                      onTap: () {
                        _resendOtp();
                      },
                      child: Text(
                        "Resend",
                        style: TextStyle(
                            fontSize: 14, color: ThemeClass.blueColor),
                      ),
                    )
                  : Text(
                      "Resend in 00:${timerValue}.",
                      style:
                          TextStyle(fontSize: 14, color: ThemeClass.redColor),
                    )
            ],
          ),
          SizedBox(
            height: 40,
          ),
          ButtonWidget(
            title: "Login",
            color: ThemeClass.blueColor,
            callBack: () {
              if (formKey.currentState!.validate()) {
                if (widget.isfromResetPass) {
                  _checkOtpForResetPAss(textEditingController.text);
                } else {
                  _checkOtp(textEditingController.text);
                }
              }

              // Navigator.pushNamed(context, Routes.verifyMobileScreen);
            },
          ),
          SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }

  _buildOtpTextBox() {
    return Form(
      key: formKey,
      child: PinCodeTextField(
        appContext: context,
        pastedTextStyle: TextStyle(
          color: Colors.green.shade600,
          fontWeight: FontWeight.bold,
        ),
        length: 6,
        blinkWhenObscuring: true,
        animationType: AnimationType.fade,
        validator: (v) {
          if (v!.length < 3) {
            return GlobalVariableForShowMessage.pleasEenterVaildOTP;
          } else {
            return null;
          }
        },
        errorTextSpace: 30,
        textStyle: TextStyle(
            fontSize: 30,
            color: ThemeClass.blueColor,
            fontWeight: FontWeight.w600),
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.circle,
          // borderRadius: BorderRadius.circular(40),
          fieldHeight: 50,
          fieldWidth: 50,
          selectedFillColor: ThemeClass.blueColor.withOpacity(0.2),
          inactiveFillColor: ThemeClass.blueColor.withOpacity(0.2),
          activeFillColor: ThemeClass.blueColor.withOpacity(0.2),
          // errorBorderColor: ThemeClass.redColor.withOpacity(0.9),
          activeColor: Colors.transparent,
          inactiveColor: Colors.transparent,
          selectedColor: ThemeClass.blueColor.withOpacity(0.2),
        ),
        cursorColor: ThemeClass.blueColor,
        animationDuration: Duration(milliseconds: 300),
        enableActiveFill: true,
        errorAnimationController: errorController,
        controller: textEditingController,
        keyboardType: TextInputType.number,
        onCompleted: (v) {
          print("Completed");
        },
        onChanged: (value) {},
        beforeTextPaste: (text) {
          print("Allowing to paste $text");
          //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
          //but you can show anything you want here, like your pop up saying wrong paste format or etc
          return true;
        },
      ),
    );
  }

  Stack _buildHeaderImage(double height) {
    return Stack(
      children: [
        Transform.translate(
          offset: Offset(0.0, -30.0),
          child: Container(
            height: height * 0.4,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/login_top_background.png"),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: height * 0.07),
            child: Container(
              height: height * 0.15,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/splash_header_icon.png"),
                  // fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
