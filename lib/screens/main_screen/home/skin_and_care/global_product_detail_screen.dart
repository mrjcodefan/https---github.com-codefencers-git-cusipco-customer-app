import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:heal_u/service/prowider/skincare_details_provider.dart';
import 'package:heal_u/widgets/app_bars/appbar_with_text.dart';

import 'package:heal_u/widgets/bottom_sheets/bottom_sheet_for_book_appointment.dart';
import 'package:heal_u/widgets/button_widget/rounded_button_widget.dart';
import 'package:heal_u/widgets/slider_for_product_details_widget.dart';
import 'package:provider/provider.dart';
import '../../../../themedata.dart';

class GlobalProductdetails extends StatefulWidget {
  final String id;

  const GlobalProductdetails({
    Key? key,
    required this.id,
    required this.title,
    required this.urlPerameter,
  }) : super(key: key);
  final String urlPerameter;
  final String title;
  @override
  State<GlobalProductdetails> createState() => _GlobalProductdetailsState();
}

class _GlobalProductdetailsState extends State<GlobalProductdetails> {
  @override
  void initState() {
    initalizeDAta();
    super.initState();
  }

  bool isLoading = false;

  initalizeDAta() async {
    setState(() {
      isLoading = true;
    });
    await Provider.of<SkincareDetailsService>(context, listen: false)
        .getskincareDetails(widget.id, widget.urlPerameter);
    setState(() {
      isLoading = false;
    });
  }

  CarouselController buttonCarouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(65.0),
          child: AppBarWithTextAndBackWidget(
            onbackPress: () {
              Navigator.pop(context);
            },
            isShowCart: false,
            title: widget.title,
          )),
      body: Consumer<SkincareDetailsService>(
          builder: (context, skinProwider, child) {
        return isLoading
            ? Center(
                child: CircularProgressIndicator(color: ThemeClass.blueColor),
              )
            : skinProwider.isError
                ? Center(
                    child: Text(skinProwider.cerrorMessage),
                  )
                : Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            SliderProductDetailsWidget(
                              image:
                                  skinProwider.skincareDetailsModel!.data.image,
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    skinProwider
                                        .skincareDetailsModel!.data.title,
                                    style: TextStyle(
                                        color: ThemeClass.blackColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    skinProwider
                                        .skincareDetailsModel!.data.owner,
                                    style: TextStyle(
                                        color: ThemeClass.greyColor,
                                        fontSize: 14),
                                  ),
                                  // Text(
                                  //   '₹ ${skinProwider.skincareDetailsModel!.data.price}',
                                  //   style: TextStyle(
                                  //       color: ThemeClass.blueColor,
                                  //       fontSize: 22),
                                  // ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        skinProwider.skincareDetailsModel!.data
                                                    .salePrice ==
                                                ""
                                            ? "₹${skinProwider.skincareDetailsModel!.data.price}"
                                            : "₹${skinProwider.skincareDetailsModel!.data.salePrice}",
                                        style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 22,
                                            color: ThemeClass.blueColor,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 5),
                                          child: Text(
                                            skinProwider.skincareDetailsModel!
                                                        .data.salePrice !=
                                                    ""
                                                ? "₹${skinProwider.skincareDetailsModel!.data.price}"
                                                : "",
                                            style: TextStyle(
                                                // overflow: TextOverflow.ellipsis,
                                                fontSize: 16,
                                                color: ThemeClass.greyColor,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Divider(),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'About',
                                    style: TextStyle(
                                        color: ThemeClass.blackColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    skinProwider
                                        .skincareDetailsModel!.data.description,
                                    style: TextStyle(
                                      color: ThemeClass.blackColor1,
                                      fontSize: 10,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      _buildBottomButton(skinProwider)
                    ],
                  );
      }),
    );
  }

  Align _buildBottomButton(SkincareDetailsService model) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        padding: EdgeInsets.only(
          bottom: 25,
          right: 10,
          left: 10,
        ),
        height: 80,
        child: ButtonWidget(
          //isLoading: _isLoading,
          title: "Book an Appointment",
          color: ThemeClass.blueColor,
          callBack: () {
            _showBottom(model);
          },
        ),
      ),
    );
  }

  _showBottom(SkincareDetailsService model) {
    showModalBottomSheet(
        isScrollControlled: true,
        useRootNavigator: true,
        context: context,
        builder: (context) {
          return BottomSheetBookApointment(
            model: model.skincareDetailsModel,
            urlPerameter: widget.urlPerameter,
          );
        });
  }
}
