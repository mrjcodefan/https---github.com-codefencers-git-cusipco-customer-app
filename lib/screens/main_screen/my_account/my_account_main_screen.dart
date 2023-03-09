import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:heal_u/Global/global_variable_for_show_messge.dart';
import 'package:heal_u/pages/manage_address_screen.dart';

import 'package:heal_u/routes.dart';
import 'package:heal_u/screens/main_screen/home/Food/active_plans_and_subscription_screen.dart';
import 'package:heal_u/screens/main_screen/my_account/my_appointment/appointments_screen.dart';
import 'package:heal_u/screens/main_screen/my_account/family_members/edit_family_member.dart';
import 'package:heal_u/screens/main_screen/my_account/family_members/family_member__list_screen.dart';
import 'package:heal_u/screens/main_screen/my_account/family_members/service/family_prowider_service.dart';

import 'package:heal_u/screens/main_screen/my_account/health_record/health_record_screen.dart';
import 'package:heal_u/screens/main_screen/my_account/my_order_screen.dart';

import 'package:heal_u/screens/main_screen/my_account/profile/my_profile_screen.dart';
import 'package:heal_u/screens/main_screen/my_account/my_recommendations_screen.dart';
import 'package:heal_u/screens/main_screen/my_account/referrals/refer_and_earn_screen.dart';
import 'package:heal_u/screens/main_screen/my_account/wallet/wallet_screen.dart';
import 'package:heal_u/service/http_service/http_service.dart';
import 'package:heal_u/service/navigation_service.dart';
import 'package:heal_u/service/prowider/main_navigaton_prowider_service.dart';
import 'package:heal_u/service/shared_pref_service/user_pref_service.dart';
import 'package:heal_u/themedata.dart';
import 'package:heal_u/widgets/app_bars/appbar_with_text.dart';
import 'package:heal_u/widgets/bottom_sheets/bottom_sheet_for_my_account_widget.dart';
import 'package:heal_u/widgets/general_button.dart';

import 'package:heal_u/widgets/general_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class MyAccountMainScreen extends StatefulWidget {
  const MyAccountMainScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MyAccountMainScreen> createState() => _MyAccountMainScreenState();
}

class _MyAccountMainScreenState extends State<MyAccountMainScreen> {
  List<MyaccountListModel> manuList = [];

