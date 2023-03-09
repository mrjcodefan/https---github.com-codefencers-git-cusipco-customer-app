import 'package:flutter/material.dart';
import 'package:heal_u/screens/main_screen/my_account/family_members/model/family_list_model.dart';
import 'package:heal_u/screens/main_screen/my_account/family_members/service/family_prowider_service.dart';
import 'package:heal_u/service/shared_pref_service/user_pref_service.dart';
import 'package:heal_u/themedata.dart';
import 'package:heal_u/widgets/general_widget.dart';
import 'package:provider/provider.dart';

class BottomSheetForMyAccountWidget extends StatefulWidget {
  BottomSheetForMyAccountWidget({Key? key}) : super(key: key);

  @override
  State<BottomSheetForMyAccountWidget> createState() =>
      _BottomSheetForMyAccountWidgetState();
}

class _BottomSheetForMyAccountWidgetState
    extends State<BottomSheetForMyAccountWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<FamilyMemberService>(
        builder: (context, familyprowider, child) {
      return Wrap(
        children: [
          _buildTitle(context), _buildCurrentUser(),
          ...familyprowider.familyMemberList!.map(
            (e) => _buildCard(e),
          ),
          // _buildCard(1),
          // _buildCard(1),
          // _buildCard(1),
        ],
      );
    });
  }

  Column _buildCard(FamilyData data) {
    return Column(children: [
      ListTile(
        onTap: () {
          _selectMember(data);
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

  _buildCurrentUser() {
    return Consumer<UserPrefService>(builder: (context, useProwider, child) {
      return Column(children: [
        ListTile(
          onTap: () {
            // _selectMember(data);
            _disSelectMember();
          },
          leading: CircleAvatar(
              backgroundImage: NetworkImage(
                  useProwider.globleUserModel!.data!.profileImage.toString())),
          title: Text(
            useProwider.globleUserModel!.data!.name.toString(),
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            "Me",
            style: TextStyle(
                color: ThemeClass.blueColor,
                fontSize: 12,
                fontWeight: FontWeight.w500),
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
    });
  }

  Column _buildTitle(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Select Member",
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

  _selectMember(FamilyData data) async {
    await Provider.of<FamilyMemberService>(context, listen: false)
        .selectCurrentMember(true, data);
    showToast("User changed.");
    Navigator.pop(context);
  }

  _disSelectMember() async {
    await Provider.of<FamilyMemberService>(context, listen: false)
        .selectCurrentMember(false, null);
    showToast("User changed.");
    Navigator.pop(context);
  }
}
