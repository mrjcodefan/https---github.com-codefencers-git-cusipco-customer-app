import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:heal_u/Global/global_enum_class.dart';
import 'package:heal_u/Global/global_variable_for_show_messge.dart';
import 'package:heal_u/screens/authentication_screen/login_screen.dart';

import 'package:heal_u/screens/authentication_screen/verify_mobile_screen.dart';

import 'package:heal_u/service/http_service/http_service.dart';

import 'package:heal_u/themedata.dart';
import 'package:heal_u/widgets/button_widget/rounded_button_widget.dart';
import 'package:heal_u/widgets/general_widget.dart';
import 'package:heal_u/widgets/text_boxes/text_box_with_sufix.dart';
import 'package:intl/intl.dart';

class SocialRegisterScreen extends StatefulWidget {
  final String email;
  final String platform;
  final String? token;
  const SocialRegisterScreen({
    Key? key,
    required this.email,
    required this.platform,
    this.token,
  }) : super(key: key);

  @override
  State<SocialRegisterScreen> createState() => _SocialRegisterScreenState();
}

class _SocialRegisterScreenState extends State<SocialRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isFirstSubmit = true;
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _phonenumberController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  @override
  void initState() {
    _emailController.text = widget.email.toString();

    super.initState();
  }

  bool isCheckTandC = false;
  bool isLoading = false;

  enumForMF _radioMF = enumForMF.Male;

  DateTime currentDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(1950),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: ThemeClass.blueColor, // <-- SEE HERE
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: ThemeClass.blueColor, // button text color
                ),
              ),
            ),
            child: child!,
          );
        },
        lastDate: currentDate);
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);

        _birthdateController.text = formattedDate;
      });
    }
  }

  registerData() async {
    setState(() {
      isLoading = true;
    });
    var mapData = <String, dynamic>{};
    mapData['platform'] = widget.platform;
    mapData['name'] = _fullnameController.text;
    mapData['email'] = _emailController.text;
    mapData['country_code'] = "+91";
    mapData['phone_number'] = _phonenumberController.text;

    mapData['gender'] = _radioMF.name;
    mapData['dob'] = _birthdateController.text;
    if (widget.token != null) {
      mapData['social_media_token'] = widget.token.toString();
    }

    try {
      var response = await HttpService.httpPostWithoutToken(
          "registration", mapData,
          context: context);

      if (response.statusCode == 201 || response.statusCode == 200) {
        var res = jsonDecode(response.body);

        if (res['success'].toString() == "1" &&
            res['status'].toString() == "200") {
          showToast(res['message']);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerifyMobileScreen(
                phoneNumber: _phonenumberController.text,
              ),
            ),
          );
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
                      height: height * 0.23,
                      child: _buildHeaderImage(height),
                    ),
                    SizedBox(
                      height: height * 0.01,
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
            Text(
              "Register With Social Media",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: ThemeClass.blueColor),
            ),
            SizedBox(
              height: 20,
            ),
            TextFiledWidget(
              backColor: ThemeClass.whiteDarkColor,
              hinttext: "Full Name",
              controllers: _fullnameController,
              icon: "assets/images/user_icon.png",
              validator: (value) {
                if (value!.isEmpty) {
                  return GlobalVariableForShowMessage.EmptyErrorMessage +
                      "Full Name";
                }
              },
            ),
            SizedBox(
              height: 20,
            ),
            TextFiledWidget(
              isReadOnly: true,
              backColor: ThemeClass.whiteDarkColor,
              hinttext: "Email address",
              controllers: _emailController,
              icon: "assets/images/email_icon.png",
              validator: (value) {
                if (value!.isEmpty) {
                  return GlobalVariableForShowMessage.EmptyErrorMessage +
                      "Email address";
                } else if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                    .hasMatch(value)) {
                  return GlobalVariableForShowMessage.pleasEenterVaildEmail;
                }
              },
            ),
            SizedBox(
              height: 20,
            ),
            TextFiledWidget(
              backColor: ThemeClass.whiteDarkColor,
              hinttext: "Phone Number",
              isNumber: true,
              controllers: _phonenumberController,
              icon: "assets/images/telephone_icon.png",
              validator: (value) {
                if (value!.isEmpty) {
                  return GlobalVariableForShowMessage.EmptyErrorMessage +
                      "Phone Number";
                } else if (value.length < 10) {
                  return GlobalVariableForShowMessage.phoneNumberinvalied;
                }
              },
            ),

            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                "Select Gender",
                style: TextStyle(fontSize: 10, color: ThemeClass.greyDarkColor),
              ),
            ),
            _buildRadioButton(),
            SizedBox(
              height: 15,
            ),
            TextFiledWidget(
              backColor: ThemeClass.whiteDarkColor,
              oniconTap: () {
                print("object");
                _selectDate(context);
              },
              hinttext: "Date of Birth",
              controllers: _birthdateController,
              icon: "assets/images/calender_icon.png",
              isClickable: true,
              isReadOnly: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return GlobalVariableForShowMessage.EmptyErrorMessage +
                      "Date of Birth";
                }
              },
            ),
            SizedBox(
              height: 20,
            ),
            _buildCheckBox(),
            SizedBox(
              height: 40,
            ),
            ButtonWidget(
                title: "Register",
                isLoading: isLoading,
                isdisable: !isCheckTandC,
                color: ThemeClass.blueColor,
                callBack: () {
                  setState(() {
                    isFirstSubmit = false;
                  });
                  if (_formKey.currentState!.validate()) {
                    registerData();
                  }
                }),
            SizedBox(
              height: 40,
            ),
            // _buildSocialLoginTitle(),
            // SizedBox(
            //   height: 20,
            // ),
            // _buildSocialIcon(),
            // SizedBox(
            //   height: 20,
            // ),
            _buildBottomTitle(),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Row _buildCheckBox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Theme(
          data: ThemeData(
            checkboxTheme: CheckboxThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          child: Transform.scale(
            scale: 1.2,
            child: Checkbox(
              side: MaterialStateBorderSide.resolveWith(
                  (_) => BorderSide(width: 1.2, color: ThemeClass.blueColor)),
              activeColor: ThemeClass.blueColor,
              fillColor: MaterialStateProperty.all(ThemeClass.blueColor),
              splashRadius: 20,
              value: isCheckTandC,
              // shape: MaterialStateOutlinedBorder(),
              // materialTapTargetSize: MaterialTapTargetSize.,
              onChanged: (bool? value) {
                setState(() {
                  isCheckTandC = value!;
                });
              },
            ),
          ),
        ),
        Text.rich(
          TextSpan(
              text: "Accept ",
              style: TextStyle(fontSize: 12, color: ThemeClass.greyDarkColor),
              children: <InlineSpan>[
                TextSpan(
                  text: 'Terms ',
                  style: TextStyle(fontSize: 12, color: ThemeClass.blueColor),
                ),
                TextSpan(
                  text: '& ',
                  style:
                      TextStyle(fontSize: 12, color: ThemeClass.greyDarkColor),
                ),
                TextSpan(
                  text: 'Condition',
                  style: TextStyle(fontSize: 12, color: ThemeClass.blueColor),
                )
              ]),
        ),
      ],
    );
  }

  Row _buildBottomTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already exists?",
          style: TextStyle(color: ThemeClass.greyDarkColor, fontSize: 16),
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).pushReplacement(
                (MaterialPageRoute(builder: (context) => LoginScreen())));
          },
          child: Text(
            "   Login",
            style: TextStyle(color: ThemeClass.blueColor, fontSize: 16),
          ),
        )
      ],
    );
  }

  Row _buildRadioButton() {
    return Row(
      children: [
        Radio(
          value: enumForMF.Male,
          activeColor: ThemeClass.blueColor,
          fillColor: MaterialStateProperty.all(ThemeClass.blueColor),
          groupValue: _radioMF,
          onChanged: (enumForMF? value) {
            setState(() {
              _radioMF = value!;
            });
          },
        ),
        Text('Male'),
        SizedBox(
          width: 30,
        ),
        Radio(
          value: enumForMF.Female,
          activeColor: ThemeClass.blueColor,
          fillColor: MaterialStateProperty.all(ThemeClass.blueColor),
          groupValue: _radioMF,
          onChanged: (enumForMF? value) {
            setState(() {
              _radioMF = value!;
            });
          },
        ),
        Text('Female')
      ],
    );
  }

  // Row _buildSocialIcon() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       Container(
  //         height: 55,
  //         width: 55,
  //         decoration: BoxDecoration(
  //           image: DecorationImage(
  //             image: AssetImage('assets/images/facebook_icon.png'),
  //             fit: BoxFit.contain,
  //           ),
  //         ),
  //       ),
  //       SizedBox(
  //         width: 20,
  //       ),
  //       Container(
  //         height: 55,
  //         width: 55,
  //         decoration: BoxDecoration(
  //           image: DecorationImage(
  //             image: AssetImage('assets/images/google_icon.png'),
  //             fit: BoxFit.contain,
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Row _buildSocialLoginTitle() {
  //   return Row(
  //     children: [
  //       Expanded(
  //         child: Container(
  //           height: 1,
  //           color: Colors.black,
  //         ),
  //       ),
  //       Expanded(
  //         flex: 2,
  //         child: Center(
  //           child: SizedBox(
  //             child: Text(
  //               "Register with Social",
  //               style: TextStyle(color: ThemeClass.greyDarkColor),
  //             ),
  //           ),
  //         ),
  //       ),
  //       Expanded(
  //         child: Container(
  //           height: 1,
  //           color: Colors.black,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Stack _buildHeaderImage(double height) {
    return Stack(
      children: [
        Transform.translate(
          offset: Offset(0.0, -20.0),
          child: Container(
            height: height * 0.23,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/login_top_background.png"),
                  fit: BoxFit.cover,
                  alignment: Alignment.bottomCenter),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: height * 0.02),
            child: Container(
              height: height * 0.12,
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
