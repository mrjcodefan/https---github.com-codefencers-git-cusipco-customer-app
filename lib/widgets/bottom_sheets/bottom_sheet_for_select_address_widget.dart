import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:heal_u/Global/global_variable_for_show_messge.dart';
import 'package:heal_u/service/http_service/http_service.dart';
import 'package:heal_u/service/prowider/get_address_provider.dart';
import 'package:heal_u/themedata.dart';
import 'package:heal_u/widgets/address_bottom_sheet_list_tile_widget.dart';
import 'package:heal_u/widgets/alert_dialog_subscription_under_review_widget.dart';
import 'package:heal_u/widgets/button_widget/rounded_button_widget.dart';
import 'package:heal_u/widgets/general_widget.dart';
import 'package:provider/provider.dart';

class BottomSheetSelectAddressWidget extends StatefulWidget {
  BottomSheetSelectAddressWidget(
      {Key? key,
      required this.dietID,
      required this.callback,
      required this.restID,
      required this.breakfast,
      required this.launch,
      required this.dinner,
      required this.days})
      : super(key: key);
  final String dietID;
  final String restID;
  final String days;
  final Function callback;
  final String breakfast;
  final String launch;
  final String dinner;

  @override
  State<BottomSheetSelectAddressWidget> createState() =>
      _BottomSheetSelectAddressWidgetState();
}

class _BottomSheetSelectAddressWidgetState
    extends State<BottomSheetSelectAddressWidget> {
  bool isLoading = false;
  var dayNameAndValue = [
    {"title": "Monday", "value": ""},
    {"title": "Tuesday", "value": ""},
    {"title": "Wednesday", "value": ""},
    {"title": "Thursday", "value": ""},
    {"title": "Friday", "value": ""},
    {"title": "Saturday", "value": ""},
    {"title": "Sunday", "value": ""},
  ];

  _setValue(value) async {
    var daynm = value[0].toString();
    var dayvalue = value[1].toString();

    var list = dayNameAndValue.where((element) {
      if (element["title"] == daynm) {
        element["value"] = dayvalue;
        return true;
      }
      return true;
    });
    setState(() {
      dayNameAndValue = list.toList();
    });

    print(dayNameAndValue);
  }

  @override
  void initState() {
    super.initState();
    Provider.of<GetAddressService>(context, listen: false).getAddressData();
  }

  bool _isError = false;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.75,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTitle(context),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ...dayNameAndValue
                      .map(
                        (e) => AddressBottomSheetListTileWidget(
                          title: e['title'].toString(),
                          callBack: (value) {
                            print(value);
                            _setValue(value);
                          },
                        ),
                      )
                      .toList(),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: ButtonWidget(
              title: "Confirm",
              isLoading: isLoading,
              color: ThemeClass.blueColor,
              callBack: () {
                print(dayNameAndValue);

                for (var data in dayNameAndValue) {
                  if (data['value'] == "") {
                    setState(() {
                      _isError = true;
                    });
                    showToast("please select ${data['title']}");

                    break;
                  } else {
                    setState(() {
                      _isError = false;
                    });
                  }
                }

                if (!_isError) {
                  _subscribeRestaurant();
                }
              },
            ),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  _subscribeRestaurant() async {
    try {
      setState(() {
        isLoading = true;
      });

      var url = "subscribe-restaurant";

      Map<String, String> data = {
        'restaurant_id': widget.restID,
        'diet_plan_id': widget.dietID,
        // 'meal_type': widget.mealType,
        'breakfast': widget.breakfast,
        'lunch': widget.launch,
        'dinner': widget.dinner,
        'days': widget.days,
      };
      dayNameAndValue.forEach((element) {
        data.addAll({
          element['title'].toString().toLowerCase():
              element['value'].toString().toLowerCase()
        });
      });

      print(data);

      print("data to send ---------------------------> $data");
      var response = await HttpService.httpPost("subscribe-restaurant", data,
          context: context);

      if (response.statusCode == 201 || response.statusCode == 200) {
        var res = jsonDecode(response.body);

        if (res['success'].toString() == "1" &&
            res['status'].toString() == "200") {
          widget.callback();
          Navigator.pop(context, true);

          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return AlertDialogSubcsriptionUnderReview(
                title: "Your subscription is under review",
              );
            },
          );
        } else if (res['status'].toString() == "202") {
          showToast(res['message']);
        } else {
          showToast(res['message']);
        }
      } else if (response.statusCode == 500) {
        showToast(GlobalVariableForShowMessage.internalservererror);
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

  Column _buildTitle(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Select Delivery Addresses",
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
                icon: Icon(Icons.close),
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
}
