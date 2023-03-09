import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:heal_u/screens/main_screen/my_account/wallet/wallet_model.dart';
import 'package:heal_u/screens/main_screen/my_account/wallet/wallet_service.dart';
import 'package:heal_u/themedata.dart';
import 'package:heal_u/widgets/app_bars/appbar_with_text.dart';
import 'package:heal_u/widgets/button_widget/small_blue_button_widget.dart';
import 'package:heal_u/widgets/future_builder_widget.dart';
import 'package:intl/intl.dart';

class WalletScreen extends StatefulWidget {
  WalletScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  var _future;
  @override
  void initState() {
    super.initState();
    _future = WalletService.getWalletData();
  }

  _reFreshData() async {
    _future = WalletService.getWalletData();
  }

  List items = [1, 2, 3, 4, 5, 6, 7, 8, 5, 3, 23, 34];
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
                title: "HealU Wallet",
              )),
          body: Container(
            color: ThemeClass.whiteColor,
            height: height,
            width: width,
            child: RefreshIndicator(
              displacement: 40,
              onRefresh: () {
                return _reFreshData();
              },
              child: FutureBuildWidget(
                future: _future,
                child: (data) {
                  return SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: _buildView(data));
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column _buildView(WalletData? data) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTopContainer(data!.balance.toString()),
        _buildRewardTitle(),
        _buildDateAndAmount(),
        ...data.history!.map((e) => _buildListTileItems(e)).toList(),
      ],
    );
  }

  Column _buildListTileItems(History history) {
    DateTime tempDate1 =
        new DateFormat("yyyy-MM-dd").parse(history.date.toString());
    var tempDate = new DateFormat("dd MMMM,yyyy").format(tempDate1);

    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tempDate,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 1,
                  ),
                  Text(
                    history.time.toString(),
                    style: TextStyle(
                      fontSize: 10,
                      color: ThemeClass.greyDarkColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    history.type == "Deposit"
                        ? "+ ₹${history.balance}"
                        : "- ₹${history.balance}",
                    style: TextStyle(
                      fontSize: 14,
                      color: history.status == "Failed"
                          ? ThemeClass.redColor
                          : history.type == "Deposit"
                              ? ThemeClass.greenColor
                              : ThemeClass.redColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  history.status == "Failed"
                      ? Text(
                          history.status.toString(),
                          style: TextStyle(
                            fontSize: 10,
                            color: ThemeClass.redColor,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      : SizedBox()
                ],
              ),
            ],
          ),
        ),
        Divider(
          thickness: 1,
          color: ThemeClass.greyLightColor1,
        )
      ],
    );
  }

  Container _buildDateAndAmount() {
    return Container(
      color: ThemeClass.skyblueColor1,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Date",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "Amount",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding _buildRewardTitle() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Text(
        "Wallet History",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Container _buildTopContainer(String balance) {
    return Container(
      height: 120,
      width: double.infinity,
      color: ThemeClass.skyblueColor1,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 65,
              width: 65,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/walletIcon.png"),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Available Balance",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: ThemeClass.greyDarkColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "₹${balance}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: ThemeClass.blueColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
