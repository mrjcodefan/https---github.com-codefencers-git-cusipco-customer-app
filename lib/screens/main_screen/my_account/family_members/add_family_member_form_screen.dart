import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:heal_u/Global/global_variable_for_show_messge.dart';
import 'package:heal_u/screens/main_screen/my_account/family_members/service/family_prowider_service.dart';
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

class AddFamilyMemberFormScreen extends StatefulWidget {
  AddFamilyMemberFormScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AddFamilyMemberFormScreen> createState() =>
      _AddFamilyMemberFormScreenState();
}

class _AddFamilyMemberFormScreenState extends State<AddFamilyMemberFormScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  String _activityValue = "";
  bool _isExpanded = false;
  _setActivity(String val) {
    setState(() {
      _isExpanded = false;
      _activityValue = val;
    });
  }

  File? ImagePAth;
  DateTime currentDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(1947),
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
        lastDate: DateTime.now());
    if (pickedDate != null && pickedDate != currentDate) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);

      var days = DateTime.now().difference(pickedDate).inDays;

      var age = days ~/ 360;

      setState(() {
        _dateofbirthController.text = formattedDate;
        _ageController.text = age.toString();
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  _insertFamilyMember() async {
    if (ImagePAth == null) {
      try {
        EasyLoading.show();
        Map<String, String> queryParameters = {
          "name": _firstnameController.text,
          "relation": _memberrelationController.text,
          "dob": _dateofbirthController.text,
          "email": _emailController.text,
          "phone_number": _phoneController.text,
          "height": _heightController.text,
          "weight": _weightController.text,
          "activity": _activityValue
          // "profile_image": ImagePAth!.path.toString(),
        };

        var response = await HttpService.httpPost(
            "save_member", queryParameters,
            context: context);

        if (response.statusCode == 201 || response.statusCode == 200) {
          var res = jsonDecode(response.body);

          if (res['success'].toString() == "1" &&
              res['status'].toString() == "200") {
            showToast(res['message']);
            var data =
                await Provider.of<FamilyMemberService>(context, listen: false)
                    .getFamilyMemberList(context: context);
            Navigator.pop(context);
          } else {
            showToast(res['message']);
            // Navigator.pop(context);
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
        EasyLoading.dismiss();
      }
    } else {
      try {
        EasyLoading.show();
        Map<String, String> queryParameters = {
          "name": _firstnameController.text,
          "relation": _memberrelationController.text,
          "dob": _dateofbirthController.text,
          "email": _emailController.text,
          "phone_number": _phoneController.text,
          "height": _heightController.text,
          "weight": _weightController.text,
          "activity": _activityValue
          // "profile_image": ImagePAth!.path.toString(),
        };

        var response = await HttpService.httpPostWithImageUpload(
            "save_member", ImagePAth, queryParameters,
            peramterName: "profile_image");

        if (response.statusCode == 201 || response.statusCode == 200) {
          var res = jsonDecode(response.body);

          if (res['success'].toString() == "1" &&
              res['status'].toString() == "200") {
            showToast(res['message']);
            var data =
                await Provider.of<FamilyMemberService>(context, listen: false)
                    .getFamilyMemberList(context: context);
            Navigator.pop(context);
          } else {
            showToast(res['message']);
            // Navigator.pop(context);
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
        EasyLoading.dismiss();
      }
    }
  }

  final _formKey = GlobalKey<FormState>();
  bool isFirstSubmit = true;
  TextEditingController _firstnameController = TextEditingController();

  TextEditingController _memberrelationController = TextEditingController();
  TextEditingController _dateofbirthController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _locationController = TextEditingController();

  List _religianList = [
    "Father",
    "Mother",
    "Brother",
    "Sister",
    "Son",
    "Daughter",
    "Wife",
    "Husband",
    "Uncle",
    "Aunty"
  ];

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
                title: "Family Member",
              )),
          body: Container(
            color: ThemeClass.whiteColor,
            height: height,
            width: width,
            child: Stack(
              children: [
                SingleChildScrollView(
                  controller: _scrollController,
                  physics: BouncingScrollPhysics(),
                  reverse: true,
                  // ignore: prefer_const_literals_to_create_immutables
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 25, left: 25, right: 25),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: !isFirstSubmit
                          ? AutovalidateMode.always
                          : AutovalidateMode.disabled,
                      child: Column(
                        // ignore: prefer_const_literals_to_create_immutables
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildCircleImage(),
                          _buildFirstLastName(),
                          _buildTextTitle("Member Relation"),
                          TextFiledWidget(
                            onTap: () {
                              _selectMemberDialog(context);
                            },
                            backColor: ThemeClass.whiteDarkColor,
                            radius: 10,
                            hinttext: "Member Relation",
                            controllers: _memberrelationController,
                            isReadOnly: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return GlobalVariableForShowMessage
                                        .EmptyErrorMessage +
                                    "Member Relation";
                              }
                            },
                            oniconTap: () {
                              _selectMemberDialog(context);
                            },
                            icon: "assets/images/down_arrow1.png",
                          ),
                          _buildTextTitle("Date of Birth"),
                          _buildDateAndAge(context),
                          _buildTextTitle("Email Address"),
                          TextFiledWidget(
                            backColor: ThemeClass.whiteDarkColor,
                            hinttext: "Email",
                            controllers: _emailController,
                            icon: "assets/images/email_icon.png",
                            validator: (value) {
                              if (value!.isEmpty) {
                                return GlobalVariableForShowMessage
                                        .EmptyErrorMessage +
                                    "Email";
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
                            isNumber: true,
                            controllers: _phoneController,
                            icon: "assets/images/telephone_icon.png",
                            validator: (value) {
                              if (value!.isEmpty) {
                                return GlobalVariableForShowMessage
                                        .EmptyErrorMessage +
                                    "Phone Number";
                              } else if (value.length < 10) {
                                return GlobalVariableForShowMessage
                                    .phoneNumberinvalied;
                              }
                            },
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          _buildTextTitle("Select Activity"),
                          SelectActivityDropdownWidget(
                            expandcallBack: (val) => _expandCall(val),
                            currentValue: _activityValue,
                            callBack: (val) => _setActivity(val),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          _buildHeightWidth(),
                          SizedBox(
                            height: 100,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                _buildBottomButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  _expandCall(bool value) {
    print("-------------------------$value");

    if (value == true) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    } else {
      _scrollController
          .jumpTo(_scrollController.position.maxScrollExtent - 350);
    }
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
                  isNumber: true,
                  controllers: _weightController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return GlobalVariableForShowMessage.EmptyErrorMessage +
                          "Weight";
                    }
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Row _buildDateAndAge(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextFiledWidget(
            backColor: ThemeClass.whiteDarkColor,
            radius: 10,
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
            radius: 10,
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

  Center _buildCircleImage() {
    return Center(
      child: Stack(
        children: [
          Container(
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
                      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__480.png",
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

  Row _buildFirstLastName() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildTextTitle("Name"),
              Padding(
                padding: const EdgeInsets.only(right: 7),
                child: TextBoxSimpleWidget(
                  radius: 10,
                  hinttext: "Name",
                  controllers: _firstnameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return GlobalVariableForShowMessage.EmptyErrorMessage +
                          "Name";
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ],
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

  Align _buildBottomButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 15),
        height: 80,
        child: ButtonWidget(
          title: "Add Member",
          color: ThemeClass.blueColor,
          callBack: () {
            setState(() {
              isFirstSubmit = false;
            });
            if (_formKey.currentState!.validate()) {
              if (_activityValue != "") {
                _insertFamilyMember();
              } else {
                showToast("Please select activity");
              }
            }
            // Navigator.pop(context);
          },
        ),
      ),
    );
  }

  _selectMemberDialog(BuildContext context1) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width - 100,
                height: MediaQuery.of(context).size.height / 2,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ..._religianList
                          .map(
                            (e) => ListTile(
                              onTap: () {
                                _selectReligian(e, context);
                              },
                              title: Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text(e),
                              ),
                            ),
                          )
                          .toList()
                    ],
                  ),
                )),
          ),
        );
      },
    );
  }

  _selectReligian(String value, BuildContext tmpcnt) {
    setState(() {
      _memberrelationController.text = value;
    });
    Navigator.of(tmpcnt).pop();
  }

  final ImagePicker _picker = ImagePicker();
  takeImage(ImageSource imagesource) async {
    var pickedImage = await _picker.pickImage(source: imagesource);
    if (pickedImage != null) {
      _cropImage(pickedImage);
    }
  }

  Future _cropImage(XFile? file) async {
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
}
