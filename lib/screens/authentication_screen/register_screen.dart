import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:heal_u/Global/global_enum_class.dart';
import 'package:heal_u/Global/global_variable_for_show_messge.dart';
import 'package:heal_u/model/user_model.dart';
import 'package:heal_u/screens/authentication_screen/social_register_screen.dart';
import 'package:heal_u/screens/authentication_screen/verify_mobile_screen.dart';
import 'package:heal_u/screens/main_screen/main_screen.dart';
import 'package:heal_u/service/http_service/http_service.dart';
import 'package:heal_u/service/prowider/initial_data_prowider.dart';
import 'package:heal_u/service/shared_pref_service/user_pref_service.dart';
import 'package:heal_u/themedata.dart';
import 'package:heal_u/widgets/button_widget/rounded_button_widget.dart';
import 'package:heal_u/widgets/general_button.dart';
import 'package:heal_u/widgets/general_widget.dart';
import 'package:heal_u/widgets/text_boxes/text_box_with_sufix.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../routes.dart';

class RegisterScreen extends StatefulWidget {
  final String? email;

  const RegisterScreen({
    Key? key,
    this.email,
  }) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isFirstSubmit = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _phonenumberController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _referralCodeController = TextEditingController();
  @override
  void initState() {
    _emailController.text = widget.email != null && widget.email != "null"
        ? widget.email.toString()
        : "";

    super.initState();
  }

  bool isCheckTandC = false;
  bool isLoading = false;
  bool _isObcs = true;
  _togglePassword() {
    setState(() {
      _isObcs = !_isObcs;
    });
  }

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

    mapData['name'] = _fullnameController.text;
    mapData['email'] = _emailController.text;
    mapData['country_code'] = "+91";
    mapData['phone_number'] = _phonenumberController.text;
    mapData['password'] = _passwordController.text;
    mapData['gender'] = _radioMF.name;
    mapData['dob'] = _birthdateController.text;
    mapData['referral_code'] = _referralCodeController.text;

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

  final _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? googleSignInAccount;
  _googleLogin() async {
    EasyLoading.show();
    googleSignInAccount = await _googleSignIn.signIn();

    if (googleSignInAccount!.email.isNotEmpty) {
      _socialLogin("Google", googleSignInAccount!.email.toString(), null);
    } else {
      EasyLoading.dismiss();
    }
  }

  var facebookLogin = FacebookLogin();
  void initiateFacebookLogin() async {
    EasyLoading.show();
    var facebookLoginResult =
        await facebookLogin.logIn(permissions: [FacebookPermission.email]);
    if (facebookLoginResult.status == FacebookLoginStatus.success) {
      final email = await facebookLogin.getUserEmail();

      if (email != null) {
        _socialLogin("Facebook", email, null);
      } else {
        EasyLoading.dismiss();
        showToast("Please authorize email");
      }
    } else {
      EasyLoading.dismiss();
    }
  }

