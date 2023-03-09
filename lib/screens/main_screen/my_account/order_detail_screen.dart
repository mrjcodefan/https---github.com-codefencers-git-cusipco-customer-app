import 'package:flutter/material.dart';
import 'package:heal_u/service/prowider/order_details_provider.dart';
import 'package:heal_u/themedata.dart';
import 'package:heal_u/widgets/app_bars/appbar_with_text.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailScreen extends StatefulWidget {
  final String id;
  const OrderDetailScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  bool isloading = false;
  @override
  void initState() {
    initdata();
    super.initState();
  }

  initdata() async {
    setState(() {
      isloading = true;
    });
    await Provider.of<GetOrderDetailsService>(context, listen: false)
        .getOrderDetails(widget.id);
    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<GetOrderDetailsService>(context, listen: false);

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
                title: "Order Details",
              )),
          body: Container(
            color: ThemeClass.whiteColor,
            height: height,
            width: width,
            child: isloading
                ? Center(
                    child:
                        CircularProgressIndicator(color: ThemeClass.blueColor),
                  )
                : model.isError
                    ? Center(
                        child: Text(model.errorMessage),
                      )
                    : SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Container(
                          padding:
                              EdgeInsets.only(top: 20, left: 20, right: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildCartFirstRow(
                                  (model.orderDetailsModel!.data!.orderStatus ==
                                              "Delivered" ||
                                          model.orderDetailsModel!.data!
                                                  .orderStatus ==
                                              "Refund")
                                      ? "assets/images/green_done.png"
                                      : (model.orderDetailsModel!.data!
                                                      .orderStatus ==
                                                  "Canceled" ||
                                              model.orderDetailsModel!.data!
                                                      .orderStatus ==
                                                  "Rejected" ||
                                              model.orderDetailsModel!.data!
                                                      .orderStatus ==
                                                  "Failed")
                                          ? "assets/images/red_close.png"
                                          : "assets/images/orange_info.png",
                                  model.orderDetailsModel!.data!.statusLabel),
                              SizedBox(
                                height: 20,
                              ),
                              _buildItemsInOrders(model),
                              model.orderDetailsModel!.data!.orderStatus ==
                                      "Delivered"
                                  ? SizedBox()
                                  : model.orderDetailsModel!.data!.rider != null
                                      ? _buildDeliveryBoyDetails(model)
                                      : SizedBox(),
                              _buildIOrdersDEetails(model),
                              _buildShippingDetails(model)
                            ],
                          ),
                        ),
                      ),
          ),
        ),
      ),
    );
  }

  

  Column _buildDeliveryBoyDetails(GetOrderDetailsService model) {
    final data = model.orderDetailsModel!.data;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle("Rider Details"),
        Padding(
          padding: const EdgeInsets.only(bottom: 0, top: 10),
          child: Container(
            decoration: BoxDecoration(
                color: ThemeClass.skyblueColor1,
                borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.only(bottom: 20),
            padding: EdgeInsets.all(0),
            // color: ThemeClass.whiteDarkshadow,
            child: Padding(
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCustomerTile(
                            Icons.person, "${data!.rider!.name}"),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          child: Material(
                            child: InkWell(
                              onTap: () {
                                _launchURL(data.rider!.phoneNumber.toString());
                              },
                              child: _buildCustomerTile(Icons.call_rounded,
                                  "${data.rider!.phoneNumber}"),
                            ),
                            color: Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row _buildCustomerTile(IconData icon, String title) {
    return Row(
      children: [
        SizedBox(
          child: Icon(
            icon,
            color: ThemeClass.blueColor,
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: ThemeClass.blackColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        )
      ],
    );
  }

  Padding _buildTitle(String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, bottom: 5, top: 20, right: 10),
      child: Text(
        value,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _launchURL(String _url) async {
    try {
      if (!await launch("tel://${_url}")) throw 'Could not launch $_url';
    } catch (e) {
      debugPrint(e.toString());
    }
  }

   
  Column _buildShippingDetails(GetOrderDetailsService model) {
    final data = model.orderDetailsModel!.data;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Shipping Address",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          decoration: BoxDecoration(
              color: ThemeClass.skyblueColor1,
              borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.only(bottom: 20),
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data!.contactPerson.toString(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                data.shippingAddress.toString(),
                style: TextStyle(
                  fontSize: 12,
                  color: ThemeClass.greyDarkColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Row(
                children: [
                  Text(
                    "Mobile :  ",
                    style: TextStyle(
                      fontSize: 12,
                      color: ThemeClass.greyDarkColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    data.contactPhoneNumber.toString(),
                    style: TextStyle(
                      fontSize: 12,
                      color: ThemeClass.blueColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column _buildIOrdersDEetails(GetOrderDetailsService model) {
    final data = model.orderDetailsModel!.data;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Order Detail",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          decoration: BoxDecoration(
              color: ThemeClass.skyblueColor1,
              borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.only(bottom: 20),
          padding: EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              _buildCartsecondRow("assets/images/order_book.png", "Order ID",
                  data!.customOrderId.toString()),
              _buildCartsecondRow("assets/images/calender_simple.png",
                  "Order Date", data.createdAt.toString()),
              SizedBox(
                height: 10,
              ),
              _buildCartthirdRow(
                  false, "Item Total (MRP)", "₹${data.itemTotal}"),
              data.isItemDiscount == "1"
                  ? _buildCartthirdRow(false, "Discount", "- ₹${data.discount}")
                  : SizedBox(),
              data.isDeliveryCharge == "1"
                  ? _buildCartthirdRow(
                      false, "Delivery Charge", "+ ₹${data.deliveryFee}")
                  : SizedBox(),
              _buildCartthirdRow(
                  false, data.textLabel.toString(), "+ ₹${data.tax}"),
              _buildDivider(),
              _buildCartthirdRow(true, "Total Payable", "₹${data.grandTotal}"),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Padding _buildCartthirdRow(bool isPayamount, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 1, right: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: isPayamount
                  ? ThemeClass.blackColor
                  : ThemeClass.greyDarkColor,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              color:
                  isPayamount ? ThemeClass.blackColor : ThemeClass.blackColor,
              fontWeight: isPayamount ? FontWeight.w600 : FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }

  Padding _buildCartsecondRow(String icon, String title, String value) {
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
              Container(
                child: Text(
                  title,
                  // overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontSize: 12,
                    color: ThemeClass.greyDarkColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: TextStyle(
                  overflow: TextOverflow.clip,
                  fontSize: 12,
                  color: ThemeClass.blackColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Column _buildItemsInOrders(GetOrderDetailsService model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Items In Order",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          decoration: BoxDecoration(
              color: ThemeClass.skyblueColor1,
              borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.only(bottom: 20),
          padding: EdgeInsets.all(0),
          child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: model.orderDetailsModel!.data!.items!.length,
              itemBuilder: (context, index) {
                final data = model.orderDetailsModel!.data!.items![index];
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildcardRow(data.title.toString(), data.price.toString(),
                        data.quantity.toString(), index),
                    model.orderDetailsModel!.data!.items!.length == index + 1
                        ? SizedBox()
                        : Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: _buildDivider(),
                          ),
                  ],
                );
              }),
        ),
      ],
    );
  }

  Padding _buildcardRow(String text, String price, String quantity, index) {
    var tempIndex = index + 1 < 10 ? "0${index + 1}" : "${index + 1} ";
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            quantity + "   x   ",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              "₹${price}",
              style: TextStyle(
                color: ThemeClass.blueColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Divider _buildDivider() {
    return Divider(
      thickness: 1,
      height: 5,
      color: ThemeClass.greyLightColor1,
    );
  }

  Row _buildCartFirstRow(String img, String? text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset(
              img,
              height: 30,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              text.toString(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
