import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:heal_u/Global/global_variable_for_show_messge.dart';

import 'package:heal_u/screens/authentication_screen/login_screen.dart';

import 'package:heal_u/service/http_service/http_service.dart';

import 'package:heal_u/themedata.dart';
import 'package:heal_u/widgets/button_widget/rounded_button_widget.dart';
import 'package:heal_u/widgets/general_widget.dart';
import 'package:heal_u/widgets/text_boxes/text_box_with_sufix.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen(
      {Key? key, required this.username, required this.otp})
      : super(key: key);
  final String username;
  final String otp;

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _cpasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isFirstSubmit = true;
  bool _isObcs = true;
  bool _isObcs2 = true;

  _togglePassword() {
    setState(() {
      _isObcs = !_isObcs;
    });
  }

  _togglePassword2() {
    setState(() {
      _isObcs2 = !_isObcs2;
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
                "Change Password",
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
              "Please enter new password for your login account.",
              style: TextStyle(fontSize: 13, color: ThemeClass.greyDarkColor),
            ),
            SizedBox(
              height: 30,
            ),
            TextFiledWidget(
              backColor: ThemeClass.whiteDarkColor,
              hinttext: "New Password",
              isObcurs: _isObcs,
              oniconTap: () {
                _togglePassword();
              },
              controllers: _passwordController,
              icon: _isObcs
                  ? "assets/images/lock_icon.png"
                  : "assets/images/unlock_icon.png",
              validator: (value) {
                if (value!.isEmpty) {
                  return GlobalVariableForShowMessage.EmptyErrorMessage +
                      "New Password";
                } else if (value.length < 6) {
                  return GlobalVariableForShowMessage.passwordshoudbeatleat;
                }
              },
            ),
            SizedBox(
              height: 20,
            ),
            TextFiledWidget(
              backColor: ThemeClass.whiteDarkColor,
              hinttext: "Confirm Password",
              isObcurs: _isObcs2,
              oniconTap: () {
                _togglePassword2();
              },
              controllers: _cpasswordController,
              icon: _isObcs2
                  ? "assets/images/lock_icon.png"
                  : "assets/images/unlock_icon.png",
              validator: (value) {
                if (value!.isEmpty) {
                  return GlobalVariableForShowMessage.EmptyErrorMessage +
                      "Confirm Password";
                } else if (value.length < 6) {
                  return GlobalVariableForShowMessage.passwordshoudbeatleat;
                } else if (value != _passwordController.text) {
                  return GlobalVariableForShowMessage.passwordshoudbeatsame;
                }
              },
            ),
            SizedBox(
              height: 30,
            ),
            ButtonWidget(
                isLoading: isLoading,
                title: "Change Password",
                color: ThemeClass.blueColor,
                callBack: () {
                  setState(() {
                    isFirstSubmit = false;
                  });
                  if (_formKey.currentState!.validate()) {
                    print("asdasdasdasd");
                    // _login();

                    changePassword();
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

  changePassword() async {
    setState(() {
      isLoading = true;
    });

    var mapData = Map<String, dynamic>();

    mapData['otp'] = widget.otp.toString();
    mapData['username'] = widget.username.toString();
    mapData['new_password'] = _passwordController.text;
    mapData['confirm_password'] = _cpasswordController.text;
    try {
      var response = await HttpService.httpPostWithoutToken(
          "reset-password", mapData,
          context: context);

      if (response.statusCode == 201 || response.statusCode == 200) {
        var res = jsonDecode(response.body);

        if (res['success'].toString() == "1" &&
            res['status'].toString() == "200") {
          showToast(res['message']);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
          );
        } else if (res['status'].toString() == "202") {
          showToast(res['message']);
        } else {
          showToast(res['message']);
        }
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
      setState(() {
        isLoading = false;
      });
    }
  }
}
