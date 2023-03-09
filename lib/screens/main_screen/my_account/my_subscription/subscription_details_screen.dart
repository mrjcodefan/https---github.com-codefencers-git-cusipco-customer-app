import 'package:flutter/material.dart';
import 'package:heal_u/screens/main_screen/my_account/my_subscription/chart_model.dart';
import 'package:heal_u/screens/main_screen/my_account/my_subscription/subscription_service.dart';
import 'package:heal_u/themedata.dart';
import 'package:heal_u/widgets/app_bars/appbar_with_text.dart';

class SubscriptionDetailsScreen extends StatefulWidget {
  SubscriptionDetailsScreen({Key? key, required this.id}) : super(key: key);
  String id;
  @override
  State<SubscriptionDetailsScreen> createState() =>
      _SubscriptionDetailsScreenState();
}

class _SubscriptionDetailsScreenState extends State<SubscriptionDetailsScreen> {
  var _futureCall;
  @override
  @override
  void initState() {
    // TODO: implement initState
    _reFreshData(true);
    super.initState();
  }

  _reFreshData(bool loading) async {
    _futureCall = SubscriptionService().getChartData(widget.id);
  }

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
                isShowCart: true,
                title: "Details",
              )),
          body: Container(
              color: ThemeClass.whiteColor,
              height: height,
              width: width,
              child: FutureBuilder(
                  future: _futureCall,
                  builder: (context, AsyncSnapshot<ChartData?> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        if (snapshot.data != null) {
                          return _buildView(context, snapshot.data);
                        } else {
                          return _buildDataNotFound1("Data Not Found!");
                        }
                      } else if (snapshot.hasError) {
                        return _buildDataNotFound1(snapshot.error.toString());
                      } else {
                        return _buildDataNotFound1("Data Not Found!");
                      }
                    } else {
                      // return _buildDataNotFound1("Data Not Found!");
                      return Container(
                        padding: EdgeInsets.only(
                            top: height / 3, bottom: height / 3),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: ThemeClass.blueColor,
                          ),
                        ),
                      );
                    }
                  })),
        ),
      ),
    );
  }

  Padding _buildDataNotFound1(
    String text,
  ) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Center(
          child: Text(
        "$text",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      )),
    );
  }

  SingleChildScrollView _buildView(BuildContext context, ChartData? data) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      // ignore: prefer_const_literals_to_create_immutables
      child: Padding(
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            _buildUserInfo(data!.count),
            SizedBox(
              height: 20,
            ),
            _buildTitle(
              "Diet Chart",
            ),
            SizedBox(
              height: 20,
            ),
            _buildHeaderTitle(),

            ...data.dietChart!.map((e) => _buildListTile(e)).toList()

            // ...list.map((e) => _buildListTile(e)).toList(),
          ],
        ),
      ),
    );
  }

  Card _buildUserInfo(Count? count) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Column(
          children: [
            _buildLine("Meal Type", "Total Available Meal", isHead: true),
            SizedBox(
              height: 10,
            ),
            _buildLine("Breakfast", count!.breakfast.toString()),
            _buildLine("Lunch", count.lunch.toString()),
            _buildLine("Dinner", count.dinner.toString()),
          ],
        ),
      ),
    );
  }

  Text _buildTitle(String value) {
    return Text(
      value,
      style: TextStyle(
        fontSize: 14,
        color: ThemeClass.blueColor,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Row _buildLine(String first, String second, {bool? isHead}) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            first,
            style: TextStyle(
                color: isHead != null
                    ? ThemeClass.blackColor
                    : ThemeClass.greyColor,
                fontWeight: isHead != null ? FontWeight.w500 : FontWeight.w400,
                fontSize: 12),
          ),
        ),
        Text(
          isHead != null ? "        " : "  :     ",
          style: TextStyle(color: ThemeClass.greyColor, fontSize: 12),
        ),
        Expanded(
          flex: 3,
          child: Text(
            second,
            style: TextStyle(
              color:
                  isHead != null ? ThemeClass.blackColor : ThemeClass.greyColor,
              fontSize: 12,
              fontWeight: isHead != null ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Column _buildListTile(DietChart data) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  flex: 3,
                  child: _buildText(
                    data.day.toString(),
                  )),
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...data.data!.map((e) => _buildMealType(e)).toList()
                    // ...data['data'].map((e) => _buildMealType(e)).toList(),
                  ],
                ),
              ),
            ],
          ),
        ),
        _buildDivider()
      ],
    );
  }

  Row _buildMealType(ChartDataDetails data) {
    var data1 = data.meals!.map((e) {
      if (e.title == "") {
        return "";
      } else {
        return e.title;
      }
    });
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildText(data.mealType.toString())),
        Expanded(child: _buildText(data1.toString()))
        // Expanded(
        //   child: Column(
        //     children: [
        //       ...data.meals!.map((e) => _buildText(e.title.toString())).toList()
        //     ],
        //   ),
        // )
      ],
    );
  }

  Padding _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Divider(
        thickness: 1,
        height: 0,
        color: ThemeClass.greyLightColor1,
      ),
    );
  }

  Padding _buildText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(text.toString(),
          style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: ThemeClass.greyDarkColor)),
    );
  }

  Container _buildHeaderTitle() {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: -2,
            blurRadius: 1,
            offset: Offset(0, 4), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: ThemeClass.whiteDarkshadow,
      ),
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Text(
                "Days",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              )),
          Expanded(
              flex: 3,
              child: Text("Meal Type",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))),
          Expanded(
              flex: 3,
              child: Text("Food Item",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}
