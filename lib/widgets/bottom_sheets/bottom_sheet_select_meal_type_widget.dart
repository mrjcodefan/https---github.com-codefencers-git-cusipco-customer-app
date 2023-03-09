import 'package:flutter/material.dart';

import 'package:heal_u/screens/main_screen/my_account/my_subscription/my_subscription_sevice.dart';
import 'package:heal_u/themedata.dart';

import 'package:heal_u/widgets/bottom_sheets/bottom_sheet_for_select_address_widget.dart';
import 'package:heal_u/widgets/button_widget/rounded_button_widget.dart';
import 'package:heal_u/widgets/general_widget.dart';

import 'package:provider/provider.dart';

class BottomSheetSelectMealTypeWidget extends StatefulWidget {
  BottomSheetSelectMealTypeWidget(
      {Key? key,
      required this.restID,
      required this.callback,
      required this.days,
      required this.dietID})
      : super(key: key);
  final String restID;
  final String dietID;
  final String days;
  final Function callback;

  @override
  State<BottomSheetSelectMealTypeWidget> createState() =>
      _BottomSheetSelectMealTypeWidgetState();
}

class _BottomSheetSelectMealTypeWidgetState
    extends State<BottomSheetSelectMealTypeWidget> {
  List<Map<String, String>> _mealArray = [
    {"title": "Breakfast", "value": "false"},
    {"title": "Lunch", "value": "false"},
    {"title": "Dinner", "value": "false"},
  ];

  bool breakfast = false;
  bool lunch = false;
  bool dinner = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<MySubscriptionService>(
        builder: (context, mySubscription, child) {
      return Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTitle(context),
            // ..._mealArray.map((e) => _buildCard(e)).toList(),

            _buildCard("Breakfast", breakfast, () {
              setState(() {
                breakfast = !breakfast;
              });
            }),
            _buildCard("Lunch", lunch, () {
              setState(() {
                lunch = !lunch;
              });
            }),
            _buildCard("Dinner", dinner, () {
              setState(() {
                dinner = !dinner;
              });
            }),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ButtonWidget(
                  title: "Next",
                  color: ThemeClass.blueColor,
                  callBack: () {
                    showAlertDialog();
                  }),
            )
          ],
        ),
      );
    });
  }

  Column _buildCard(title, value, callback) {
    // int index = _mealArray.indexOf(value);
    return Column(children: [
      InkWell(
        onTap: () {
          // setState(() {
          //   groupVal = value.toString();
          // });

          // showAlertDialog(context, plans![index].id.toString());
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Checkbox(
                activeColor: ThemeClass.blueColor,
                checkColor: ThemeClass.whiteColor,
                side: BorderSide(
                  color: ThemeClass.blueColor,
                ),
                value: value,
                onChanged: (bool? value) {
                  // setState(() {
                  //   _mealArray[index]['value'] = value! ? "true" : "false";
                  // });
                  callback();
                },
              ),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Divider(
          height: 1,
          thickness: 1,
          color: ThemeClass.greyLightColor1,
        ),
      )
    ]);
  }

  Column _buildTitle(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Select Meal Type",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close,
                  color: ThemeClass.blueColor,
                ),
              )
            ],
          ),
        ),
        Divider(
          thickness: 1,
          color: ThemeClass.greyLightColor1,
        ),
      ],
    );
  }

  showAlertDialog() async {
    // show the dialog
    // showDialog(
    //   barrierDismissible: false,
    //   context: context,
    //   builder: (BuildContext context) {
    //     return AlertDialogSubcsriptionUnderReview();
    //   },
    // );

    // showModalBottomSheet(
    //     context: context,
    //     isScrollControlled: true,
    //     // useRootNavigator: true,
    //     builder: (context) {
    //       return BottomSheetSelectAddressWidget(
    //         restID: widget.restID,
    //         dietID: planId,
    //       );
    //     });

    // var res = _mealArray
    //     .where((element) => element['value'] == "true" ? true : false)
    //     .toList();

    if (lunch == false && dinner == false && breakfast == false) {
      showToast("Please Select Meal Type.");
    } else {
      print("breakfast =${breakfast == true ? 'Yes' : 'No'}");
      print("lunch =${lunch == true ? 'Yes' : 'No'}");
      print("dinner =${dinner == true ? 'Yes' : 'No'}");
      Navigator.pop(context);

      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return BottomSheetSelectAddressWidget(
                callback: widget.callback,
                restID: widget.restID,
                dietID: widget.dietID,
                days: widget.days,
                breakfast: breakfast == true ? 'Yes' : 'No',
                launch: lunch == true ? 'Yes' : 'No',
                dinner: dinner == true ? 'Yes' : 'No');
          });
    }
  }
}
