import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:heal_u/Global/global_variable_for_show_messge.dart';
import 'package:heal_u/model/user_model.dart';
import 'package:heal_u/routes.dart';
import 'package:heal_u/screens/authentication_screen/forgot_password_screen.dart';
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
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isFirstSubmit = true;
  bool _isObcs = true;
  _togglePassword() {
    setState(() {
      _isObcs = !_isObcs;
    });
  }

  final _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? googleSignInAccount;
  _googleLogin() async {
    try {
      EasyLoading.show();
      googleSignInAccount = await _googleSignIn.signIn().catchError((e) {
        print(e);
      }).onError((error, stackTrace) {
        print(error);
      });

      if (googleSignInAccount != null) {
        if (googleSignInAccount!.email.isNotEmpty) {
          _socialLogin("Google", googleSignInAccount!.email.toString(), null);
        }
      }
    } on PlatformException catch (err) {
      showToast(err.toString());
    } finally {
      EasyLoading.dismiss();
    }
  }

  var facebookLogin = FacebookLogin();
  void initiateFacebookLogin() async {
    var facebookLoginResult =
        await facebookLogin.logIn(permissions: [FacebookPermission.email]);
    if (facebookLoginResult.status == FacebookLoginStatus.success) {
      final email = await facebookLogin.getUserEmail();

      if (email != null) {
        _socialLogin("Facebook", email, null);
      } else {
        showToast("Please authorize email");
      }
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
              color: ThemeClass.whiteColorgrey,
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
                    _buildView(),
                    SizedBox(
                      height: height * 0.1,
                    ),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    "Hello Again! ",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: ThemeClass.blackColor),
                  ),
                ),
                Container(
                  height: 23,
                  width: 23,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/hand_icon.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Text(
                "Welcome back, you've been missed",
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: ThemeClass.greyColor),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            TextFiledWidget(
              backColor: ThemeClass.whiteDarkColor,
              hinttext: "Phone Number or Email",
              controllers: _emailController,
              icon: "assets/images/user_icon.png",
              validator: (value) {
                if (value!.isEmpty) {
                  return GlobalVariableForShowMessage.EmptyErrorMessage +
                      "Phone Number or Email";
                }
              },
            ),
            SizedBox(
              height: 20,
            ),
            TextFiledWidget(
              backColor: ThemeClass.whiteDarkColor,
              hinttext: "Password",
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
                      "Password";
                } else if (value.length < 6) {
                  return GlobalVariableForShowMessage.passwordshoudbeatleat;
                }
              },
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ForgotPasswordScreen()),
                );
              },
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Forgot Password ?",
                  style: TextStyle(color: ThemeClass.redColor, fontSize: 16),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ButtonWidget(
                isLoading: isLoading,
                title: "Login",
                color: ThemeClass.blueColor,
                callBack: () {
                  setState(() {
                    isFirstSubmit = false;
                  });
                  if (_formKey.currentState!.validate()) {
                    _loginUser();
                  }
                }),
            SizedBox(
              height: 30,
            ),
            // _buildSocialLoginTitle(),
            // SizedBox(
            //   height: 20,
            // ),
            // _buildSocialIcon(),
            // SizedBox(
            //   height: 20,
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style:
                      TextStyle(color: ThemeClass.greyDarkColor, fontSize: 16),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.registerScreen);
                  },
                  child: Text("Register",
                      style: TextStyle(
                        color: ThemeClass.blueColor3,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      )),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButtonWidget(
          onPressed: () {
            // _signInWithFacebook();
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
                  _appleSignIn(context);
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
            child: Container(
              child: Text(
                "Login with Social",
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
        Transform.scale(
          scale: 1.2,
          child: Container(
            height: height * 0.4,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/login_top_bg.png"),
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
              height: height * 0.25,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/splash_main_icon.png"),
                  // fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  _loginUser() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      var mapData = Map<String, dynamic>();
      mapData['username'] = _emailController.text;
      mapData['password'] = _passwordController.text;
      mapData['device_token'] = "0";
      mapData['device_type'] = Platform.isAndroid ? "android" : "ios";

      try {
        var response = await HttpService.httpPostWithoutToken("login", mapData,
            context: context);

        if (response.statusCode == 201 || response.statusCode == 200) {
          var res = jsonDecode(response.body);

          if (res['success'].toString() == "1" &&
              res['status'].toString() == "200") {
            UserModel userData = UserModel.fromJson(res);

            var prowider = Provider.of<UserPrefService>(context, listen: false);

            await prowider.setUserData(userModel: userData);
            await prowider.setToken(userData.data!.token);

            var initdataService =
                Provider.of<InitialDataService>(context, listen: false);
            await initdataService.loadInitData(context);

            showToast(res['message']);
            Navigator.pushAndRemoveUntil<void>(
              context,
              MaterialPageRoute<void>(
                  builder: (BuildContext context) => MainScreen()),
              ModalRoute.withName(Routes.mainRoute),
            );
          } else if (res['status'].toString() == "202") {
            var Phonenumber = res['data']['phone_number'].toString();
            var countryCode = res['data']['country_code'].toString();
            var email = res['data']['email'].toString();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    VerifyMobileScreen(phoneNumber: Phonenumber),
              ),
            );
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

  _appleSignIn(BuildContext context) async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ]);

      print("email -> ${credential.email}");
      print("identy token -> ${credential.identityToken}");
      print("auth token -> ${credential.authorizationCode}");
      print("auth token -> ${credential.userIdentifier}");
      _socialLogin(
        "Apple",
        credential.email.toString(),
        credential.userIdentifier,
      );
    } catch (e) {
      print(e);

      if (!e.toString().contains("SignInWithAppleAuthorizationError")) {
        showToast(e.toString());
      }
    }
  }

  _socialLogin(String platform, String email, String? token) async {
    EasyLoading.show();
    var mapData = <String, dynamic>{};
    mapData['username'] = email;
    mapData['platform'] = platform;

    if (platform == "Apple") {
      mapData['username'] = token;
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

          var initdataService =
              Provider.of<InitialDataService>(context, listen: false);
          await initdataService.loadInitData(context);
          showToast(res['message']);

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
          if (email == "null" || email == null) {
            _showSettingDialog();
            // show alert dialog for setting disable login
          } else {
            if (platform == "Apple") {
              pushNewScreen(context,
                  screen: SocialRegisterScreen(
                    email: email,
                    platform: platform,
                    token: token,
                  ));
            } else {
              showToast("Please register to continue");
            }
          }
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
}
