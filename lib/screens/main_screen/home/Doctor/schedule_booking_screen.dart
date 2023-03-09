import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:heal_u/Global/global_variable_for_show_messge.dart';
import 'package:heal_u/Global/web_view_screen.dart';
import 'package:heal_u/model/book_appo_model.dart';
import 'package:heal_u/model/doctors_detail_model.dart';
import 'package:heal_u/screens/main_screen/checkout/checkout_for_other.dart';

import 'package:heal_u/screens/main_screen/my_account/booking_result_screen.dart';
import 'package:heal_u/service/book_appo_services.dart';
import 'package:heal_u/service/time_slot_service/time_slot_model.dart';
import 'package:heal_u/service/time_slot_service/time_slot_service.dart';

import 'package:heal_u/themedata.dart';
import 'package:heal_u/widgets/app_bars/appbar_with_text.dart';
import 'package:heal_u/widgets/button_widget/rounded_button_widget.dart';
import 'package:heal_u/widgets/general_widget.dart';
import 'package:heal_u/widgets/text_boxes/text_box_with_sufix.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class ScheduleBooking extends StatefulWidget {
  final String id;
  final DoctorDetailsModel? doctorDetailsModel;
  final String mode;

  const ScheduleBooking({
    Key? key,
    required this.mode,
    required this.doctorDetailsModel,
    required this.id,
  }) : super(key: key);

  @override
  State<ScheduleBooking> createState() => _ScheduleBookingState();
}

class _ScheduleBookingState extends State<ScheduleBooking> {
  CarouselController buttonCarouselController = CarouselController();
  String? time;
  int? select;

  final TextEditingController _dateController = TextEditingController();

  DateTime currentDate = DateTime.now().add(Duration(days: 1));

  @override
  void initState() {
    setInitalDate();
    super.initState();
  }

  setInitalDate() {
    _dateController.text = DateFormat('yyyy-MM-dd').format(currentDate);
    Provider.of<TimeSlotService>(context, listen: false).getTimeSlot(
        id: widget.id,
        date: _dateController.text,
        context: context,
        mode: widget.mode);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime.now().add(Duration(days: 1)),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: ThemeClass.blueColor, // <-- SEE HERE
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: ThemeClass.blueColor, // button text color
                ),
              ),
            ),
            child: child!,
          );
        },
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
        currentDate = pickedDate;
        _dateController.text = formattedDate;
        select = null;
        time = null;
      });

      setInitalDate();
    }
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
                title: "Schedule Booking ",
              )),
          body: Container(
              color: ThemeClass.whiteColor,
              height: height,
              width: width,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Center(child: _buildImageWithDetails()),
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                              child: Text(
                            widget.doctorDetailsModel!.data.title.toString(),
                            style: TextStyle(
                                fontSize: 14,
                                color: ThemeClass.blackColor,
                                fontWeight: FontWeight.w600),
                          )),
                          Center(
                              child: Text(
                            widget.doctorDetailsModel!.data.speciality
                                .toString(),
                            style: TextStyle(
                                fontSize: 12,
                                color: ThemeClass.greyColor,
                                fontWeight: FontWeight.w400),
                          )),
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
                          Text(
                            "Select a Date",
                            style: TextStyle(
                              fontSize: 14,
                              color: ThemeClass.blueColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFiledWidget(
                            backColor: ThemeClass.greyColorBackgorund,
                            oniconTap: () {
                              //  print("object");
                              _selectDate(context);
                            },
                            hinttext: "Date",
                            controllers: _dateController,
                            icon: "assets/images/calender_icon.png",
                            isClickable: true,
                            isReadOnly: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return GlobalVariableForShowMessage
                                        .EmptyErrorMessage +
                                    "Date";
                              }
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Select a Slot",
                            style: TextStyle(
                              fontSize: 14,
                              color: ThemeClass.blueColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 500,
                            child: Consumer<TimeSlotService>(
                                builder: (context, TimeSlotService, child) {
                              if (TimeSlotService.isLoading == true) {
                                return Align(
                                  alignment: Alignment.topCenter,
                                  child: CircularProgressIndicator(
                                    color: ThemeClass.blueColor,
                                  ),
                                );
                              }

                              if (TimeSlotService.isError) {
                                return Align(
                                    alignment: Alignment.topCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Text(TimeSlotService.errorMessage,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500)),
                                    ));
                              }

                              if (TimeSlotService.timeSlotList.isEmpty) {
                                return Align(
                                  alignment: Alignment.topCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 50),
                                    child: Text("No Slots Availalble",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500)),
                                  ),
                                );
                              }

                              return SizedBox(
                                child: GridView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount:
                                        TimeSlotService.timeSlotList.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 4,
                                            crossAxisSpacing: 5,
                                            mainAxisSpacing: 5,
                                            childAspectRatio: 4 / 1.8),
                                    itemBuilder: (context, index) {
                                      return _buildTrainerBox(
                                          TimeSlotService.timeSlotList, index);
                                    }),
                              );
                            }),
                          )
                        ],
                      ),
                    ),
                  ),
                  _buildBottomButton(),
                ],
              )),
        ),
      ),
    );
  }

  Align _buildBottomButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 15),
        height: 80,
        child: ButtonWidget(
          title: "Book a Schedule",
          color: ThemeClass.blueColor,
          callBack: () async {
            _submit();
          },
        ),
      ),
    );
  }

  _submit() async {
    if (_dateController.text.isNotEmpty && time != null) {
      pushNewScreen(
        context,
        screen: CheckoutForOtherScreen(
          moduleView: 1,
          id: widget.id.toString(),
          payableAmount:
              widget.doctorDetailsModel!.data.payableAmount.toString(),
          chanrges: widget.doctorDetailsModel!.data.charges.toString(),
          date: _dateController.text.toString(),
          module: "Doctor",
          tax: widget.doctorDetailsModel!.data.tax.toString(),
          time: time.toString(),
          name: widget.doctorDetailsModel!.data.title.toString(),
          mode: widget.mode.toString(),
        ),
        withNavBar: false,
        pageTransitionAnimation: PageTransitionAnimation.cupertino,
      );
    } else {
      showToast("Please select both Date & Time");
    }
  }

  InkWell _buildTrainerBox(List<TimeSlot> timing, int index) {
    final data = timing[index];
    return InkWell(
      onTap: () {
        setState(() {
          select = index;
          time = data.slug;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: select == index
              ? ThemeClass.blueColor
              : ThemeClass.greyColorBackgorund,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              data.title.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontSize: 10,
                  color: select == index
                      ? ThemeClass.whiteColor
                      : ThemeClass.greyColor,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }

  CircleAvatar _buildImageWithDetails() {
    return CircleAvatar(
      // backgroundImage: NetworkImage(
      //     "https://images.unsplash.com/photo-1482049016688-2d3e1b311543?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Nnx8Zm9vZHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60"),
      radius: 50,
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
                        widget.doctorDetailsModel!.data.image.toString(),
                      ))),
            ),
          )),
    );
  }
}
