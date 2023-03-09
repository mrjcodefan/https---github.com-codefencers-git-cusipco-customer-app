import 'package:flutter/material.dart';
import 'package:heal_u/screens/main_screen/home/Diet/model/diet_plan_model.dart';
import 'package:heal_u/themedata.dart'; //ignore: file_names

//ignore: file_names
class ExpandableListView extends StatefulWidget {
  final DietPlan data;
  final String? arrowImage;
  final bool isExpanded;
  // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
  final Function(DietPlan) onSelect;

  const ExpandableListView({
    Key? key,
    required this.data,
    this.isExpanded = false,
    required this.onSelect,
    this.arrowImage,
  }) : super(key: key);

  @override
  ExpandableListViewState createState() => new ExpandableListViewState();
}

class ExpandableListViewState extends State<ExpandableListView>
    with SingleTickerProviderStateMixin {
  bool expandFlag = false;
  late AnimationController expandController;
  late Animation<double> animation;

  @override
  void initState() {
    expandFlag = widget.isExpanded;
    super.initState();
    prepareAnimations();
    _runExpandCheck();
  }

  ///Setting up the animation
  void prepareAnimations() {
    expandController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
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

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: ThemeClass.greyLightColor.withOpacity(0.5),
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        children: <Widget>[
          Transform.scale(
            scale: 1.02,
            child: Container(
              decoration: BoxDecoration(
                color: ThemeClass.blueColor2,
                border: Border.all(
                  color: ThemeClass.blueColor2,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      expandFlag = !expandFlag;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 8,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            widget.data.title.toString(),
                            // overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14.0,
                                color: ThemeClass.blueColor),
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
                            child: widget.arrowImage == null
                                ? Icon(
                                    expandFlag
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                    color: ThemeClass.blueColor,
                                    size: 30.0,
                                  )
                                : expandFlag
                                    ? Image.asset(
                                        widget.arrowImage!,
                                        height: 18,
                                        width: 18,
                                      )
                                    : Image.asset(
                                        widget.arrowImage!,
                                        height: 18,
                                        width: 18,
                                      ),
                          ),
                        ),
                        onPressed: () {
                          setState(
                            () {
                              expandFlag = !expandFlag;
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          ExpandedSection(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "₹${widget.data.price.toString()}",
                        style: TextStyle(
                            color: ThemeClass.blueColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                      InkWell(
                        onTap: () {
                          widget.onSelect(widget.data);
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                            color: ThemeClass.blueColor,
                          ),
                          child: Text(
                            "Select Plan",
                            style: TextStyle(
                              color: ThemeClass.whiteColor,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ...widget.data.benefits!
                      .map((e) => _buildCardlines(e.title.toString()))
                      .toList()
                ],
              ),
            ),
            expand: expandFlag,
          )
        ],
      ),
    );
  }

  Padding _buildCardlines(text) {
    return Padding(
      padding: EdgeInsets.only(left: 0, bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 5),
            height: 15,
            width: 15,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/checked_squre.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: ThemeClass.greyColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ExpandedSection extends StatefulWidget {
  final Widget child;
  final bool expand;
  const ExpandedSection({this.expand = false, required this.child});

  @override
  _ExpandedSectionState createState() => _ExpandedSectionState();
}

class _ExpandedSectionState extends State<ExpandedSection>
    with SingleTickerProviderStateMixin {
  late AnimationController expandController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
    _runExpandCheck();
  }

  ///Setting up the animation
  void prepareAnimations() {
    expandController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
  }

  void _runExpandCheck() {
    if (widget.expand) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void didUpdateWidget(ExpandedSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
        axisAlignment: 1.0, sizeFactor: animation, child: widget.child);
  }
}
