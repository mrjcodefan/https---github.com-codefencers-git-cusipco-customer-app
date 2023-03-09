import 'package:flutter/material.dart';
import 'package:heal_u/screens/main_screen/my_account/family_members/model/family_list_model.dart';
import 'package:heal_u/screens/main_screen/my_account/family_members/service/family_prowider_service.dart';
import 'package:heal_u/service/shared_pref_service/user_pref_service.dart';
import 'package:heal_u/themedata.dart';
import 'package:heal_u/widgets/button_widget/rounded_button_widget.dart';
import 'package:heal_u/widgets/general_widget.dart';
import 'package:provider/provider.dart';

class BottomSheetForOnlineOffLineDoctore extends StatefulWidget {
  BottomSheetForOnlineOffLineDoctore({Key? key}) : super(key: key);

  @override
  State<BottomSheetForOnlineOffLineDoctore> createState() =>
      _BottomSheetForOnlineOffLineDoctoreState();
}

class _BottomSheetForOnlineOffLineDoctoreState
    extends State<BottomSheetForOnlineOffLineDoctore> {
  List listData = ["Online", "Offline"];

  var groupVal = "Online";
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        _buildTitle(context),
        ...listData.map((e) => _buildCard(e)).toList()
        // _buildCard(1),
        // _buildCard(1),
        // _buildCard(1),
        ,
        SizedBox(height: 90),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: ButtonWidget(
              title: "Submit",
              color: ThemeClass.blueColor,
              callBack: () {
                Navigator.pop(context, groupVal);
              }),
        )
      ],
    );
  }

  Column _buildCard(e) {
    return Column(children: [
      InkWell(
        onTap: () {
          setState(() {
            groupVal = e.toString();
          });
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            children: [
              Radio(
                value: e.toString(),
                activeColor: ThemeClass.blueColor,
                fillColor: MaterialStateProperty.all(ThemeClass.blueColor),
                groupValue: groupVal,
                onChanged: (value) {},
              ),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      e.toString(),
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: Container(
                    height: 30,
                    width: 30,
                    margin: EdgeInsets.only(right: 25),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      image: DecorationImage(
                        image: AssetImage(e == "Online"
                            ? "assets/images/online.png"
                            : "assets/images/offline.png"),
                        fit: BoxFit.contain,
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
      )
    ]);
  }

  Column _buildTitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Select Your Mode",
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
                color: ThemeClass.blueColor,
              )
            ],
          ),
        ),
        Divider(
          thickness: 1,
          height: 0,
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
