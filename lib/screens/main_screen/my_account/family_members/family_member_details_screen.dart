import 'package:flutter/material.dart';
import 'package:heal_u/screens/main_screen/my_account/family_members/edit_family_member.dart';
import 'package:heal_u/screens/main_screen/my_account/family_members/model/family_list_model.dart';

import 'package:heal_u/themedata.dart';
import 'package:heal_u/widgets/app_bars/appbar_with_text.dart';
import 'package:heal_u/widgets/button_widget/rounded_button_widget.dart';

import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class FamilyMemberDetaisScreen extends StatefulWidget {
  FamilyMemberDetaisScreen({Key? key, required this.familyData})
      : super(key: key);

  final FamilyData familyData;

  @override
  State<FamilyMemberDetaisScreen> createState() =>
      _FamilyMemberDetaisScreenState();
}

class _FamilyMemberDetaisScreenState extends State<FamilyMemberDetaisScreen> {
  @override
  void initState() {
    super.initState();
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
                title: "Family Member Detail",
              )),
          body: Container(
            color: ThemeClass.whiteColor,
            height: height,
            width: width,
            child: Stack(
              children: [
                _buildView(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    height: 80,
                    child: ButtonWidget(
                        title: "Edit Details",
                        color: ThemeClass.blueColor,
                        callBack: () {
                          pushNewScreen(
                            context,
                            screen: EditFamilyMemberScreen(
                              familyData: widget.familyData,
                            ),
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

  SingleChildScrollView _buildView() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      // ignore: prefer_const_literals_to_create_immutables
      child: Padding(
        padding: const EdgeInsets.only(top: 25, left: 15, right: 15),
        // ignore: prefer_const_literals_to_create_immutables
        child: Column(
          // ignore: prefer_const_literals_to_create_immutables
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCircleImage(),
            SizedBox(
              height: 40,
            ),
            _buildNameRow(),
            _buildDivider(),
            _buildRelationAndDOBRow(),
            _buildDivider(),
            _buildTextTitle("Email Address"),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                widget.familyData.email.toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            _buildDivider(),
            _buildTextTitle("Phone Number"),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                widget.familyData.phoneNumber.toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            _buildDivider(),
            _buildTextTitle("Activity"),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                widget.familyData.activity.toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            _buildDivider(),
            _buildHeightWeight(),
            SizedBox(
              height: 150,
            ),
          ],
        ),
      ),
    );
  }

  Padding _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Divider(
        height: 5,
        thickness: 1,
        color: ThemeClass.greyLightColor1,
      ),
    );
  }

  Row _buildRelationAndDOBRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextTitle("Relation"),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  widget.familyData.relation.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          width: 15,
          height: 80,
          padding: EdgeInsets.symmetric(vertical: 22),
          child: VerticalDivider(
            color: ThemeClass.greyLightColor1,
            thickness: 1,
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextTitle("Date of Birth"),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  widget.familyData.dob.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Row _buildHeightWeight() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextTitle("Height"),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  widget.familyData.height.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextTitle("Weight"),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  widget.familyData.weight.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Row _buildNameRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextTitle("Name"),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  widget.familyData.name.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          width: 15,
          height: 80,
          padding: EdgeInsets.symmetric(vertical: 22),
          child: VerticalDivider(
            color: ThemeClass.greyLightColor1,
            thickness: 1,
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextTitle("Age"),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  widget.familyData.age.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Center _buildCircleImage() {
    return Center(
      child: CircleAvatar(
          radius: 80.0,
          backgroundImage: NetworkImage(
            widget.familyData.profileImage.toString(),
          )),
    );
  }

  Padding _buildTextTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5, top: 15, left: 15),
      child: Text(
        title,
        style: TextStyle(fontSize: 12, color: ThemeClass.blueColor),
      ),
    );
  }
}
