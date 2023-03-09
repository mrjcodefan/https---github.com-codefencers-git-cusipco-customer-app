import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:heal_u/Global/global_variable_for_show_messge.dart';
import 'package:heal_u/screens/main_screen/cart/cart_prowider_service.dart';
import 'package:heal_u/Global/web_view_screen.dart';
import 'package:heal_u/screens/main_screen/checkout/checkout_for_other.dart';
import 'package:heal_u/screens/main_screen/home/Diet/model/diet_plan_model.dart';
import 'package:heal_u/screens/main_screen/home/Food/active_plans_and_subscription_screen.dart';
import 'package:heal_u/screens/main_screen/my_account/family_members/service/family_prowider_service.dart';
import 'package:heal_u/service/http_service/http_service.dart';
import 'package:heal_u/service/navigation_service.dart';
import 'package:heal_u/service/shared_pref_service/user_pref_service.dart';
import 'package:heal_u/themedata.dart';
import 'package:heal_u/widgets/app_bars/appbar_with_text.dart';
import 'package:heal_u/widgets/expanable_widget.dart';
import 'package:heal_u/widgets/general_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class SelectDietPlanScreen extends StatefulWidget {
  SelectDietPlanScreen({Key? key, this.title, this.dietid, required this.data})
      : super(key: key);
  final String? title;
  final String? dietid;
  final Map<String, String> data;
  @override
  State<SelectDietPlanScreen> createState() => _SelectDietPlanScreenState();
}

class _SelectDietPlanScreenState extends State<SelectDietPlanScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<List<DietPlan>?> getDietPlan() async {
    try {
      Map<String, String> queryParameters = {"search": ""};

      var response = await HttpService.httpPost("diet_plans", queryParameters,
          context: context);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = json.decode(response.body);
        DietPlanListModel data = DietPlanListModel.fromJson(body);

        if (data.status == "200" && data.success == "1") {
          return data.data;
        } else {
          throw "internal server error";
        }
      } else if (response.statusCode == 401) {
        showToast(GlobalVariableForShowMessage.unauthorizedUser);
        await UserPrefService().removeUserData();
        NavigationService().navigatWhenUnautorized();
      } else {
        throw "internal server error";
      }
    } catch (e) {
      if (e is SocketException) {
        debugPrint("socket exception screen :------ $e");

        throw "Socket exception";
      } else if (e is TimeoutException) {
        debugPrint("time out exp :------ $e");

        throw "Time out exception";
      } else {
        debugPrint("attraction details screen:------ $e");

        throw e.toString();
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
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(65.0),
              child: AppBarWithTextAndBackWidget(
                onbackPress: () {
                  Navigator.pop(context);
                },
                title: widget.title == null
                    ? "Select Diet Plan"
                    : widget.title.toString(),
                isShowCart: true,
              )),
          body: Container(
            color: ThemeClass.whiteColor,
            height: height,
            width: width,
            child: FutureBuilder(
                future: getDietPlan(),
                builder: (context, AsyncSnapshot<List<DietPlan>?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      if (snapshot.data != null) {
                        return _buildView(snapshot.data);
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
                      child: CircularProgressIndicator(
                          color: ThemeClass.blueColor),
                    );
                  }
                }),
          ),
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

  SingleChildScrollView _buildView(List<DietPlan>? data) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...data!
                .map((e) => Column(
                      children: [
                        ExpandableListView(
                            data: e,
                            isExpanded: widget.dietid == e.id,
                            onSelect: (value) {
                              _bookDiet(value);
                            }),
                        SizedBox(height: 20),
                      ],
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }

  _bookDiet(DietPlan value) async {
    Map<String, String> queryParameters = widget.data;
    Map<String, String> tempdata1 = {
      "diat_plan_id": value.id.toString(),
    };

    queryParameters.addAll(tempdata1);
    double _price = double.parse(value.price.toString());

    double _tax = _price * 18 / 100;
    double _payamount = _price + _tax;

    var res = await pushNewScreen(
      context,
      screen: CheckoutForOtherScreen(
        moduleView: 3,
        dietPlan: value,
        chanrges: value.price.toString(),
        payableAmount: _payamount.toString(),
        module: "Customized",
        tax: _tax.toString(),
        queryParameters: queryParameters,
      ),
      withNavBar: false,
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
    );

    if (res != null && res == true) {
      Navigator.pop(context);
      Navigator.pop(context);
      pushNewScreen(
        context,
        screen: ActivePlansAndSubscritionScreen(),
        withNavBar: true,
        pageTransitionAnimation: PageTransitionAnimation.cupertino,
      );
    }

    //   try {
    //     String memberid = "";
    //     var familyPro = Provider.of<FamilyMemberService>(context, listen: false);
    //     if (familyPro.isSelectFamilyMember) {
    //       memberid = familyPro.currentFamilyMember!.id.toString();
    //     }
    //     Map<String, String> queryParameters = widget.data;
    //     Map<String, String> tempdata1 = {
    //       "diat_plan_id": value,
    //     };

    //     queryParameters.addAll(tempdata1);

    //     var response = await HttpService.httpPost(
    //         "purchase_diet_plan", queryParameters,
    //         context: context);

    //     if (response.statusCode == 201 || response.statusCode == 200) {
    //       var res = jsonDecode(response.body);

    //       if (res['success'].toString() == "1" &&
    //           res['status'].toString() == "200") {
    //         // showToast(res['message']);
    //         EasyLoading.dismiss();
    //         var res2 = await Navigator.of(context, rootNavigator: true).push(
    //           MaterialPageRoute<bool>(
    //             builder: (BuildContext context) =>
    //                 WebViewScreen(url: res['data']['payment_url'].toString()),
    //           ),
    //         );

    //         if (res2 == true) {
    //           showToast("Payment Successfully Done.");
    //           var provider1 =
    //               Provider.of<CardProviderService>(context, listen: false);
    //           await provider1.getCart();
    //           Navigator.pop(context);
    //           Navigator.pop(context);
    //           pushNewScreen(
    //             context,
    //             screen: ActivePlansAndSubscritionScreen(),
    //             withNavBar: true,
    //             pageTransitionAnimation: PageTransitionAnimation.cupertino,
    //           );
    //         } else {
    //           showToast("Payment Not Done.");
    //         }
    //       } else {
    //         showToast(res['message']);
    //         Navigator.pop(context);
    //       }
    //     } else if (response.statusCode == 401) {
    //       showToast(GlobalVariableForShowMessage.unauthorizedUser);
    //       await UserPrefService().removeUserData();
    //       NavigationService().navigatWhenUnautorized();
    //     } else {
    //       showToast(GlobalVariableForShowMessage.somethingwentwongMessage);
    //     }
    //   } catch (e) {
    //     if (e is SocketException) {
    //       showToast(GlobalVariableForShowMessage.socketExceptionMessage);
    //     } else if (e is TimeoutException) {
    //       showToast(GlobalVariableForShowMessage.timeoutExceptionMessage);
    //     } else {
    //       showToast(e.toString());
    //     }
    //   } finally {
    //     EasyLoading.dismiss();
    //   }
  }
}
