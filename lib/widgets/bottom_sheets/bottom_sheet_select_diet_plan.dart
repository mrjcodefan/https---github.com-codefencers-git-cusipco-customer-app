import 'package:flutter/material.dart';
import 'package:heal_u/screens/main_screen/home/Diet/diet_grid_screen.dart';
import 'package:heal_u/screens/main_screen/home/Food/model/my_subscription_model.dart';
import 'package:heal_u/screens/main_screen/my_account/my_subscription/my_subscription_sevice.dart';
import 'package:heal_u/themedata.dart';

import 'package:heal_u/widgets/bottom_sheets/bottom_sheet_for_select_address_widget.dart';
import 'package:heal_u/widgets/bottom_sheets/bottom_sheet_select_days_widget.dart';
import 'package:heal_u/widgets/button_widget/rounded_button_widget.dart';
import 'package:heal_u/widgets/general_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class BottomSheetSelectDietPlan extends StatefulWidget {
  BottomSheetSelectDietPlan(
      {Key? key,
      required this.prevContext,
      required this.restID,
      required this.callback})
      : super(key: key);
  final String restID;
  BuildContext prevContext;
  final Function callback;
  @override
  State<BottomSheetSelectDietPlan> createState() =>
      _BottomSheetSelectDietPlanState();
}

class _BottomSheetSelectDietPlanState extends State<BottomSheetSelectDietPlan> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MySubscriptionService>(
        builder: (context, mySubscription, child) {
      return Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTitle(context),
            mySubscription.dietPlans!.length == 0
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 50, horizontal: 70),
                    child: Column(
                      children: [
                        Text(
                          "Currently you haven't purchese any diet plan",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        _buildAddPlanButton(context),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Add New Plan",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    height: MediaQuery.of(context).size.height / 2,
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                              itemCount: mySubscription.dietPlans!.length + 1,
                              itemBuilder: (context, index) {
                                if (index == mySubscription.dietPlans!.length) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Column(
                                      children: [
                                        _buildAddPlanButton(context),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Add New Plan",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return _buildCard(
                                      index, mySubscription.dietPlans);
                                }
                              }),
                        ),
                      ],
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ButtonWidget(
                  title: "Next",
                  color: ThemeClass.blueColor,
                  callBack: () {
                    if (groupVal == "") {
                      showToast("Please select diet plan");
                    } else {
                      showAlertDialog(
                          context,
                          mySubscription.dietPlans![int.parse(groupVal)].id
                              .toString());
                    }

                    // Navigator.pop(context);
                    // pushNewScreen(
                    //   widget.prevContext,
                    //   screen: DietGridScreen(),
                    //   withNavBar: true,
                    //   pageTransitionAnimation:
                    //       PageTransitionAnimation.cupertino,
                    // );
                  }),
            )
          ],
        ),
      );
    });
  }

  InkWell _buildAddPlanButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        pushNewScreen(
          widget.prevContext,
          screen: DietGridScreen(),
          withNavBar: true,
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
      },
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: ThemeClass.blueColor, width: 2),
        ),
        child: Center(
          child: Icon(
            Icons.add_rounded,
            size: 40,
            color: ThemeClass.blueColor,
          ),
        ),
      ),
    );
  }

  String groupVal = "";

  Column _buildCard(int index, List<MySubscriptionDataDietPlan>? plans) {
    return Column(children: [
      InkWell(
        onTap: () {
          setState(() {
            groupVal = index.toString();
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
                  value: index.toString(),
                  activeColor: ThemeClass.blueColor,
                  fillColor: MaterialStateProperty.all(ThemeClass.blueColor),
                  groupValue: groupVal,
                  onChanged: (value) {
                    setState(() {
                      groupVal = value.toString();
                      // showAlertDialog(context, plans![index].id.toString());
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
                      plans![index].title.toString(),
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "₹${plans[index].price.toString()}",
                      style: TextStyle(
                          color: ThemeClass.blueColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: Container(
                    height: 40,
                    width: 40,
                    margin: EdgeInsets.only(right: 25),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      image: DecorationImage(
                        image: NetworkImage(plans[index].image.toString()),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
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
                "Select Your Diet Plan",
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

  showAlertDialog(BuildContext context1, String planId) async {
    print(planId);
    Navigator.pop(context);
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return BottomSheetSelectDaysWidget(
            callback: widget.callback,
            restID: widget.restID,
            dietID: planId,
          );
        });
  }
}
