import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:heal_u/Global/global_enum_class.dart';
import 'package:heal_u/Global/global_variable_for_show_messge.dart';
import 'package:heal_u/screens/main_screen/cart/cart_prowider_service.dart';
import 'package:heal_u/Global/web_view_screen.dart';
import 'package:heal_u/screens/main_screen/checkout/checkout_for_other.dart';
import 'package:heal_u/screens/main_screen/home/Diet/model/diet_plan_model.dart';
import 'package:heal_u/screens/main_screen/home/Diet/select_diet_plan_screen.dart';
import 'package:heal_u/screens/main_screen/home/Food/active_plans_and_subscription_screen.dart';
import 'package:heal_u/screens/main_screen/my_account/my_appointment/appointments_screen.dart';
import 'package:heal_u/screens/main_screen/my_account/family_members/service/family_prowider_service.dart';
import 'package:heal_u/service/http_service/http_service.dart';
import 'package:heal_u/service/navigation_service.dart';
import 'package:heal_u/service/prowider/general_information_service.dart';
import 'package:heal_u/service/shared_pref_service/user_pref_service.dart';
import 'package:heal_u/themedata.dart';
import 'package:heal_u/widgets/alert_dialog_subscription_under_review_widget.dart';
import 'package:heal_u/widgets/app_bars/appbar_with_text.dart';
import 'package:heal_u/widgets/bottom_sheets/bottom_sheet_for_my_account_widget.dart';

import 'package:heal_u/widgets/button_widget/rounded_button_widget.dart';
import 'package:heal_u/widgets/general_button.dart';
import 'package:heal_u/widgets/general_widget.dart';
import 'package:heal_u/widgets/text_boxes/text_box_normal.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class CustomizedDietPlanScreen extends StatefulWidget {
  CustomizedDietPlanScreen({Key? key, this.title, required this.type})
      : super(key: key);

  final String? title;
  final String type;

  @override
  State<CustomizedDietPlanScreen> createState() =>
      _CustomizedDietPlanScreenState();
}

class _CustomizedDietPlanScreenState extends State<CustomizedDietPlanScreen> {
  bool _isLoading = false;

//!  variables for  addiction
  bool? additionHistoryAlcohol = false;

  bool? additionHistoryCigarettes = false;
  bool? additionHistoryNone = false;
  bool? additionHistoryOther = false;
  bool? additionHistoryTobacco = false;
  bool? anycomoAsthma = false;
  bool? anycomoBloodPressure = false;
  bool? anycomoDiabetes = false;
//!  variables for  anycomorbidilities
  bool? anycomoNone = false;

  bool? anycomoOther = false;
  bool? anycomoPCOS = false;
  bool? anycomoThyroid = false;
  bool isFirstSubmit = true;
  bool isLoading = false;
  //!  variables for  meat specify
  bool? meatSpecifyChicken = false;

  bool? meatSpecifyCrab = false;
  bool? meatSpecifyEgg = false;
  bool? meatSpecifyFish = false;
  bool? meatSpecifyMutton = false;
  bool? meatSpecifyOther = false;
  bool? meatSpecifyPrawn = false;
  bool? vegDaysAll = false;
  bool? vegDaysFriday = false;
  //!  variables for   vegDays
  bool? vegDaysMonday = false;

  bool? vegDaysSaturday = false;
  bool? vegDaysSunday = false;
  bool? vegDaysThursday = false;
  bool? vegDaysTuesday = false;
  bool? vegDaysWednesday = false;

  final TextEditingController _ageController = TextEditingController();
  var _dietApiGroupValue = "";
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _familyHistoryController =
      TextEditingController();

  final TextEditingController _foodAllergiesController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();
  var _futureDietPlan;
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _preferedDateController = TextEditingController();
  final TextEditingController _preferedTimeController = TextEditingController();
  final TextEditingController _preferedTimeControllerTodisplay =
      TextEditingController();

  final TextEditingController _presentHeightController =
      TextEditingController();

  final TextEditingController _presentWeightController =
      TextEditingController();

  final TextEditingController _quesionController = TextEditingController();
  enumDietrequired _radioDietrequired = enumDietrequired.SportsDiet;
  // all enum for radio button

  enumForMF _radioMF = enumForMF.Male;

  enumPhysicalActivity _radioPhysicalActivity = enumPhysicalActivity.Sedentary;
  enumSurgeryHistory _radioSurgeryHistory = enumSurgeryHistory.Yes;
  enumVegetarian _radioVegetarian = enumVegetarian.Yes;
  enumCommuncationMode _radiocommunicationMode = enumCommuncationMode.English;
  final TextEditingController _targetWeightController = TextEditingController();
  final TextEditingController _waistController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<String> getFormateTime(TimeOfDay? pickedTime) async {
    var temphr;
    var temptime;

    if (pickedTime!.hour < 10) {
      temphr = "0${pickedTime.hour}";
    } else {
      temphr = "${pickedTime.hour}";
    }
    if (pickedTime.minute < 10) {
      temptime = "0${pickedTime.minute}";
    } else {
      temptime = "${pickedTime.minute}";
    }
    return "$temphr:$temptime";
  }