  _logout() async {
    var value = await showAlertDialog(context);
    print(value);
    if (value == true) {
      EasyLoading.show();

      try {
        var response = await HttpService.httpGet("logout");
        var res = jsonDecode(response.body);
        if (response.statusCode == 201 || response.statusCode == 200) {
          if (res['success'].toString() == "1" &&
              res['status'].toString() == "200") {
            await UserPrefService().removeUserData();
            showToast(GlobalVariableForShowMessage.logoutSuccess);
            _navigate();
          } else {
            showToast(GlobalVariableForShowMessage.somethingwentwongMessage);
          }
        } else if (response.statusCode == 401) {
          showToast(GlobalVariableForShowMessage.unauthorizedUser);
          await UserPrefService().removeUserData();
          _navigate();
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

  @override
  void initState() {
    super.initState();
    manuList = [
      MyaccountListModel(
          icon: "assets/images/recommandation.png",
          title: "My Recommendations",
          trailing: "",
          onPress: (context) {
            pushNewScreen(
              context,
              screen: MyRecommendationScreen(),
              withNavBar: true,
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          },
          isShowItrailing: false),
      MyaccountListModel(
          icon: "assets/images/smily.png",
          title: "Family Members",
          trailing: "",
          onPress: (context) {
            pushNewScreen(
              context,
              screen: FamilyMemberListScreen(),
              withNavBar: false,
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          },
          isShowItrailing: false),
      MyaccountListModel(
          icon: "assets/images/location_icon.png",
          title: "Manage Address",
          trailing: "",
          onPress: (context) {
            pushNewScreen(
              context,
              screen: ManageAddressScreen(),
              withNavBar: false,
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          },
          isShowItrailing: false),
      MyaccountListModel(
          icon: "assets/images/order_book.png",
          title: "Order Book",
          trailing: "",
          onPress: (context) {
            pushNewScreen(
              context,
              screen: MyOrderScreen(),
              withNavBar: true,
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          },
          isShowItrailing: false),
      MyaccountListModel(
          icon: "assets/images/calender_simple.png",
          title: "My Appointments",
          trailing: "",
          onPress: (context) {
            pushNewScreen(
              context,
              screen: AppointmentsScreen(),
              withNavBar: true,
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          },
          isShowItrailing: false),
      MyaccountListModel(
          icon: "assets/images/user_done.png",
          title: "Active Plans & Subscriptions",
          trailing: "",
          onPress: (context) {
            pushNewScreen(
              context,
              screen: ActivePlansAndSubscritionScreen(),
              withNavBar: true,
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          },
          isShowItrailing: false),
      MyaccountListModel(
          icon: "assets/images/user_plus.png",
          title: "Referrals",
          trailing: "",
          onPress: (context) {
            pushNewScreen(
              context,
              screen: ReferAndEarnScreen(),
              withNavBar: true,
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          },
          isShowItrailing: false),
      MyaccountListModel(
          icon: "assets/images/wallet.png",
          title: "Wallet",
          trailing: "",
          onPress: (context) {
            pushNewScreen(
              context,
              screen: WalletScreen(),
              withNavBar: true,
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          },
          isShowItrailing: false),
      MyaccountListModel(
          icon: "assets/images/records.png",
          title: "Health Records",
          trailing: "",
          onPress: (context) {
            pushNewScreen(
              context,
              screen: HealthRecordScreen(),
              withNavBar: true,
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          },
          isShowItrailing: false),
      MyaccountListModel(
          icon: "assets/images/logout1.png",
          title: "Logout",
          trailing: "",
          onPress: (context) {
            _logout();
          },
          isShowItrailing: false),
    ];
  }

  _navigate() {
    Navigator.pushNamedAndRemoveUntil(
        navigationService.navigationKey.currentContext!,
        Routes.loginScreen,
        (route) => false);
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
                  Provider.of<MainNavigationProwider>(context, listen: false)
                      .chaneIndexOfNavbar(0);
                },
                isShowCart: true,
                onCartPress: () {},
                title: "My Account",
              )),
          body: Container(
            color: ThemeClass.whiteColor,
            height: height,
            width: width,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  _buildListTile1(),
                  ...manuList.map((e) => _buildListTile(e)).toList(),
                  SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildListTile1() {
    return Consumer<FamilyMemberService>(
        builder: (context, familyprowider, child) {
      return Consumer<UserPrefService>(builder: (context, useProwider, child) {
        return ListTile(
            onTap: () {
              // data.onPress(context);
              if (familyprowider.isSelectFamilyMember) {
                pushNewScreen(
                  context,
                  screen: EditFamilyMemberScreen(
                    familyData: familyprowider.currentFamilyMember,
                  ),
                  withNavBar: false,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              } else {
                pushNewScreen(
                  context,
                  screen: MyProfileScreen(),
                  withNavBar: false,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              }
            },
            leading: SizedBox(
              height: 32,
              child: Image.asset("assets/images/user_icon.png"),
            ),
            title: Text(
              familyprowider.isSelectFamilyMember
                  ? familyprowider.currentFamilyMember!.name.toString()
                  : "Me",
              // useProwider.globleUserModel!.data!.name.toString(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: InkWell(
              onTap: () {
                _showSelectMemberBottomSheet();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "change",
                  style: TextStyle(
                    fontSize: 12,
                    color: ThemeClass.blueColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ));
      });
    });
  }

  ListTile _buildListTile(MyaccountListModel data) {
    return ListTile(
      onTap: () {
        data.onPress(context);
      },
      leading: SizedBox(
        height: 32,
        child: Image.asset(data.icon),
      ),
      title: Text(
        data.title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: data.isShowItrailing
          ? InkWell(
              onTap: () {
                _showSelectMemberBottomSheet();
              },
              child: Text(
                data.trailing,
                style: TextStyle(
                  fontSize: 12,
                  color: ThemeClass.blueColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          : SizedBox(),
    );
  }

  _showSelectMemberBottomSheet() {
    showModalBottomSheet(
        context: context,
        useRootNavigator: true,
        builder: (context) {
          return BottomSheetForMyAccountWidget();
        });
  }

  Future showAlertDialog(BuildContext context) {
    // show the dialog
    return showDialog(
      context: context,
      builder: (BuildContext context1) {
        return AlertDialog(
          title: Text('Confirmation.'),
          content: Text('Are you sure to Logout?'),
          actions: [
            TextButtonWidget(
              child: Text("No"),
              onPressed: () {
                Navigator.pop(context1, false);
              },
            ),
            TextButtonWidget(
              child: Text("Yes"),
              onPressed: () {
                Navigator.pop(context1, true);
              },
            )
          ],
        );
      },
    );
  }
}

class MyaccountListModel {
  String icon;
  String title;
  String trailing;
  bool isShowItrailing;
  Function onPress;

  MyaccountListModel({
    required this.icon,
    required this.onPress,
    required this.title,
    required this.trailing,
    required this.isShowItrailing,
  });
}
