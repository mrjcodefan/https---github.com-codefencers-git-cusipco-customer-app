import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:heal_u/Global/globle_methd.dart';
import 'package:heal_u/pages/rating_screen.dart';
import 'package:heal_u/screens/main_screen/my_account/my_appointment/appointment_detail_model.dart';
import 'package:heal_u/screens/main_screen/my_account/my_appointment/appointment_service.dart';
import 'package:heal_u/service/save_file_service.dart';
import 'package:heal_u/themedata.dart';
import 'package:heal_u/widgets/app_bars/appbar_with_text.dart';
import 'package:heal_u/widgets/button_widget/rounded_button_widget.dart';
import 'package:heal_u/widgets/button_widget/small_blue_button_widget.dart';
import 'package:heal_u/widgets/future_builder_widget.dart';
import 'package:heal_u/widgets/general_widget.dart';
import 'package:open_file/open_file.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:url_launcher/url_launcher.dart';

class AppointmentDetailsScreen extends StatefulWidget {
  final String id;
  const AppointmentDetailsScreen({Key? key, required this.id})
      : super(key: key);

  @override
  State<AppointmentDetailsScreen> createState() =>
      _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {
  CarouselController buttonCarouselController = CarouselController();

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
                isShowCart: true,
                title: "Appointment Details",
              )),
          body: Container(
              color: ThemeClass.whiteColor,
              height: height,
              width: width,
              child: FutureBuildWidget(
                isList: false,
                future: AppointMentService().getAppointmentDetails(widget.id),
                child: (data) {
                  return _buildView(data);
                },
              )),
        ),
      ),
    );
  }

  SingleChildScrollView _buildView(AppointmentDetailData? data) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: _buildImageWithDetails(data),
          ),
          SizedBox(
            height: 25,
          ),
          _buildMenues(data),
          SizedBox(
            height: 10,
          ),
          _buildOTPAndAddress(data!.otp.toString()),
          SizedBox(
            height: 10,
          ),
          _buildNotes(data.note.toString()),
          SizedBox(
            height: 10,
          ),
          data.prescription.toString() == ""
              ? SizedBox()
              : _buildPrescription(data.prescription.toString()),
          data.prescription.toString() == ""
              ? SizedBox()
              : SizedBox(
                  height: 10,
                ),
          _buildbottomAmount(data.totalAmount.toString(), data.tax.toString()),
          SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }

  Container _buildOTPAndAddress(String opt) {
    return Container(
      color: ThemeClass.skyblueColor1,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
        child: Column(children: [
          _buildOtpListTile("OTP", opt, true),
        ]),
      ),
    );
  }

  Container _buildNotes(String notes) {
    return Container(
      color: ThemeClass.skyblueColor1,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
        child: Column(children: [
          _buildOtpListTile("Notes", notes, false),
        ]),
      ),
    );
  }

  Container _buildPrescription(String url) {
    return Container(
      color: ThemeClass.skyblueColor1,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
        child: Column(children: [
          Container(
            width: 40,
            child: Image.asset("assets/images/file_icon.png"),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              url.split("/").last.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(color: ThemeClass.greyLightColor),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              _downloadPrescription(url);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                color: ThemeClass.blueColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.cloud_download,
                    color: Colors.white,
                    size: 18,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Download",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ]),
      ),
    );
  }

  _downloadPrescription(String url) async {
    try {
      EasyLoading.show();
      var path = await SaveFileService().createFolder(url);
      final _result = await OpenFile.open(path.path);
      print(_result.message);
    } catch (e) {
      showToast(e.toString());
    } finally {
      EasyLoading.dismiss();
    }
  }

  Container _buildMenues(AppointmentDetailData? data) {
    var tempTime = time24to12Format(data!.time.toString());
    return Container(
      color: ThemeClass.skyblueColor1,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
        child: Column(children: [
          _buildMenuListTile(
              "Date Time",
              data.date.toString() + ", " + tempTime,
              false,
              'assets/images/calender_dark.png',
              false,
              false),
          _buildMenuListTile("Mode of booking", data.modeOfBooking.toString(),
              false, 'assets/images/network.png', true, false),
          // data.modeOfBooking.toString() == "Online"
          //     ? _buildMenuListTile("Google Map URL", data.meetingUrl.toString(),
          //         false, 'assets/images/video_camera.png', false, true)
          //     : SizedBox(),
          data.meetingUrl.toString() != ""
              ? _buildMenuListTile("Google Map URL", data.meetingUrl.toString(),
                  false, 'assets/images/video_camera.png', false, true)
              : SizedBox(),
          data.modeOfBooking.toString() == "Online"
              ? SizedBox()
              : _buildMenuListTile("Address", data.address.toString(), true,
                  'assets/images/location11.png', false, false)
        ]),
      ),
    );
  }

  Column _buildOtpListTile(String title, String value, bool isLast) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: ThemeClass.blackColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      letterSpacing: isLast ? 10 : 0,
                      fontSize: isLast ? 20 : 10,
                      color:
                          isLast ? ThemeClass.blueColor : ThemeClass.blackColor,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  InkWell _buildMenuListTile(String title, String value, bool isLast,
      String iconPath, bool isNetword, bool isSecondIcon) {
    return InkWell(
      onTap: () {
        if (title == "Address") {
          _launchURL(
              "https://www.google.com/maps/search/?api=1&query=${value}");
        }
      },
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 10, top: isNetword ? 5 : 0),
                child: Container(
                  height: isNetword ? 16 : 25,
                  width: isNetword ? 25 : 25,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(iconPath),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        color: ThemeClass.blackColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 10,
                        color: ThemeClass.blackColor,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                ),
              ),
              isSecondIcon
                  ? value == ""
                      ? SizedBox()
                      : Center(
                          child: InkWell(
                            onTap: () {
                              _launchURL(value);
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(right: 10, top: 10),
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/link.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                  : SizedBox(),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          isLast
              ? SizedBox()
              : Divider(
                  height: 5,
                ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Container _buildImageWithDetails(AppointmentDetailData? data) {
    return Container(
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 51,
            child: Container(
                decoration: BoxDecoration(
                  color: ThemeClass.whiteColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0,
                      blurRadius: 5,
                      offset: Offset(3, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: ThemeClass.whiteColor,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              data!.image.toString(),
                            ))),
                  ),
                )),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  _buildTitleName(
                      data.title.toString(), data.subTitle.toString()),
                  Text(
                    "Status",
                    style: TextStyle(
                        fontSize: 10,
                        color: ThemeClass.greyColor,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    data.status == "New" || data.status == "Pending"
                        ? "Pending"
                        : data.status.toString(),
                    style: TextStyle(
                        fontSize: 14,
                        color: data.status == "Completed"
                            ? ThemeClass.greenColor
                            : data.status == "Pending" ||
                                    data.status == "Accepted"
                                ? ThemeClass.orangeColor
                                : data.status == "Canceled" ||
                                        data.status == "Rejected"
                                    ? ThemeClass.redColor
                                    : ThemeClass.orangeColor,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 10),
                  Divider(
                    height: 0,
                  ),
                  data.isReviewSubmitted.toString() == "0"
                      ? Align(
                          alignment: Alignment.centerRight,
                          child: ButtonSmallWidget(
                              horizontalPadding: 15,
                              title: "Submit Review",
                              color: ThemeClass.blueColor,
                              callBack: () async {
                                var res = await pushNewScreen(
                                  context,
                                  screen: RatingScreen(
                                      isOrder: false,
                                      ownerId: data.ownerId.toString(),
                                      id: data.id.toString()),
                                  withNavBar: false,
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.cupertino,
                                );

                                if (res == true) {
                                  setState(() {});
                                }

                                // _submitr
                              }),
                        )
                      : SizedBox()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Wrap _buildTitleName(String name, String degree) {
    return Wrap(
      // ignore: prefer_const_literals_to_create_immutables
      children: [
        Text(
          name,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        degree == "" || degree == "Unknown"
            ? SizedBox()
            : Text(
                " - ($degree)",
                style: TextStyle(
                    fontSize: 14,
                    color: ThemeClass.blueColor,
                    fontWeight: FontWeight.w600),
              ),
      ],
    );
  }

  Container _buildbottomAmount(String amount, String tax) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildBottomAmountListTile(false, "GST 18%", "₹$tax"),
            _buildDivider(),
            _buildBottomAmountListTile(true, "Total Amount", "₹$amount"),
            _buildDivider()
          ],
        ),
      ),
    );
  }

  Padding _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Divider(
        thickness: 1,
        color: ThemeClass.greyLightColor1,
      ),
    );
  }

  Padding _buildBottomAmountListTile(bool isDark, String title, String title2) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? ThemeClass.blackColor : ThemeClass.greyColor,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            title2,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? ThemeClass.blackColor : ThemeClass.greyColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _launchURL(String _url) async {
    if (!_url.contains("http")) {
      try {
        if (!await launch("https://${_url}")) throw 'Could not launch $_url';
      } catch (e) {
        showToast("$_url");
        debugPrint(e.toString());
      }
    } else {
      try {
        if (!await launch("${_url}")) throw 'Could not launch $_url';
      } catch (e) {
        showToast("$_url");
        debugPrint(e.toString());
      }
    }
  }
}