  _showSettingDialog() {
    var alertDialog = AlertDialog(
      title: Text("Stop using Apple Id from this app"),
      content: Text(
          "1. Open the Settings app, then tap your name.\n 2. Tap Password & Security.\n 3. Tap Apps Using Apple ID.\n 4. Click on 'Stop using Apple ID"),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Container(
              color: Color.fromARGB(255, 2, 83, 149),
              padding: const EdgeInsets.all(14),
              child: const Text(
                "Okay, Got It !",
                style: TextStyle(color: Colors.white),
              )),
        ),
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  _socialLogin(String platform, String email, String? token) async {
    var mapData = <String, dynamic>{};
    mapData['username'] = email;
    mapData['platform'] = platform;
    if (platform == "Apple") {
      mapData['social_media_token'] = token;
    }

    try {
      var response = await HttpService.httpPostWithoutToken(
          "login-with-social", mapData,
          context: context);
      if (platform != "Facebook") {
        await _googleSignIn.signOut();
      } else {
        await facebookLogin.logOut();
      }

      if (response.statusCode == 201 || response.statusCode == 200) {
        var res = jsonDecode(response.body);

        if (res['success'].toString() == "1" &&
            res['status'].toString() == "200") {
          UserModel userData = UserModel.fromJson(res);

          var prowider = Provider.of<UserPrefService>(context, listen: false);

          await prowider.setUserData(userModel: userData);
          await prowider.setToken(userData.data!.token);

          // await UserPrefService().setUserData(userModel: userData);
          showToast(res['message']);
          var initdataService =
              Provider.of<InitialDataService>(context, listen: false);
          await initdataService.loadInitData(context);

          Navigator.pushAndRemoveUntil<void>(
            context,
            MaterialPageRoute<void>(
                builder: (BuildContext context) => MainScreen()),
            ModalRoute.withName(Routes.mainRoute),
          );
        } else if (res['status'].toString() == "202") {
          var phonenumber = res['data']['phone_number'].toString();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  VerifyMobileScreen(phoneNumber: phonenumber),
            ),
          );
          showToast(res['message']);
        } else if (res['status'].toString() == "201") {
          pushNewScreen(context,
              screen: SocialRegisterScreen(
                email: email,
                platform: platform,
                token: platform == "Apple" ? token : null,
              ));
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
      EasyLoading.dismiss();
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
              "Register",
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
                } else if (value.length != 10) {
                  return GlobalVariableForShowMessage.phoneNumberinvalied;
                }
              },
            ),
            SizedBox(
              height: 20,
            ),
            TextFiledWidget(
              backColor: ThemeClass.whiteDarkColor,
              isObcurs: _isObcs,
              oniconTap: () {
                _togglePassword();
              },
              hinttext: "Password",
              controllers: _passwordController,
              icon: _isObcs
                  ? "assets/images/lock_icon.png"
                  : "assets/images/unlock_icon.png",
              validator: (value) {
                if (value!.isEmpty) {
                  return GlobalVariableForShowMessage.EmptyErrorMessage +
                      "Password";
                } else if (value.length < 6) {
                  return GlobalVariableForShowMessage.passwordshoudbeatleat;
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
            TextFiledWidget(
              backColor: ThemeClass.whiteDarkColor,
              hinttext: "Referral Code",
              controllers: _referralCodeController,
              icon: "assets/images/refere_icon.png",
              isClickable: false,
              isReadOnly: false,
              validator: (value) {},
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
            _buildSocialLoginTitle(),
            SizedBox(
              height: 20,
            ),
            _buildSocialIcon(),
            SizedBox(
              height: 20,
            ),
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
            Navigator.pop(context);
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

  Row _buildSocialIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButtonWidget(
          onPressed: () {
            initiateFacebookLogin();
          },
          child: Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/facebook_icon.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        TextButtonWidget(
          onPressed: () {
            _googleLogin();
          },
          child: Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/google_icon.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        Platform.isIOS
            ? SizedBox(
                width: 20,
              )
            : SizedBox(),
        Platform.isIOS
            ? TextButtonWidget(
                onPressed: () {
                  _appleSignIn();
                },
                child: Container(
                  height: 55,
                  width: 55,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/apple_icon.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              )
            : SizedBox(),
      ],
    );
  }

  _appleSignIn() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      ); // ignore: avoid_print

      if (credential.email == null) {
        _showSettingDialog();
        // show alert dialog for setting disable login
      } else {
        _socialLogin("Apple", credential.email.toString(),
            credential.userIdentifier.toString());
      }
    } catch (e) {
      if (!e.toString().contains("SignInWithAppleAuthorizationError")) {
        showToast(e.toString());
      }
    }
  }

  Row _buildSocialLoginTitle() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: Colors.black,
          ),
        ),
        Expanded(
          flex: 2,
          child: Center(
            child: SizedBox(
              child: Text(
                "Register with Social",
                style: TextStyle(color: ThemeClass.greyDarkColor),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

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