  Future<void> _selectPrefedDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
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
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != DateTime.now()) {
      setState(() {
        print("after date");
        String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);

        _preferedDateController.text = formattedDate;
      });
    }
  }

  Future<void> _selectPrefedTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, child) {
        return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: Theme(
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
            ));
      },
    );
    if (pickedTime != null && pickedTime != TimeOfDay.now()) {
      var timeee = await getFormateTime(pickedTime);
      final localizations = MaterialLocalizations.of(context);
      final formattedTimeOfDay = localizations.formatTimeOfDay(pickedTime);
      setState(() {
        _preferedTimeController.text = timeee;
        _preferedTimeControllerTodisplay.text = formattedTimeOfDay.toString();
      });
    }
  }

  _addDiet() async {
    FocusScope.of(context).requestFocus(FocusNode());

    String _physicalValue = "";

    if (_radioPhysicalActivity.name == "SlightlyActive") {
      _physicalValue = "Slightly Active";
    } else if (_radioPhysicalActivity.name == "ModeratelyActive") {
      _physicalValue = "Moderately Active";
    } else if (_radioPhysicalActivity.name == "Highly Active") {
      _physicalValue = "Highly Active";
    } else {
      _physicalValue = _radioPhysicalActivity.name;
    }

    // any comorbidities

    var _comorbiditiesValue = "";

    if (anycomoNone == true) {
      _comorbiditiesValue += "None,";
    }

    if (anycomoPCOS == true) {
      _comorbiditiesValue += "PCOS,";
    }
    if (anycomoThyroid == true) {
      _comorbiditiesValue += "Thyroid,";
    }
    if (anycomoDiabetes == true) {
      _comorbiditiesValue += "Diabetes,";
    }
    if (anycomoBloodPressure == true) {
      _comorbiditiesValue += "Blood Pressure,";
    }
    if (anycomoAsthma == true) {
      _comorbiditiesValue += "Asthma,";
    }
    if (anycomoOther == true) {
      _comorbiditiesValue += "Other";
    }

    // additional history

    String _additionHistoryValue = "";

    if (additionHistoryAlcohol == true) {
      _additionHistoryValue += "Alcohol,";
    }
    if (additionHistoryCigarettes == true) {
      _additionHistoryValue += "Cigarettes,";
    }
    if (additionHistoryTobacco == true) {
      _additionHistoryValue += "Tobacco,";
    }
    if (additionHistoryNone == true) {
      _additionHistoryValue += "None,";
    }
    if (additionHistoryOther == true) {
      _additionHistoryValue += "Other";
    }

    var _meatspecficValue = "";

    if (meatSpecifyChicken == true) {
      _meatspecficValue += "Chicken,";
    }
    if (meatSpecifyEgg == true) {
      _meatspecficValue += "Egg,";
    }
    if (meatSpecifyMutton == true) {
      _meatspecficValue += "Mutton,";
    }
    if (meatSpecifyFish == true) {
      _meatspecficValue += "Fish,";
    }
    if (meatSpecifyPrawn == true) {
      _meatspecficValue += "Prawn,";
    }
    if (meatSpecifyCrab == true) {
      _meatspecficValue += "Crab,";
    }
    if (meatSpecifyOther == true) {
      _meatspecficValue += "Other,";
    }

    //  veg days

    var _VegDayValue = "";

    if (vegDaysMonday == true) {
      _VegDayValue += "Monday,";
    }
    if (vegDaysTuesday == true) {
      _VegDayValue += "Tuesday,";
    }

    if (vegDaysWednesday == true) {
      _VegDayValue += "Wednesday,";
    }

    if (vegDaysThursday == true) {
      _VegDayValue += "Thursday,";
    }

    if (vegDaysFriday == true) {
      _VegDayValue += "Friday,";
    }

    if (vegDaysSaturday == true) {
      _VegDayValue += "Saturday,";
    }
    if (vegDaysSunday == true) {
      _VegDayValue += "Sunday,";
    }
    if (vegDaysAll == true) {
      _VegDayValue += "All";
    }

    Map<String, String> queryParameters = {
      // "diat_plan_id": _dietApiGroupValue.toString(),
      "diat_plan_type": widget.type.toString(),
      "name": _nameController.text.toString(),
      "age": _ageController.text.toString(),
      "gender": _radioMF.name.toString() == "PreferNotToSay"
          ? ""
          : _radioMF.name.toString(),
      "occupation": _occupationController.text.toString(),
      "mobile_number": _mobileController.text.toString(),
      "email": _emailController.text.toString(),
      "language": _radiocommunicationMode.name.toString() == "LanguageNoBarrier"
          ? ""
          : _radiocommunicationMode.name.toString(),
      "discuss_date": _preferedDateController.text.toString(),
      "discuss_time": _preferedTimeController.text.toString(),
      "weight": _presentWeightController.text.toString(),
      "height": _presentHeightController.text.toString(),
      "waist": _waistController.text.toString(),
      "target_weight": _targetWeightController.text.toString(),
      "physical_activity": _physicalValue.toString(),
      "comorbidities": _comorbiditiesValue.toString(),
      "past_history_of_surgery": _radioSurgeryHistory.name.toString(),
      "family_history_of_diseases": _familyHistoryController.text.toString(),
      "adddiction_history": _additionHistoryValue.toString(),
      "completely_vegetarian": _radioVegetarian.name.toString(),
      "meats_specific": _meatspecficValue.toString(),
      "veg_days": _VegDayValue.toString(),
      "food_allergies": _foodAllergiesController.text.toString(),
      "queries": _quesionController.text.toString(),
    };

    // print(queryParameters);

    if (widget.type == "Unconfirmed") {
      var _pro = Provider.of<GeneralInfoService>(context, listen: false);

      var charges = _pro.getConsultaionChages();
      var tax = _pro.getConsultaionChagesTax();
      var _payamount = _pro.getConsultaionChagesPayableAmount();
      var res = await pushNewScreen(
        context,
        screen: CheckoutForOtherScreen(
          moduleView: 3,
          tax: tax.toString(),
          dietPlan: DietPlan(title: "Ask to Nutritionist"),
          chanrges: charges,
          payableAmount: _payamount.toString(),
          module: widget.type,
          queryParameters: queryParameters,
        ),
        withNavBar: false,
        pageTransitionAnimation: PageTransitionAnimation.cupertino,
      );

      if (res != null && res == true) {
        Navigator.pop(context);

        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialogSubcsriptionUnderReview(
              title: "Submitted Successfully!!",
            );
          },
        );
      }
    } else {
      Navigator.pop(context);
      pushNewScreen(
        context,
        screen: SelectDietPlanScreen(
            dietid: _dietApiGroupValue, data: queryParameters),
        withNavBar: true,
        pageTransitionAnimation: PageTransitionAnimation.cupertino,
      );
    }
  }

  _bookDiet(value, Map<String, String> queryParame, String type) async {
    EasyLoading.show();

    try {
      String memberid = "";
      var familyPro = Provider.of<FamilyMemberService>(context, listen: false);
      if (familyPro.isSelectFamilyMember) {
        memberid = familyPro.currentFamilyMember!.id.toString();
      }
      Map<String, String> queryParameters = queryParame;
      Map<String, String> tempdata1 = {
        "diat_plan_id": value,
      };

      queryParameters.addAll(tempdata1);

      var response = await HttpService.httpPost(
          "purchase_diet_plan", queryParameters,
          context: context);

      if (response.statusCode == 201 || response.statusCode == 200) {
        var res = jsonDecode(response.body);

        if (res['success'].toString() == "1" &&
            res['status'].toString() == "200") {
          EasyLoading.dismiss();
          var res2 = await Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute<bool>(
              builder: (BuildContext context) =>
                  WebViewScreen(url: res['data']['payment_url'].toString()),
            ),
          );

          if (res2 == true) {
            showToast("Payment Successfully Done.");
            var provider1 =
                Provider.of<CardProviderService>(context, listen: false);
            await provider1.getCart();

            if (type == "Standard") {
              Navigator.pop(context);
              pushNewScreen(
                context,
                screen: ActivePlansAndSubscritionScreen(),
                withNavBar: true,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            } else if (type == "Unconfirmed") {
              Navigator.pop(context);

              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return AlertDialogSubcsriptionUnderReview(
                    title: "Submitted Successfully!!",
                  );
                },
              );
            } else {
              Navigator.pop(context);
              Navigator.pop(context);
            }
          } else {
            showToast("Payment Not Done.");
          }
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
      EasyLoading.dismiss();
    }
  }

  Column _buildconsultChanges() {
    return Column(
      children: [
        SizedBox(
          height: 18,
        ),
        Consumer<GeneralInfoService>(
            builder: (context, generalInfoService, child) {
          return Center(
            child: Text(
              "Consultation Charges: ₹${generalInfoService.getConsultaionChages()}",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: ThemeClass.blueColor,
                  fontSize: 20),
            ),
          );
        }),
      ],
    );
  }

  Container _buildVegDays() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          color: ThemeClass.whiteDarkColor),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Checkbox(
                  activeColor: ThemeClass.blueColor,
                  checkColor: ThemeClass.whiteColor,
                  side: BorderSide(
                    color: ThemeClass.blueColor,
                  ),
                  value: vegDaysMonday,
                  onChanged: (bool? value) {
                    setState(() {
                      vegDaysMonday = value;
                      if (vegDaysSunday == true &&
                          vegDaysMonday == true &&
                          vegDaysTuesday == true &&
                          vegDaysWednesday == true &&
                          vegDaysThursday == true &&
                          vegDaysFriday == true &&
                          vegDaysSaturday == true) {
                        vegDaysAll = true;
                      } else {
                        vegDaysAll = false;
                      }
                    });
                  },
                ),
                Text(
                  'Monday',
                  style: TextStyle(
                      color: ThemeClass.greyDarkColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Checkbox(
                  activeColor: ThemeClass.blueColor,
                  checkColor: ThemeClass.whiteColor,
                  side: BorderSide(
                    color: ThemeClass.blueColor,
                  ),
                  value: vegDaysTuesday,
                  onChanged: (bool? value) {
                    setState(() {
                      vegDaysTuesday = value;
                      if (vegDaysSunday == true &&
                          vegDaysMonday == true &&
                          vegDaysTuesday == true &&
                          vegDaysWednesday == true &&
                          vegDaysThursday == true &&
                          vegDaysFriday == true &&
                          vegDaysSaturday == true) {
                        vegDaysAll = true;
                      } else {
                        vegDaysAll = false;
                      }
                    });
                  },
                ),
                Text(
                  'Tuesday',
                  style: TextStyle(
                      color: ThemeClass.greyDarkColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Checkbox(
                  activeColor: ThemeClass.blueColor,
                  checkColor: ThemeClass.whiteColor,
                  side: BorderSide(
                    color: ThemeClass.blueColor,
                  ),
                  value: vegDaysWednesday,
                  onChanged: (bool? value) {
                    setState(() {
                      vegDaysWednesday = value;
                      if (vegDaysSunday == true &&
                          vegDaysMonday == true &&
                          vegDaysTuesday == true &&
                          vegDaysWednesday == true &&
                          vegDaysThursday == true &&
                          vegDaysFriday == true &&
                          vegDaysSaturday == true) {
                        vegDaysAll = true;
                      } else {
                        vegDaysAll = false;
                      }
                    });
                  },
                ),
                Text(
                  'Wednesday',
                  style: TextStyle(
                      color: ThemeClass.greyDarkColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Checkbox(
                  activeColor: ThemeClass.blueColor,
                  checkColor: ThemeClass.whiteColor,
                  side: BorderSide(
                    color: ThemeClass.blueColor,
                  ),
                  value: vegDaysThursday,
                  onChanged: (bool? value) {
                    setState(() {
                      vegDaysThursday = value;
                      if (vegDaysSunday == true &&
                          vegDaysMonday == true &&
                          vegDaysTuesday == true &&
                          vegDaysWednesday == true &&
                          vegDaysThursday == true &&
                          vegDaysFriday == true &&
                          vegDaysSaturday == true) {
                        vegDaysAll = true;
                      } else {
                        vegDaysAll = false;
                      }
                    });
                  },
                ),
                Text(
                  'Thursday',
                  style: TextStyle(
                      color: ThemeClass.greyDarkColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Checkbox(
                  activeColor: ThemeClass.blueColor,
                  checkColor: ThemeClass.whiteColor,
                  side: BorderSide(
                    color: ThemeClass.blueColor,
                  ),
                  value: vegDaysFriday,
                  onChanged: (bool? value) {
                    setState(() {
                      vegDaysFriday = value;
                      if (vegDaysSunday == true &&
                          vegDaysMonday == true &&
                          vegDaysTuesday == true &&
                          vegDaysWednesday == true &&
                          vegDaysThursday == true &&
                          vegDaysFriday == true &&
                          vegDaysSaturday == true) {
                        vegDaysAll = true;
                      } else {
                        vegDaysAll = false;
                      }
                    });
                  },
                ),
                Text(
                  'Friday',
                  style: TextStyle(
                      color: ThemeClass.greyDarkColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Checkbox(
                  activeColor: ThemeClass.blueColor,
                  checkColor: ThemeClass.whiteColor,
                  side: BorderSide(
                    color: ThemeClass.blueColor,
                  ),
                  value: vegDaysSaturday,
                  onChanged: (bool? value) {
                    setState(() {
                      vegDaysSaturday = value;
                      if (vegDaysSunday == true &&
                          vegDaysMonday == true &&
                          vegDaysTuesday == true &&
                          vegDaysWednesday == true &&
                          vegDaysThursday == true &&
                          vegDaysFriday == true &&
                          vegDaysSaturday == true) {
                        vegDaysAll = true;
                      } else {
                        vegDaysAll = false;
                      }
                    });
                  },
                ),
                Text(
                  'Saturday',
                  style: TextStyle(
                      color: ThemeClass.greyDarkColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Checkbox(
                  activeColor: ThemeClass.blueColor,
                  checkColor: ThemeClass.whiteColor,
                  side: BorderSide(
                    color: ThemeClass.blueColor,
                  ),
                  value: vegDaysSunday,
                  onChanged: (bool? value) {
                    setState(() {
                      vegDaysSunday = value;

                      if (vegDaysSunday == true &&
                          vegDaysMonday == true &&
                          vegDaysTuesday == true &&
                          vegDaysWednesday == true &&
                          vegDaysThursday == true &&
                          vegDaysFriday == true &&
                          vegDaysSaturday == true) {
                        vegDaysAll = true;
                      } else {
                        vegDaysAll = false;
                      }
                    });
                  },
                ),
                Text(
                  'Sunday',
                  style: TextStyle(
                      color: ThemeClass.greyDarkColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Checkbox(
                  activeColor: ThemeClass.blueColor,
                  checkColor: ThemeClass.whiteColor,
                  side: BorderSide(
                    color: ThemeClass.blueColor,
                  ),
                  value: vegDaysAll,
                  onChanged: (bool? value) {
                    setState(() {
                      vegDaysMonday = value;
                      vegDaysTuesday = value;
                      vegDaysWednesday = value;
                      vegDaysThursday = value;
                      vegDaysFriday = value;
                      vegDaysSaturday = value;
                      vegDaysSunday = value;

                      vegDaysAll = value;
                    });
                  },
                ),
                Text(
                  'All',
                  style: TextStyle(
                      color: ThemeClass.greyDarkColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: ThemeClass.greyLightColor1,
            )
          ],
        ),
      ),
    );
  }

  Container _buildMeatSpecify() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          color: ThemeClass.whiteDarkColor),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Checkbox(
                  activeColor: ThemeClass.blueColor,
                  checkColor: ThemeClass.whiteColor,
                  side: BorderSide(
                    color: ThemeClass.blueColor,
                  ),
                  value: meatSpecifyChicken,
                  onChanged: (bool? value) {
                    setState(() {
                      meatSpecifyChicken = value;
                    });
                  },
                ),
                Text(
                  'Chicken',
                  style: TextStyle(
                      color: ThemeClass.greyDarkColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Checkbox(
                  activeColor: ThemeClass.blueColor,
                  checkColor: ThemeClass.whiteColor,
                  side: BorderSide(
                    color: ThemeClass.blueColor,
                  ),
                  value: meatSpecifyEgg,
                  onChanged: (bool? value) {
                    setState(() {
                      meatSpecifyEgg = value;
                    });
                  },
                ),
                Text(
                  'Egg',
                  style: TextStyle(
                      color: ThemeClass.greyDarkColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Checkbox(
                  activeColor: ThemeClass.blueColor,
                  checkColor: ThemeClass.whiteColor,
                  side: BorderSide(
                    color: ThemeClass.blueColor,
                  ),
                  value: meatSpecifyMutton,
                  onChanged: (bool? value) {
                    setState(() {
                      meatSpecifyMutton = value;
                    });
                  },
                ),
                Text(
                  'Mutton',
                  style: TextStyle(
                      color: ThemeClass.greyDarkColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Checkbox(
                  activeColor: ThemeClass.blueColor,
                  checkColor: ThemeClass.whiteColor,
                  side: BorderSide(
                    color: ThemeClass.blueColor,
                  ),
                  value: meatSpecifyFish,
                  onChanged: (bool? value) {
                    setState(() {
                      meatSpecifyFish = value;
                    });
                  },
                ),
                Text(
                  'Fish',
                  style: TextStyle(
                      color: ThemeClass.greyDarkColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Checkbox(
                  activeColor: ThemeClass.blueColor,
                  checkColor: ThemeClass.whiteColor,
                  side: BorderSide(
                    color: ThemeClass.blueColor,
                  ),
                  value: meatSpecifyPrawn,
                  onChanged: (bool? value) {
                    setState(() {
                      meatSpecifyPrawn = value;
                    });
                  },
                ),
                Text(
                  'Prawn',
                  style: TextStyle(
                      color: ThemeClass.greyDarkColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Checkbox(
                  activeColor: ThemeClass.blueColor,
                  checkColor: ThemeClass.whiteColor,
                  side: BorderSide(
                    color: ThemeClass.blueColor,
                  ),
                  value: meatSpecifyCrab,
                  onChanged: (bool? value) {
                    setState(() {
                      meatSpecifyCrab = value;
                    });
                  },
                ),
                Text(
                  'Crab',
                  style: TextStyle(
                      color: ThemeClass.greyDarkColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Checkbox(
                  activeColor: ThemeClass.blueColor,
                  checkColor: ThemeClass.whiteColor,
                  side: BorderSide(
                    color: ThemeClass.blueColor,
                  ),
                  value: meatSpecifyOther,
                  onChanged: (bool? value) {
                    setState(() {
                      meatSpecifyOther = value;
                    });
                  },
                ),
                Text(
                  'Other',
                  style: TextStyle(
                      color: ThemeClass.greyDarkColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: ThemeClass.greyLightColor1,
            )
          ],
        ),
      ),
    );
  }

  Container _buildAddictionHistory() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          color: ThemeClass.whiteDarkColor),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Checkbox(
                  activeColor: ThemeClass.blueColor,
                  checkColor: ThemeClass.whiteColor,
                  side: BorderSide(
                    color: ThemeClass.blueColor,
                  ),
                  value: additionHistoryAlcohol,
                  onChanged: (bool? value) {
                    setState(() {
                      additionHistoryAlcohol = value;
                    });
                  },
                ),
                Text(
                  'Alcohol',
                  style: TextStyle(
                      color: ThemeClass.greyDarkColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Checkbox(
                  activeColor: ThemeClass.blueColor,
                  checkColor: ThemeClass.whiteColor,
                  side: BorderSide(
                    color: ThemeClass.blueColor,
                  ),
                  value: additionHistoryCigarettes,
                  onChanged: (bool? value) {
                    setState(() {
                      additionHistoryCigarettes = value;
                    });
                  },
                ),
                Text(
                  'Cigarettes',
                  style: TextStyle(
                      color: ThemeClass.greyDarkColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Checkbox(
                  activeColor: ThemeClass.blueColor,
                  checkColor: ThemeClass.whiteColor,
                  side: BorderSide(
                    color: ThemeClass.blueColor,
                  ),
                  value: additionHistoryTobacco,
                  onChanged: (bool? value) {
                    setState(() {
                      additionHistoryTobacco = value;
                    });
                  },
                ),
                Text(
                  'Tobacco',
                  style: TextStyle(
                      color: ThemeClass.greyDarkColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Checkbox(
                  activeColor: ThemeClass.blueColor,
                  checkColor: ThemeClass.whiteColor,
                  side: BorderSide(
                    color: ThemeClass.blueColor,
                  ),
                  value: additionHistoryNone,
                  onChanged: (bool? value) {
                    setState(() {
                      additionHistoryNone = value;
                    });
                  },
                ),
                Text(
                  'None',
                  style: TextStyle(
                      color: ThemeClass.greyDarkColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Checkbox(
                  activeColor: ThemeClass.blueColor,
                  checkColor: ThemeClass.whiteColor,
                  side: BorderSide(
                    color: ThemeClass.blueColor,
                  ),
                  value: additionHistoryOther,
                  onChanged: (bool? value) {
                    setState(() {
                      additionHistoryOther = value;
                    });
                  },
                ),
                Text(
                  'Other',
                  style: TextStyle(
                      color: ThemeClass.greyDarkColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: ThemeClass.greyLightColor1,
            )
          ],
        ),
      ),
    );
  }

  Container _buildRadioVegetarian() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          color: ThemeClass.whiteDarkColor),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Radio(
                    value: enumVegetarian.Yes,
                    activeColor: ThemeClass.blueColor,
                    fillColor: MaterialStateProperty.all(ThemeClass.blueColor),
                    groupValue: _radioVegetarian,
                    onChanged: (enumVegetarian? value) {
                      setState(() {
                        _radioVegetarian = value!;
                      });
                    },
                  ),
                  Text(
                    'Yes',
                    style: TextStyle(
                        color: ThemeClass.greyDarkColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Radio(
                    value: enumVegetarian.No,
                    activeColor: ThemeClass.blueColor,
                    fillColor: MaterialStateProperty.all(ThemeClass.blueColor),
                    groupValue: _radioVegetarian,
                    onChanged: (enumVegetarian? value) {
                      setState(() {
                        _radioVegetarian = value!;
                      });
                    },
                  ),
                  Text(
                    'No',
                    style: TextStyle(
                        color: ThemeClass.greyDarkColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _buildRadioSurgery() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          color: ThemeClass.whiteDarkColor),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Radio(
                    value: enumSurgeryHistory.Yes,
                    activeColor: ThemeClass.blueColor,
                    fillColor: MaterialStateProperty.all(ThemeClass.blueColor),
                    groupValue: _radioSurgeryHistory,
                    onChanged: (enumSurgeryHistory? value) {
                      setState(() {
                        _radioSurgeryHistory = value!;
                      });
                    },
                  ),
                  Text(
                    'Yes',
                    style: TextStyle(
                        color: ThemeClass.greyDarkColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Radio(
                    value: enumSurgeryHistory.No,
                    activeColor: ThemeClass.blueColor,
                    fillColor: MaterialStateProperty.all(ThemeClass.blueColor),
                    groupValue: _radioSurgeryHistory,
                    onChanged: (enumSurgeryHistory? value) {
                      setState(() {
                        _radioSurgeryHistory = value!;
                      });
                    },
                  ),
                  Text(
                    'No',
                    style: TextStyle(
                        color: ThemeClass.greyDarkColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _buildDataNotFound1(
    String text,
  ) {
    return Container(
        height: 700,
        color: Colors.transparent,
        child: Center(child: Text("$text")));
  }

  _buildDietRequired() {
    return FutureBuilder(
        future: _futureDietPlan,
        builder: (context, AsyncSnapshot<List<DietPlan>?> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              if (snapshot.data != null) {
                if (snapshot.data!.isNotEmpty) {
                  if (_dietApiGroupValue == "") {
                    _dietApiGroupValue = snapshot.data!.first.id.toString();
                  }

                  return Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                        color: ThemeClass.whiteDarkColor),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...snapshot.data!
                              .map(
                                (e) => Row(
                                  children: [
                                    SizedBox(
                                      height: 30,
                                      child: Radio(
                                        value: e.id.toString(),
                                        activeColor: ThemeClass.blueColor,
                                        fillColor: MaterialStateProperty.all(
                                            ThemeClass.blueColor),
                                        groupValue: _dietApiGroupValue,
                                        onChanged: (value) {
                                          setState(() {
                                            _dietApiGroupValue =
                                                value!.toString();
                                          });
                                        },
                                      ),
                                    ),
                                    Text(
                                      e.title.toString(),
                                      style: TextStyle(
                                          color: ThemeClass.greyDarkColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              )
                              .toList()
                        ],
                      ),
                    ),
                  );
                } else {
                  return _buildDataNotFound1("Data Not Found!");
                }
              } else {
                return _buildDataNotFound1("Data Not Found!");
              }
            } else if (snapshot.hasError) {
              // return Center(child: Text(snapshot.error.toString()));
              return _buildDataNotFound1(snapshot.error.toString());
            } else {
              return _buildDataNotFound1("Data Not Found!");
            }
          } else {
            return Center(
              child: CircularProgressIndicator(color: ThemeClass.blueColor),
            );
          }
        });
  }

  Container _buildAnyComorbidities() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          color: ThemeClass.whiteDarkColor),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Checkbox(
                  activeColor: ThemeClass.blueColor,
                  checkColor: ThemeClass.whiteColor,
                  side: BorderSide(
                    color: ThemeClass.blueColor,
                  ),
                  value: anycomoNone,
                  onChanged: (bool? value) {
                    setState(() {
                      anycomoNone = value;
                    });
                  },
                ),
                Text(
                  'None',
                  style: TextStyle(
                      color: ThemeClass.greyDarkColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Checkbox(
                  activeColor: ThemeClass.blueColor,
                  checkColor: ThemeClass.whiteColor,
                  side: BorderSide(
                    color: ThemeClass.blueColor,
                  ),
                  value: anycomoPCOS,
                  onChanged: (bool? value) {
                    setState(() {
                      anycomoPCOS = value;
                    });
                  },
                ),
                Text(
                  'PCOS',
                  style: TextStyle(
                      color: ThemeClass.greyDarkColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Checkbox(
                  activeColor: ThemeClass.blueColor,
                  checkColor: ThemeClass.whiteColor,
                  side: BorderSide(
                    color: ThemeClass.blueColor,
                  ),
                  value: anycomoThyroid,
                  onChanged: (bool? value) {
                    setState(() {
                      anycomoThyroid = value;
                    });
                  },
                ),
                Text(
                  'Thyroid',
                  style: TextStyle(
                      color: ThemeClass.greyDarkColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Checkbox(
                  activeColor: ThemeClass.blueColor,
                  checkColor: ThemeClass.whiteColor,
                  side: BorderSide(
                    color: ThemeClass.blueColor,
                  ),
                  value: anycomoDiabetes,
                  onChanged: (bool? value) {
                    setState(() {
                      anycomoDiabetes = value;
                    });
                  },
                ),
                Text(
                  'Diabetes',
                  style: TextStyle(
                      color: ThemeClass.greyDarkColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Checkbox(
                  activeColor: ThemeClass.blueColor,
                  checkColor: ThemeClass.whiteColor,
                  side: BorderSide(
                    color: ThemeClass.blueColor,
                  ),
                  value: anycomoBloodPressure,
                  onChanged: (bool? value) {
                    setState(() {
                      anycomoBloodPressure = value;
                    });
                  },
                ),
                Text(
                  'Blood Pressure',
                  style: TextStyle(
                      color: ThemeClass.greyDarkColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Checkbox(
                  activeColor: ThemeClass.blueColor,
                  checkColor: ThemeClass.whiteColor,
                  side: BorderSide(
                    color: ThemeClass.blueColor,
                  ),
                  value: anycomoAsthma,
                  onChanged: (bool? value) {
                    setState(() {
                      anycomoAsthma = value;
                    });
                  },
                ),
                Text(
                  'Asthma',
                  style: TextStyle(
                      color: ThemeClass.greyDarkColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Checkbox(
                  activeColor: ThemeClass.blueColor,
                  checkColor: ThemeClass.whiteColor,
                  side: BorderSide(
                    color: ThemeClass.blueColor,
                  ),
                  value: anycomoOther,
                  onChanged: (bool? value) {
                    setState(() {
                      anycomoOther = value;
                    });
                  },
                ),
                Text(
                  'Other',
                  style: TextStyle(
                      color: ThemeClass.greyDarkColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: ThemeClass.greyLightColor1,
            )
          ],
        ),
      ),
    );
  }

  Container _buildCommunicationMode() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          color: ThemeClass.whiteDarkColor),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  height: 30,
                  child: Radio(
                    value: enumCommuncationMode.English,
                    activeColor: ThemeClass.blueColor,
                    fillColor: MaterialStateProperty.all(ThemeClass.blueColor),
                    groupValue: _radiocommunicationMode,
                    onChanged: (enumCommuncationMode? value) {
                      setState(() {
                        _radiocommunicationMode = value!;
                      });
                    },
                  ),
                ),
                Text(
                  'English',
                  style: TextStyle(
                      color: ThemeClass.greyDarkColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  height: 30,
                  child: Radio(
                    value: enumCommuncationMode.Hindi,
                    activeColor: ThemeClass.blueColor,
                    fillColor: MaterialStateProperty.all(ThemeClass.blueColor),
                    groupValue: _radiocommunicationMode,
                    onChanged: (enumCommuncationMode? value) {
                      setState(() {
                        _radiocommunicationMode = value!;
                      });
                    },
                  ),
                ),
                Text(
                  'Hindi',
                  style: TextStyle(
                      color: ThemeClass.greyDarkColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  height: 30,
                  child: Radio(
                    value: enumCommuncationMode.Odia,
                    activeColor: ThemeClass.blueColor,
                    fillColor: MaterialStateProperty.all(ThemeClass.blueColor),
                    groupValue: _radiocommunicationMode,
                    onChanged: (enumCommuncationMode? value) {
                      setState(() {
                        _radiocommunicationMode = value!;
                      });
                    },
                  ),
                ),
                Text(
                  'Odia',
                  style: TextStyle(
                      color: ThemeClass.greyDarkColor,
                      overflow: TextOverflow.ellipsis,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  height: 30,
                  child: Radio(
                    value: enumCommuncationMode.LanguageNoBarrier,
                    activeColor: ThemeClass.blueColor,
                    fillColor: MaterialStateProperty.all(ThemeClass.blueColor),
                    groupValue: _radiocommunicationMode,
                    onChanged: (enumCommuncationMode? value) {
                      setState(() {
                        _radiocommunicationMode = value!;
                      });
                    },
                  ),
                ),
                Text(
                  'Language no barrier',
                  style: TextStyle(
                      color: ThemeClass.greyDarkColor,
                      overflow: TextOverflow.ellipsis,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Container _buildPhysicalActivity() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          color: ThemeClass.whiteDarkColor),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  child: Radio(
                    value: enumPhysicalActivity.Sedentary,
                    activeColor: ThemeClass.blueColor,
                    fillColor: MaterialStateProperty.all(ThemeClass.blueColor),
                    groupValue: _radioPhysicalActivity,
                    onChanged: (enumPhysicalActivity? value) {
                      setState(() {
                        _radioPhysicalActivity = value!;
                      });
                    },
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Sedentary',
                        style: TextStyle(
                            color: ThemeClass.greyDarkColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        '( No physical activity, < 5000 steps/day)',
                        style: TextStyle(
                            color: ThemeClass.greyDarkColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  child: Radio(
                    value: enumPhysicalActivity.SlightlyActive,
                    activeColor: ThemeClass.blueColor,
                    fillColor: MaterialStateProperty.all(ThemeClass.blueColor),
                    groupValue: _radioPhysicalActivity,
                    onChanged: (enumPhysicalActivity? value) {
                      setState(() {
                        _radioPhysicalActivity = value!;
                      });
                    },
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Slightly Active',
                        style: TextStyle(
                            color: ThemeClass.greyDarkColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        '(5000-7500 steps/day, light exercise or sports 2-3 days/week)',
                        style: TextStyle(
                            color: ThemeClass.greyDarkColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  child: Radio(
                    value: enumPhysicalActivity.ModeratelyActive,
                    activeColor: ThemeClass.blueColor,
                    fillColor: MaterialStateProperty.all(ThemeClass.blueColor),
                    groupValue: _radioPhysicalActivity,
                    onChanged: (enumPhysicalActivity? value) {
                      setState(() {
                        _radioPhysicalActivity = value!;
                      });
                    },
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Moderately Active',
                        style: TextStyle(
                            color: ThemeClass.greyDarkColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        '( >7500 steps/day, light exercise or sports 4-6 days/week)',
                        style: TextStyle(
                            color: ThemeClass.greyDarkColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  child: Radio(
                    value: enumPhysicalActivity.HighlyActive,
                    activeColor: ThemeClass.blueColor,
                    fillColor: MaterialStateProperty.all(ThemeClass.blueColor),
                    groupValue: _radioPhysicalActivity,
                    onChanged: (enumPhysicalActivity? value) {
                      setState(() {
                        _radioPhysicalActivity = value!;
                      });
                    },
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Highly Active',
                        style: TextStyle(
                            color: ThemeClass.greyDarkColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        '( >10k steps/day, Intense exercise like weight training 4-5days/week)',
                        style: TextStyle(
                            color: ThemeClass.greyDarkColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Padding _buildtitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 2),
      child: Text(
        title,
        style: TextStyle(
            color: ThemeClass.blueColor,
            fontSize: 14,
            fontWeight: FontWeight.w500),
      ),
    );
  }

  Padding _buildtitle16(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 2),
      child: Text(
        title,
        style: TextStyle(
            color: ThemeClass.blueColor,
            fontSize: 16,
            fontWeight: FontWeight.w500),
      ),
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
        Text(
          'Male',
          style: TextStyle(
              color: ThemeClass.greyDarkColor,
              fontSize: 12,
              fontWeight: FontWeight.w400),
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
        Text(
          'Female',
          style: TextStyle(
              color: ThemeClass.greyDarkColor,
              fontSize: 12,
              fontWeight: FontWeight.w400),
        ),
        Radio(
          value: enumForMF.PreferNotToSay,
          activeColor: ThemeClass.blueColor,
          fillColor: MaterialStateProperty.all(ThemeClass.blueColor),
          groupValue: _radioMF,
          onChanged: (enumForMF? value) {
            setState(() {
              _radioMF = value!;
            });
          },
        ),
        Text(
          'Prefer not to say',
          style: TextStyle(
              color: ThemeClass.greyDarkColor,
              overflow: TextOverflow.ellipsis,
              fontSize: 12,
              fontWeight: FontWeight.w400),
        )
      ],
    );
  }

  _buildCard() {
    return Consumer<FamilyMemberService>(
        builder: (context, familyprowider, child) {
      return Consumer<UserPrefService>(builder: (context, navProwider, child) {
        return Column(children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              radius: 28,
              backgroundImage: NetworkImage(familyprowider.isSelectFamilyMember
                  ? familyprowider.currentFamilyMember!.profileImage.toString()
                  : navProwider.globleUserModel!.data!.profileImage.toString()),
            ),
            title: Text(
              familyprowider.isSelectFamilyMember
                  ? familyprowider.currentFamilyMember!.name.toString()
                  : navProwider.globleUserModel!.data!.name ?? "",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              familyprowider.isSelectFamilyMember
                  ? familyprowider.currentFamilyMember!.phoneNumber.toString()
                  : navProwider.globleUserModel!.data!.phoneNumber ?? "",
              style: TextStyle(
                  color: ThemeClass.blueColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w400),
            ),
            trailing: InkWell(
              onTap: () {},
              child: TextButtonWidget(
                onPressed: () {
                  _showSelectMemberBottomSheet();
                },
                child: Image.asset(
                  "assets/images/setting_icon.png",
                  height: 40,
                ),
              ),
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: ThemeClass.greyLightColor1,
          )
        ]);
      });
    });
  }

  _showSelectMemberBottomSheet() {
    showModalBottomSheet(
        context: context,
        useRootNavigator: true,
        builder: (context) {
          return BottomSheetForMyAccountWidget();
        });
  }

  String _getAgeFromString(String date) {
    String datePattern = "yyyy-MM-dd";

    DateTime birthDate = DateFormat(datePattern).parse(date);
    DateTime today = DateTime.now();

    int yearDiff = today.year - birthDate.year;

    return yearDiff.toString();
  }

  _loadUserData(familyprowider, user) {
    if (familyprowider.isSelectFamilyMember == true) {
      _nameController.text =
          familyprowider.currentFamilyMember!.name.toString();

      _mobileController.text =
          familyprowider.currentFamilyMember!.phoneNumber.toString();

      _emailController.text =
          familyprowider.currentFamilyMember!.email.toString();

      _ageController.text = familyprowider.currentFamilyMember!.age.toString();

      _presentHeightController.text =
          familyprowider.currentFamilyMember!.height ?? "";
      _presentWeightController.text =
          familyprowider.currentFamilyMember!.weight ?? "";

      if (familyprowider.currentFamilyMember!.activity.toString() ==
          "Sedentary") {
        _radioPhysicalActivity = enumPhysicalActivity.Sedentary;
      } else if (familyprowider.currentFamilyMember!.activity.toString() ==
          "Slightly-Active") {
        _radioPhysicalActivity = enumPhysicalActivity.SlightlyActive;
      } else if (familyprowider.currentFamilyMember!.activity.toString() ==
          "Moderately-Active") {
        _radioPhysicalActivity = enumPhysicalActivity.ModeratelyActive;
      } else if (familyprowider.currentFamilyMember!.activity.toString() ==
          "Highly-Active") {
        _radioPhysicalActivity = enumPhysicalActivity.HighlyActive;
      }
    } else {
      _nameController.text = user.globleUserModel!.data!.name.toString();
      _mobileController.text =
          user.globleUserModel!.data!.phoneNumber.toString();
      _emailController.text = user.globleUserModel!.data!.email.toString();
      _ageController.text =
          _getAgeFromString(user.globleUserModel!.data!.dob.toString());

      _presentHeightController.text = user.globleUserModel!.data!.height ?? "";
      _presentWeightController.text = user.globleUserModel!.data!.weight ?? "";

      if (user.globleUserModel!.data!.activity.toString() == "Sedentary") {
        _radioPhysicalActivity = enumPhysicalActivity.Sedentary;
      } else if (user.globleUserModel!.data!.activity.toString() ==
          "Slightly-Active") {
        _radioPhysicalActivity = enumPhysicalActivity.SlightlyActive;
      } else if (user.globleUserModel!.data!.activity.toString() ==
          "Moderately-Active") {
        _radioPhysicalActivity = enumPhysicalActivity.ModeratelyActive;
      } else if (user.globleUserModel!.data!.activity.toString() ==
          "Highly-Active") {
        _radioPhysicalActivity = enumPhysicalActivity.HighlyActive;
      }
    }
  }

  bool _isinitialVal = true;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    var familyprowider =
        Provider.of<FamilyMemberService>(context, listen: false);
    var user = Provider.of<UserPrefService>(context, listen: false);

    if (_isinitialVal) {
      _isinitialVal = false;
      _loadUserData(familyprowider, user);
    }

    familyprowider.addListener(() {
      _loadUserData(familyprowider, user);
    });

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
                title: widget.title.toString(),
                isShowCart: true,
              )),
          body: Container(
            color: ThemeClass.whiteColor,
            height: height,
            width: width,
            child: Stack(
              children: [
                SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  // ignore: prefer_const_literals_to_create_immutables
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 20, right: 20),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: !isFirstSubmit
                          ? AutovalidateMode.always
                          : AutovalidateMode.disabled,
                      child: Column(
                          // ignore: prefer_const_literals_to_create_immutables
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildCard(),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Do fill this form with utmost care and honesty, as the information provided will later be used by us for making a tailored diet plan for you.",
                              style: TextStyle(
                                  color: ThemeClass.greyDarkColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            _buildtitle("Name"),
                            TextBoxSimpleWidget(
                              radius: 10,
                              hinttext: "Name",
                              controllers: _nameController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return GlobalVariableForShowMessage
                                          .EmptyErrorMessage +
                                      "Name";
                                }
                              },
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            _buildtitle("Age"),
                            TextBoxSimpleWidget(
                              radius: 10,
                              hinttext: "Age",
                              controllers: _ageController,
                              isNumber: true,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return GlobalVariableForShowMessage
                                          .EmptyErrorMessage +
                                      "Age";
                                }
                              },
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            _buildtitle("Gender"),
                            _buildRadioButton(),
                            SizedBox(
                              height: 15,
                            ),
                            _buildtitle("Occupation"),
                            TextBoxSimpleWidget(
                              radius: 10,
                              hinttext: "Occupation",
                              controllers: _occupationController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return GlobalVariableForShowMessage
                                          .EmptyErrorMessage +
                                      "Occupation";
                                }
                              },
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            _buildtitle("Mobile Number"),
                            TextBoxSimpleWidget(
                              radius: 10,
                              isNumber: true,
                              hinttext: "Mobile Number",
                              controllers: _mobileController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return GlobalVariableForShowMessage
                                          .EmptyErrorMessage +
                                      "Mobile Number";
                                } else if (value.length < 10) {
                                  return GlobalVariableForShowMessage
                                      .phoneNumberinvalied;
                                }
                              },
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            _buildtitle("Email Id"),
                            TextBoxSimpleWidget(
                              radius: 10,
                              hinttext: "Email Id",
                              controllers: _emailController,
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
                            SizedBox(
                              height: 15,
                            ),
                            _buildtitle("Mode of communication"),
                            _buildCommunicationMode(),
                            SizedBox(
                              height: 15,
                            ),
                            _buildtitle(
                                "Preferred Date to discuss your diet with us"),
                            TextBoxSimpleWidget(
                              ontap: () {
                                _selectPrefedDate(context);
                              },
                              isReadOnly: true,
                              radius: 10,
                              hinttext: "Example: January 7, 2019",
                              controllers: _preferedDateController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return GlobalVariableForShowMessage
                                          .EmptyErrorMessage +
                                      "Date";
                                }
                              },
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            _buildtitle(
                                "Preferred time to discuss your diet with us"),
                            TextBoxSimpleWidget(
                              isReadOnly: true,
                              ontap: () async {
                                _selectPrefedTime(context);
                              },
                              radius: 10,
                              hinttext: "Example: 8:30 AM",
                              controllers: _preferedTimeControllerTodisplay,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return GlobalVariableForShowMessage
                                          .EmptyErrorMessage +
                                      "Date";
                                }
                              },
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            _buildtitle16("Health Parameters"),
                            Divider(),
                            // Padding(
                            //   padding:
                            //       const EdgeInsets.only(left: 10, bottom: 2),
                            //   child: Text(
                            //     "Do fill this form with utmost care and honesty, as the information provided here will later be used by the dietician for diagnosing and then recommending a suitable diet to the client.",
                            //     style: TextStyle(
                            //         color: ThemeClass.greyDarkColor,
                            //         fontSize: 12,
                            //         fontWeight: FontWeight.w400),
                            //   ),
                            // ),
                            SizedBox(
                              height: 15,
                            ),
                            _buildtitle("Present Weight (in kgs)"),
                            TextBoxSimpleWidget(
                              radius: 10,
                              hinttext: "Present Weight",
                              controllers: _presentWeightController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return GlobalVariableForShowMessage
                                          .EmptyErrorMessage +
                                      "Weight";
                                }
                              },
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            _buildtitle("Present Height (in cms)"),
                            TextBoxSimpleWidget(
                              radius: 10,
                              hinttext: "Present Height",
                              controllers: _presentHeightController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return GlobalVariableForShowMessage
                                          .EmptyErrorMessage +
                                      "Height";
                                }
                              },
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            _buildtitle("Waist circumference (inches)"),
                            TextBoxSimpleWidget(
                              radius: 10,
                              hinttext: "Waist circumference",
                              controllers: _waistController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return GlobalVariableForShowMessage
                                          .EmptyErrorMessage +
                                      "Waist circumference";
                                }
                              },
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            _buildtitle("Target Weight (Optional)"),
                            TextBoxSimpleWidget(
                              radius: 10,
                              hinttext: "Target Weight",
                              controllers: _targetWeightController,
                              validator: (value) {},
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            _buildtitle("Physical Activity"),
                            _buildPhysicalActivity(),
                            SizedBox(
                              height: 15,
                            ),
                            _buildtitle("Any comorbidities"),
                            _buildAnyComorbidities(),
                            SizedBox(
                              height: 15,
                            ),
                            _buildtitle("Any past history of surgery"),
                            _buildRadioSurgery(),
                            SizedBox(
                              height: 15,
                            ),
                            _buildtitle("Any family history of diseases"),
                            TextBoxSimpleWidget(
                              radius: 10,
                              hinttext: "history of diseases",
                              controllers: _familyHistoryController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return GlobalVariableForShowMessage
                                          .EmptyErrorMessage +
                                      "history of diseases";
                                }
                              },
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            _buildtitle("Addiction history"),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, bottom: 2),
                              child: Text(
                                "Please mention it for the doctor to make your diet chart accordingly.",
                                style: TextStyle(
                                    color: ThemeClass.greyDarkColor,
                                    fontSize: 10),
                              ),
                            ),
                            _buildAddictionHistory(),
                            SizedBox(
                              height: 15,
                            ),

                            _buildtitle("Are you completely vegetarian ?"),
                            _buildRadioVegetarian(),
                            SizedBox(
                              height: 15,
                            ),
                            _buildtitle("Meats Specific (Skip if vegetarian)"),
                            _buildMeatSpecify(),
                            SizedBox(
                              height: 15,
                            ),
                            _buildtitle("Veg Days (Select All if vegetarian)"),
                            _buildVegDays(),
                            SizedBox(
                              height: 15,
                            ),
                            _buildtitle("Food Allergies (If any)"),
                            TextBoxSimpleWidget(
                              radius: 10,
                              hinttext: "Food Allergies",
                              controllers: _foodAllergiesController,
                              validator: (value) {},
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            _buildtitle("If Any Queries, Mention"),
                            TextBoxSimpleWidget(
                              radius: 10,
                              hinttext: "Mention Queries",
                              controllers: _quesionController,
                              validator: (value) {},
                            ),
                            widget.title != "Ask to Nutritionist"
                                ? SizedBox()
                                : _buildconsultChanges(),
                            SizedBox(
                              height: 20,
                            ),
                            ButtonWidget(
                                title: widget.type == "Standard"
                                    ? "Submit Details"
                                    : widget.type == "Customized"
                                        ? "Select Plan"
                                        : widget.title.toString(),
                                color: ThemeClass.blueColor,
                                isLoading: _isLoading,
                                callBack: () {
                                  setState(() {
                                    isFirstSubmit = false;
                                  });
                                  if (_formKey.currentState!.validate()) {
                                    _addDiet();
                                  } else {
                                    showToast("Please fill details properly");
                                  }
                                }),
                            SizedBox(
                              height: 50,
                            ),
                          ]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
