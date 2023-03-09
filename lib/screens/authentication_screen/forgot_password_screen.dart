import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:heal_u/Global/global_variable_for_show_messge.dart';
import 'package:heal_u/model/user_model.dart';
import 'package:heal_u/routes.dart';
import 'package:heal_u/screens/authentication_screen/change_password_screen.dart';
import 'package:heal_u/screens/authentication_screen/verify_mobile_screen.dart';
import 'package:heal_u/screens/main_screen/cart/cart_prowider_service.dart';
import 'package:heal_u/screens/main_screen/main_screen.dart';
import 'package:heal_u/service/http_service/http_service.dart';
import 'package:heal_u/service/prowider/initial_data_prowider.dart';
import 'package:heal_u/service/shared_pref_service/user_pref_service.dart';
import 'package:heal_u/themedata.dart';
import 'package:heal_u/widgets/button_widget/rounded_button_widget.dart';
import 'package:heal_u/widgets/general_widget.dart';
import 'package:heal_u/widgets/text_boxes/text_box_with_sufix.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController _emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isFirstSubmit = true;
  bool _isObcs = true;
  _togglePassword() {
    setState(() {
      _isObcs = !_isObcs;
    });
  }

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
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height * 0.4,
                      child: _buildHeaderImage(height),
                    ),
                    SizedBox(
                      height: height * 0.06,
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
      child: Form(
        key: _formKey,
        autovalidateMode: !isFirstSubmit
            ? AutovalidateMode.always
            : AutovalidateMode.disabled,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: Text(
                "Forgot Password ?",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: ThemeClass.blueColor),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Please enter your registered phone number for received OTP code.",
              style: TextStyle(fontSize: 13, color: ThemeClass.greyDarkColor),
            ),
            SizedBox(
              height: 30,
            ),
            TextFiledWidget(
              backColor: ThemeClass.whiteDarkColor,
              hinttext: "Phone Number",
              controllers: _emailController,
              icon: "assets/images/telephone_icon.png",
              validator: (value) {
                if (value!.isEmpty) {
                  return GlobalVariableForShowMessage.EmptyErrorMessage +
                      "Phone Number or Email";
                }
              },
            ),
            SizedBox(
              height: 30,
            ),
            ButtonWidget(
                isLoading: isLoading,
                title: "Get Code",
                color: ThemeClass.blueColor,
                callBack: () {
                  setState(() {
                    isFirstSubmit = false;
                  });
                  if (_formKey.currentState!.validate()) {
                    print("asdasdasdasd");
                    _resendOtp();
                    //          Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) =>
                    //         VerifyMobileScreen(phoneNumber: Phonenumber),
                    //   ),
                    // );

                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => ChangePasswordScreen(),
                    //   ),
                    // );
                  }
                }),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  Stack _buildHeaderImage(double height) {
    return Stack(
      children: [
        Transform.translate(
          offset: Offset(0.0, -40.0),
          child: Container(
            height: height * 0.4,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/login_top_background.png"),
                fit: BoxFit.fill,
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

  _resendOtp() async {
    EasyLoading.show();
    try {
      var mapData = Map<String, dynamic>();

      mapData['country_code'] = "+91";
      mapData['phone_number'] = _emailController.text;
      var response = await HttpService.httpPostWithoutToken("sendOTP", mapData,
          context: context);

      if (response.statusCode == 201 || response.statusCode == 200) {
        var res = jsonDecode(response.body);

        if (res['success'].toString() == "1" &&
            res['status'].toString() == "200") {
          showToast(GlobalVariableForShowMessage.otpSendsuccess);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerifyMobileScreen(
                phoneNumber: _emailController.text,
                isfromResetPass: true,
              ),
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
}
