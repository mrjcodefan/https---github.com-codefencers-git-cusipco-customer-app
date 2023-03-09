import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:heal_u/Global/global_variable_for_show_messge.dart';
import 'package:heal_u/screens/main_screen/my_account/family_members/add_family_member_form_screen.dart';
import 'package:heal_u/screens/main_screen/my_account/family_members/family_member_details_screen.dart';
import 'package:heal_u/screens/main_screen/my_account/family_members/model/family_list_model.dart';
import 'package:heal_u/screens/main_screen/my_account/family_members/service/family_prowider_service.dart';
import 'package:heal_u/service/http_service/http_service.dart';
import 'package:heal_u/service/navigation_service.dart';
import 'package:heal_u/service/shared_pref_service/user_pref_service.dart';

import 'package:heal_u/themedata.dart';
import 'package:heal_u/widgets/app_bars/appbar_with_text.dart';
import 'package:heal_u/widgets/button_widget/rounded_button_widget.dart';
import 'package:heal_u/widgets/general_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class FamilyMemberListScreen extends StatefulWidget {
  FamilyMemberListScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<FamilyMemberListScreen> createState() => _FamilyMemberListScreenState();
}

class _FamilyMemberListScreenState extends State<FamilyMemberListScreen> {
  bool _isLoading = false;
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      // await Provider.of<FamilyMemberService>(context, listen: false)
      //     .getFamilyMemberList();
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
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
                title: "Family Members",
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
                  child: _isLoading
                      ? Container(
                          height: height - 100,
                          child: Center(
                            child: CircularProgressIndicator(
                                color: ThemeClass.blueColor),
                          ),
                        )
                      : Consumer<FamilyMemberService>(
                          builder: (context, familyService, child) {
                          return Container(
                            height: height - 100,
                            child: Center(
                              child: familyService.familyMemberList!.isEmpty
                                  ? Text("No data found")
                                  : Column(
                                      // ignore: prefer_const_literals_to_create_immutables
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                          ...familyService.familyMemberList!
                                              .map((e) => _buildCard(e))
                                              .toList(),
                                          SizedBox(
                                            height: 100,
                                          )
                                        ]),
                            ),
                          );
                        }),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    height: 80,
                    child: ButtonWidget(
                        title: "Add New Member",
                        color: ThemeClass.blueColor,
                        callBack: () {
                          pushNewScreen(
                            context,
                            screen: AddFamilyMemberFormScreen(),
                            withNavBar: false,
                            pageTransitionAnimation:
                                PageTransitionAnimation.cupertino,
                          );
                        }),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column _buildCard(FamilyData data) {
    return Column(children: [
      ListTile(
        onTap: () {
          pushNewScreen(
            context,
            screen: FamilyMemberDetaisScreen(familyData: data),
            withNavBar: false,
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        },
        leading: CircleAvatar(
          backgroundImage: NetworkImage(data.profileImage.toString()),
        ),
        title: Text(
          data.name.toString(),
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          data.relation.toString(),
          style: TextStyle(
              color: ThemeClass.blueColor,
              fontSize: 12,
              fontWeight: FontWeight.w500),
        ),
        trailing: DropdownButton(
          icon: Image.asset(
            "assets/images/three_dots.png",
            height: 30,
          ),
          underline: SizedBox(),
          onChanged: (value) {
            _deleteMember(value.toString());
          },
          items: [
            DropdownMenuItem(value: data.id.toString(), child: Text("Delete"))
          ],
        ),

        // InkWell(
        //   onTap: () {
        //     pushNewScreen(
        //       context,
        //       screen: EditFamilyMemberScreen(
        //         familyData: data,
        //       ),
        //       withNavBar: false,
        //       pageTransitionAnimation: PageTransitionAnimation.cupertino,
        //     );
        //   },
        //   child: Image.asset(
        //     "assets/images/three_dots.png",
        //     height: 30,
        //   ),
        // ),
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

  _deleteMember(String familyId) async {
    print("id -------> $familyId");

    try {
      EasyLoading.show();
      Map<String, String> queryParameters = {
        "member_id": familyId,
      };

      print(queryParameters);

      var response = await HttpService.httpPost(
          "delete_member", queryParameters,
          context: context);

      if (response.statusCode == 201 || response.statusCode == 200) {
        var res = jsonDecode(response.body);

        if (res['success'].toString() == "1" &&
            res['status'].toString() == "200") {
          showToast(res['message']);

          var familypro =
              Provider.of<FamilyMemberService>(context, listen: false);
          await familypro.selectCurrentMember(false, null);
          await familypro.getFamilyMemberList(context: context);
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
