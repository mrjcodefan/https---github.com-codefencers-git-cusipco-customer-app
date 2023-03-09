import 'package:flutter/material.dart';
import 'package:heal_u/pages/rating_screen.dart';

import 'package:heal_u/screens/main_screen/my_account/order_detail_screen.dart';
import 'package:heal_u/service/prowider/order_history_provider.dart';

import 'package:heal_u/themedata.dart';
import 'package:heal_u/widgets/app_bars/appbar_with_text.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class MyOrderScreen extends StatefulWidget {
  MyOrderScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  @override
  void initState() {
    Provider.of<OrderHistoryServices>(context, listen: false)
        .getOrderHistoryData();
    super.initState();
  }

// cmt
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
                isShowCart: true,
                onCartPress: () {},
                title: "My Orders",
              )),
          body: Container(
            color: ThemeClass.whiteColor,
            height: height,
            width: width,
            child: Consumer<OrderHistoryServices>(
                builder: (context, getdata, child) {
              return getdata.loading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: ThemeClass.blueColor,
                      ),
                    )
                  : getdata.isError == true
                      ? Center(
                          child: Text(
                            getdata.errorMessage,
                            textAlign: TextAlign.center,
                          ),
                        )
                      : SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Container(
                            padding:
                                EdgeInsets.only(top: 20, left: 20, right: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Your Orders",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount:
                                        getdata.orderHistoryModel!.data.length,
                                    itemBuilder: (context, index) {
                                      return _buildCart(getdata, index);
                                    })
                              ],
                            ),
                          ),
                        );
            }),
          ),
        ),
      ),
    );
  }

  InkWell _buildCart(OrderHistoryServices getdata, index) {
    final data = getdata.orderHistoryModel!.data[index];
    var actualData = data.createdAt.toString();

    DateTime tempDate1 =
        new DateFormat("yyyy-MM-dd hh:mm:ss").parse(actualData);
    var tempDate = new DateFormat("dd MMMM,yyyy hh:mm a").format(tempDate1);
    // var mpd= tempDate.f
    return InkWell(
      onTap: () {
        pushNewScreen(
          context,
          screen: OrderDetailScreen(
            id: data.id,
          ),
          withNavBar: false,
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
      },
      child: Container(
        decoration: BoxDecoration(
            color: ThemeClass.skyblueColor1,
            borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.only(bottom: 20),
        padding: EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCartFirstRow(
                (data.status == "Delivered" || data.status == "Refund")
                    ? "assets/images/green_done.png"
                    : (data.status == "Rejected" ||
                            data.status == "Canceled" ||
                            data.status == "Failed")
                        ? "assets/images/red_close.png"
                        : "assets/images/orange_info.png",
                data.statusLabel,
                data.id,
                data.ownerId,
                data.isReviewSubmited,
                status: data.status),
            _buildDivider(),
            _buildCartsecondRow("assets/images/order_book.png", "Order ID",
                data.customOrderId.toString()),
            _buildCartsecondRow("assets/images/calender_simple.png",
                "Order Date", tempDate.toString()),
            _buildDivider(),
            _buildItemOrder(getdata, index),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  Padding _buildItemOrder(OrderHistoryServices getdata, int temp) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Items In Order",
            style: TextStyle(
              fontSize: 12,
              color: ThemeClass.blackColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: getdata.orderHistoryModel!.data[temp].items.length,
              itemBuilder: (context, index) {
                // var tempIndex =
                //     index + 1 < 10 ? "0${index + 1}" : "${index + 1} ";
                return Text(
                  " ${getdata.orderHistoryModel!.data[temp].items[index].quantity.toString()}   x   ${getdata.orderHistoryModel!.data[temp].items[index].title.toString()}",
                  style: TextStyle(
                    fontSize: 12,
                    color: ThemeClass.greyDarkColor,
                    fontWeight: FontWeight.w400,
                  ),
                );
              }),
        ],
      ),
    );
  }

  Divider _buildDivider() {
    return Divider(
      thickness: 1,
      // height: 10,
      color: ThemeClass.greyLightColor1,
    );
  }

  Padding _buildCartsecondRow(String icon, String title, String value) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 1, right: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                icon,
                height: 25,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: ThemeClass.greyDarkColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          SizedBox(
            width: 20,
          ),
          Flexible(
            child: Text(
              value,
              // maxLines: 4,
              overflow: TextOverflow.clip,
              style: TextStyle(
                fontSize: 12,
                color: ThemeClass.blackColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
      ),
    );
  }

  Padding _buildCartFirstRow(
      String img, String text, id, ownderId, bool isreviewSubmited,
      {required String status}) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                img,
                height: 25,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                text,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          status.toLowerCase() == "delivered"
              ? isreviewSubmited == true
                  ? SizedBox()
                  : InkWell(
                      onTap: () {
                        pushNewScreen(
                          context,
                          screen: RatingScreen(
                              id: id, ownerId: ownderId, isOrder: true),
                          withNavBar: false,
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Submit Review",
                          style: TextStyle(
                            fontSize: 12,
                            color: ThemeClass.redColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
              : SizedBox()
        ],
      ),
    );
  }
}
