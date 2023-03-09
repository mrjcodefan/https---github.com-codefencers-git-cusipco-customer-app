import 'package:flutter/material.dart';
import 'package:heal_u/screens/main_screen/home/Diet/diet_grid_screen.dart';
import 'package:heal_u/screens/main_screen/home/Food/model/my_subscription_model.dart';
import 'package:heal_u/screens/main_screen/my_account/my_subscription/my_subscription_sevice.dart';
import 'package:heal_u/themedata.dart';

import 'package:heal_u/widgets/bottom_sheets/bottom_sheet_for_select_address_widget.dart';
import 'package:heal_u/widgets/bottom_sheets/bottom_sheet_select_meal_type_widget.dart';
import 'package:heal_u/widgets/button_widget/rounded_button_widget.dart';
import 'package:heal_u/widgets/general_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class BottomSheetSelectDaysWidget extends StatefulWidget {
  BottomSheetSelectDaysWidget(
      {Key? key,
      required this.restID,
      required this.dietID,
      required this.callback})
      : super(key: key);
  final String restID;
  final String dietID;
  final Function callback;
  @override
  State<BottomSheetSelectDaysWidget> createState() =>
      _BottomSheetSelectDaysWidgetState();
}

class _BottomSheetSelectDaysWidgetState
    extends State<BottomSheetSelectDaysWidget> {
  List<String> daysArray = [
    "7",
    "14",
    "28",
  ];
  @override
  Widget build(BuildContext context) {
    return Consumer<MySubscriptionService>(
        builder: (context, mySubscription, child) {
      return Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTitle(context),
            ...daysArray.map((e) => _buildCard(e)).toList(),
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

  String groupVal = "";

  Column _buildCard(
    String value,
  ) {
    return Column(children: [
      InkWell(
        onTap: () {
          setState(() {
            groupVal = value.toString();
          });

          // showAlertDialog(context, plans![index].id.toString());
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Radio(
                  value: value.toString(),
                  activeColor: ThemeClass.blueColor,
                  fillColor: MaterialStateProperty.all(ThemeClass.blueColor),
                  groupValue: groupVal,
                  onChanged: (value) {
                    setState(() {
                      groupVal = value.toString();
                    });
                  },
                ),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${value} days",
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
                "Select Days",
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
    print(groupVal);

    if (groupVal == "") {
      showToast("Please Select Day.");
    } else {
      Navigator.pop(context);

      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return BottomSheetSelectMealTypeWidget(
              callback: widget.callback,
              restID: widget.restID,
              dietID: widget.dietID,
              days: groupVal,
            );
          });
    }
  }
}
