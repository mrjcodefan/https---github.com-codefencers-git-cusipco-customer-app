import 'package:flutter/material.dart';
import 'package:heal_u/service/prowider/general_information_service.dart';
import 'package:heal_u/themedata.dart';
import 'package:heal_u/widgets/expanable_widget.dart';
import 'package:provider/provider.dart';

class SelectActivityDropdownWidget extends StatefulWidget {
  SelectActivityDropdownWidget({
    Key? key,
    required this.currentValue,
    required this.callBack,
    required this.expandcallBack,
  }) : super(key: key);
  String currentValue;

  Function(String) callBack;
  Function(bool) expandcallBack;
  @override
  State<SelectActivityDropdownWidget> createState() =>
      _SelectActivityDropdownWidgetState();
}

class _SelectActivityDropdownWidgetState
    extends State<SelectActivityDropdownWidget>
    with SingleTickerProviderStateMixin {
  bool expandFlag = false;
  late AnimationController expandController;
  late Animation<double> animation;

  @override
  void initState() {
    expandFlag = false;
    super.initState();
    prepareAnimations();
    _runExpandCheck();
  }

  void _runExpandCheck() {
    if (expandFlag) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }

  void prepareAnimations() {
    expandController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
  }

  List _activityData = [
    "Sedentary",
    "Slightly Active",
    "Moderately Active",
    "Highly Active",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: ThemeClass.greyLightColor.withOpacity(0.5),
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(30),
        ),
      ),
      child: Column(
        children: <Widget>[
          Transform.scale(
            scale: 1.03,
            child: Container(
              decoration: BoxDecoration(
                color: ThemeClass.whiteDarkColor,
                border: Border.all(
                  color: ThemeClass.whiteDarkColor,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 10),
                child: InkWell(
                  onTap: () {
                    setExpandToggle(!expandFlag);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 8,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            widget.currentValue == ""
                                ? "Select Activity"
                                : widget.currentValue,
                            // overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12.0,
                                color: ThemeClass.greyDarkColor),
                          ),
                        ),
                      ),
                      // Spacer(),
                      IconButton(
                        icon: Container(
                          height: 50.0,
                          width: 50.0,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                              child: Icon(
                            expandFlag
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: ThemeClass.blueColor,
                            size: 30.0,
                          )),
                        ),
                        onPressed: () {
                          setExpandToggle(!expandFlag);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          ExpandedSection(
            expand: expandFlag,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Consumer<GeneralInfoService>(
                  builder: (context, generalInfo, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...generalInfo.generalData!.userActivites!.map(
                      (e) => InkWell(
                        onTap: () {
                          widget.callBack(e.slug.toString());
                          setExpandToggle(false);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 8, bottom: 8),
                              child: Text(e.title.toString()),
                            ),
                            Divider(),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              }),
            ),
          )
        ],
      ),
    );
  }

  setExpandToggle(bool val) {
    widget.expandcallBack(val);
    setState(() {
      expandFlag = val;
    });
  }
}
