import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:heal_u/Global/global_enum_class.dart';
import 'package:heal_u/Global/global_variable_for_show_messge.dart';
import 'package:heal_u/Global/globle_methd.dart';
import 'package:heal_u/model/user_model.dart';
import 'package:heal_u/screens/main_screen/my_account/profile/select_activity_widget.dart';
import 'package:heal_u/service/http_service/http_service.dart';
import 'package:heal_u/service/navigation_service.dart';
import 'package:heal_u/service/shared_pref_service/user_pref_service.dart';
import 'package:heal_u/themedata.dart';
import 'package:heal_u/widgets/app_bars/appbar_with_text.dart';
import 'package:heal_u/widgets/button_widget/rounded_button_widget.dart';
import 'package:heal_u/widgets/general_widget.dart';
import 'package:heal_u/widgets/text_boxes/text_box_normal.dart';
import 'package:heal_u/widgets/text_boxes/text_box_with_sufix.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MyProfileScreen extends StatefulWidget {
  MyProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen>
    with TickerProviderStateMixin {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _dateofbirthController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isFirstSubmit = true;
  DateTime currentDate = DateTime.now();
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<Offset> _offsetAnimation;

  bool isCheckTandC = false;
  bool _isLoading = false;
  enumForMF _radioMF = enumForMF.Male;
  bool isFirstLoad = true;
  File? ImagePAth;

  String _activityValue = "";
  bool _isExpanded = false;
  _setActivity(String val) {
    setState(() {
      _activityValue = val;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 700),
        vsync: this,
        value: 0,
        lowerBound: 0,
        upperBound: 1);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInBack);
    _offsetAnimation = Tween<Offset>(
      begin: Offset(0.0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.decelerate,
    ));

    _controller.forward();
  }

  _updateUserData() async {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      _isLoading = true;
    });

    String datePattern = "dd-MM-yyyy";

    DateTime birthDate =
        DateFormat(datePattern).parse(_dateofbirthController.text);
    String formattedDate = DateFormat('yyyy-MM-dd').format(birthDate);

    var user = UserData(
      name: _nameController.text,
      email: _emailController.text,
      countryCode: "+91",
      phoneNumber: _phoneController.text,
      gender: _radioMF.name,
      dob: formattedDate,
      age: _ageController.text,
      activity: _activityValue,
      height: _heightController.text,
      weight: _weightController.text,
    ).toJson();

    print(user);

    if (ImagePAth != null) {
      try {
        var data = ({'image': ""});
        var response = await HttpService.httpPostWithImageUpload(
            "update_profilePicture", ImagePAth, data,
            peramterName: "image");
        var res = jsonDecode(response.body);
        if (response.statusCode == 201 || response.statusCode == 200) {
          if (res['success'].toString() == "1" &&
              res['status'].toString() == "200") {
            _updateAllFieldValue(user);
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
          print(e.toString());
        }
      }
    } else {
      _updateAllFieldValue(user);
    }
  }

  _updateAllFieldValue(user) async {
    try {
      var response =
          await HttpService.httpPost("updateProfile", user, context: context);
      var res = jsonDecode(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        if (res['success'].toString() == "1" &&
            res['status'].toString() == "200") {
          UserModel userData = UserModel.fromJson(res);

          await Provider.of<UserPrefService>(context, listen: false)
              .setUserData(userModel: userData);
          showToast(res['message']);
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
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String? img;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      color: ThemeClass.safeareBackGround,
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(65.0),
              child: AppBarWithTextAndBackWidget(
                onbackPress: () {
                  Navigator.pop(context);
                },
                title: "My Profile",
              )),
          body: Container(
            color: ThemeClass.whiteColor,
            height: height,
            width: width,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(top: 25, left: 25, right: 25),
                child: SlideTransition(
                  position: _offsetAnimation,
                  child: FadeTransition(
                    opacity: _animation,
                    child: Consumer<UserPrefService>(
                        builder: (context, navProwider, child) {
                      if (isFirstLoad) {
                        _nameController.text =
                            navProwider.globleUserModel!.data!.name ?? "";
                        img = navProwider.globleUserModel!.data!.profileImage;
                        _emailController.text =
                            navProwider.globleUserModel!.data!.email ?? "";
                        _phoneController.text =
                            navProwider.globleUserModel!.data!.phoneNumber ??
                                "";

                        _heightController.text =
                            navProwider.globleUserModel!.data!.height ?? "";
                        _weightController.text =
                            navProwider.globleUserModel!.data!.weight ?? "";

                        _ageController.text =
                            navProwider.globleUserModel!.data!.age ?? "";

                        _activityValue =
                            navProwider.globleUserModel!.data!.activity ?? "";
                        _dateofbirthController.text = getddmmyyyy(
                            navProwider.globleUserModel!.data!.dob.toString());

                        if (navProwider.globleUserModel!.data!.gender ==
                            "Male") {
                          _radioMF = enumForMF.Male;
                        } else {
                          _radioMF = enumForMF.Female;
                        }
                      }

                      isFirstLoad = false;

                      return Form(
                        key: _formKey,
                        autovalidateMode: !isFirstSubmit
                            ? AutovalidateMode.always
                            : AutovalidateMode.disabled,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildCircleImage(),
                            SizedBox(
                              height: 40,
                            ),
                            _buildTextTitle("Full Name"),
                            TextFiledWidget(
                              backColor: ThemeClass.whiteDarkColor,
                              hinttext: "Full Name",
                              controllers: _nameController,
                              icon: "assets/images/user_icon.png",
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return GlobalVariableForShowMessage
                                          .EmptyErrorMessage +
                                      "Full Name";
                                }
                              },
                            ),
                            _buildTextTitle("Email Address"),
                            TextFiledWidget(
                              hinttext: "Email Address",
                              backColor: ThemeClass.whiteDarkColor,
                              isReadOnly: true,
                              controllers: _emailController,
                              icon: "assets/images/email_icon.png",
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return GlobalVariableForShowMessage
                                          .EmptyErrorMessage +
                                      "Email address";
                                } else if (!RegExp(
                                        "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                    .hasMatch(value)) {
                                  return GlobalVariableForShowMessage
                                      .pleasEenterVaildEmail;
                                }
                              },
                            ),
                            _buildTextTitle("Phone Number"),
                            TextFiledWidget(
                              backColor: ThemeClass.whiteDarkColor,
                              hinttext: "Phone Number",
                              controllers: _phoneController,
                              isReadOnly: true,
                              icon: "assets/images/telephone_icon.png",
                              isNumber: true,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return GlobalVariableForShowMessage
                                          .EmptyErrorMessage +
                                      "Phone Number";
                                } else if (value.length != 10) {
                                  return GlobalVariableForShowMessage
                                      .phoneNumberinvalied;
                                }
                              },
                            ),
                            _buildTextTitle("Date Of Birth"),

                            _buildDateAndAge(context),
                            SizedBox(
                              height: 5,
                            ),
                            _buildTextTitle("Select Gender"),
                            _buildRadioButton(),
                            SizedBox(
                              height: 5,
                            ),
                            _buildTextTitle("Select Activity"),

                            SelectActivityDropdownWidget(
                              expandcallBack: (val) {},
                              currentValue: _activityValue,
                              callBack: (val) => _setActivity(val),
                            ),
                            // SizedBox(
                            //   height: 30,
                            // ),
                            _buildHeightWidth(),
                            SizedBox(
                              height: 30,
                            ),
                            ButtonWidget(
                                title: "Update Profile",
                                isLoading: _isLoading,
                                color: ThemeClass.blueColor,
                                callBack: () async {
                                  setState(() {
                                    isFirstSubmit = false;
                                  });
                                  if (_formKey.currentState!.validate()) {
                                    if (_activityValue != "") {
                                      _updateUserData();
                                    } else {
                                      showToast("Please select activity");
                                    }
                                    // registerData()

                                  }
                                }),
                            SizedBox(
                              height: 40,
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row _buildDateAndAge(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextFiledWidget(
            backColor: ThemeClass.whiteDarkColor,
            // radius: 20,
            oniconTap: () {
              _selectDate(context);
            },
            hinttext: "Date of Birth",
            controllers: _dateofbirthController,
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
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 1,
          child: TextBoxSimpleWidget(
            isReadOnly: true,
            radius: 30,
            isCenter: true,
            hinttext: "age",
            controllers: _ageController,
            validator: (value) {
              if (value!.isEmpty) {
                return GlobalVariableForShowMessage.EmptyErrorMessage + "age";
              }
            },
          ),
        ),
      ],
    );
  }

  Row _buildHeightWidth() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildTextTitle("Height"),
              Padding(
                padding: const EdgeInsets.only(right: 7),
                child: TextBoxSimpleWidget(
                  hinttext: "Height",
                  isNumber: true,
                  controllers: _heightController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return GlobalVariableForShowMessage.EmptyErrorMessage +
                          "Height";
                    }
                    return null;
                  },
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: _buildTextTitle("Weight")),
              Padding(
                padding: const EdgeInsets.only(left: 7),
                child: TextBoxSimpleWidget(
                  hinttext: "Weight",
                  controllers: _weightController,
                  isNumber: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return GlobalVariableForShowMessage.EmptyErrorMessage +
                          "Weight";
                    }
                    return null;
                  },
                ),
              ),
            ],
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

  Center _buildCircleImage() {
    return Center(
      child: Stack(
        children: [
          SizedBox(
            height: 150,
            width: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(400.0),
              child: ImagePAth != null
                  ? Image.file(
                      File(
                        ImagePAth!.path,
                      ),
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      img!.toString(),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Positioned(
            top: 7,
            right: 7,
            child: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: InkWell(
                onTap: () {
                  _showPicker(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: ThemeClass.blueColor, shape: BoxShape.circle),
                  height: 30,
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 15,
                  ),
                  width: 30,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Padding _buildTextTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5, top: 15, left: 15),
      child: Text(
        title,
        style: TextStyle(fontSize: 10, color: ThemeClass.greyDarkColor),
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Photo Library'),
                      onTap: () {
                        takeImage(ImageSource.gallery);

                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Camera'),
                    onTap: () {
                      takeImage(ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  String dateTOSend = "";

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(1950),
      lastDate: currentDate,
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
    );
    if (pickedDate != null && pickedDate != currentDate) {
      // setState(() {
      //   String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);

      //   _dateofbirthController.text = formattedDate;
      // });

      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
      var days = DateTime.now().difference(pickedDate).inDays;
      var age = days ~/ 360;

      setState(() {
        _dateofbirthController.text = formattedDate;
        _ageController.text = age.toString();
      });
    }
  }

  final ImagePicker _picker = ImagePicker();
  takeImage(ImageSource imagesource) async {
    var pickedImage = await _picker.pickImage(source: imagesource);
    if (pickedImage != null) {
      _cropImage(pickedImage);
    }
  }

  Future<Null> _cropImage(XFile? file) async {
    File? croppedFile = await ImageCropper().cropImage(
        sourcePath: file!.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',

            // toolbarColor: Colors.deepOrange,

            activeControlsWidgetColor: Colors.green,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      setState(() {
        ImagePAth = croppedFile;
      });
    }
  }
}
