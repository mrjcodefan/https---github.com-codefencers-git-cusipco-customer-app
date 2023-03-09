import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:heal_u/screens/main_screen/home/Doctor/schedule_booking_screen.dart';
import 'package:heal_u/service/prowider/doctor_details_provider.dart';
import 'package:heal_u/themedata.dart';
import 'package:heal_u/widgets/app_bars/appbar_with_text.dart';
import 'package:heal_u/widgets/button_widget/rounded_button_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class AboutDoctorScreen extends StatefulWidget {
  final String id;
  final String mode;
  const AboutDoctorScreen({
    Key? key,
    required this.id,
    required this.mode,
  }) : super(key: key);

  @override
  State<AboutDoctorScreen> createState() => _AboutDoctorScreenState();
}

class _AboutDoctorScreenState extends State<AboutDoctorScreen> {
  CarouselController buttonCarouselController = CarouselController();

  @override
  void initState() {
    super.initState();
    Provider.of<DoctorsDetailsServices>(context, listen: false)
        .getDoctorDetails(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<DoctorsDetailsServices>(context);
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
                title: "About Doctor",
              )),
          body: Container(
              color: ThemeClass.whiteColor,
              height: height,
              width: width,
              child: model.loading
                  ? Center(
                      child: CircularProgressIndicator(
                          color: ThemeClass.blueColor),
                    )
                  : model.isError
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              model.errorMessage,
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                _buildImageWithDetails(model),
                                SizedBox(
                                  height: 15,
                                ),
                                Divider(
                                  thickness: 1,
                                  color: ThemeClass.greyLightColor1,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Center(
                                    child: Text(
                                  "About Me",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: ThemeClass.blackColor,
                                      fontWeight: FontWeight.w600),
                                )),
                                SizedBox(
                                  height: 20,
                                ),
                                Center(
                                    child: Text(
                                  model.doctorDetailsModel!.data.bio,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: ThemeClass.greyColor,
                                      fontWeight: FontWeight.w400),
                                )),
                                SizedBox(
                                  height: 40,
                                ),
                                ButtonWidget(
                                    title: "Book a Schedule",
                                    color: ThemeClass.blueColor,
                                    callBack: () {
                                      pushNewScreen(
                                        context,
                                        screen: ScheduleBooking(
                                            mode: widget.mode,
                                            id: widget.id,
                                            doctorDetailsModel:
                                                model.doctorDetailsModel!),
                                        withNavBar: false,
                                        pageTransitionAnimation:
                                            PageTransitionAnimation.cupertino,
                                      );
                                    }),
                                SizedBox(
                                  height: 40,
                                ),
                              ],
                            ),
                          ),
                        )),
        ),
      ),
    );
  }

  Row _buildImageWithDetails(DoctorsDetailsServices model) {
    final data = model.doctorDetailsModel!.data;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 55,
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
                            data.image,
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
                _buildTitleName(
                    data.title.toString(), data.qualification.toString()),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Category",
                  style: TextStyle(
                      fontSize: 10,
                      color: ThemeClass.greyColor,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  data.speciality,
                  style: TextStyle(
                      fontSize: 14,
                      color: ThemeClass.blueColor,
                      fontWeight: FontWeight.w600),
                ),
                Divider(),
                Text(
                  "Licence Number",
                  style: TextStyle(
                      fontSize: 10,
                      color: ThemeClass.greyColor,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  data.licenseId,
                  style: TextStyle(
                      fontSize: 14,
                      color: ThemeClass.blueColor,
                      fontWeight: FontWeight.w600),
                ),
                Divider(),
                Text(
                  "Language Know",
                  style: TextStyle(
                      fontSize: 10,
                      color: ThemeClass.greyColor,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  data.language.toString(),
                  style: TextStyle(
                      fontSize: 14,
                      color: ThemeClass.blueColor,
                      fontWeight: FontWeight.w600),
                ),
                Divider(),
                RatingBar.builder(
                  ignoreGestures: true,
                  initialRating: double.parse(data.rating),
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  unratedColor: ThemeClass.greyLightColor,
                  itemPadding: EdgeInsets.only(right: 2.0),
                  itemSize: 22,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: ThemeClass.blueColor,
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildTitleName(String name, String degree) {
    return SizedBox(
        child: RichText(
      text: TextSpan(
        text: name,
        style: TextStyle(
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: ThemeClass.blackColor),
        children: <TextSpan>[
          TextSpan(
            text: " - ($degree)",
            style: TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins',
                overflow: TextOverflow.ellipsis,
                color: ThemeClass.blueColor,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    )

        //  Row(
        //   // ignore: prefer_const_literals_to_create_immutables
        //   children: [
        //     Text(
        //       name,
        //       style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        //     ),
        //     Text(
        //       " - ($degree)",

        //       style: TextStyle(
        //           fontSize: 14,
        //           overflow: TextOverflow.ellipsis,
        //           color: ThemeClass.blueColor,
        //           fontWeight: FontWeight.w600),
        //     ),
        //   ],
        // ),
        );
  }
}
