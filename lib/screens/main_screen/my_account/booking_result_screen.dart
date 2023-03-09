import 'package:flutter/material.dart';
import 'package:heal_u/screens/main_screen/my_account/my_appointment/appointments_screen.dart';
import 'package:heal_u/themedata.dart';
import 'package:heal_u/widgets/app_bars/appbar_with_text.dart';
import 'package:heal_u/widgets/button_widget/rounded_button_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class BookingResultScreen extends StatelessWidget {
  final bool success;
  const BookingResultScreen({Key? key, required this.success})
      : super(key: key);

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
            title: success == true
                ? "Booking Successful"
                : "Booking Unsuccessfull",
          )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            success == true
                ? Image.asset('assets/images/booking_success.png')
                : Image.asset('assets/images/booking_unsuccess.png'),
            SizedBox(
              height: 20,
            ),
            Text(
              success == true ? 'Booking Successful' : 'Booking Failed',
              style: TextStyle(
                  color: ThemeClass.blueColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              success == true
                  ? "Kudos! Your booking is complete. Welcome to HealU community!"
                  : "Oops! We couldn't complete your order. Sorry for the inconvenience.",
              style: TextStyle(
                color: ThemeClass.greyColor,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            success == true
                ? ButtonWidget(
                    title: 'Check Appointments',
                    color: ThemeClass.blueColor,
                    callBack: () {
                      pushNewScreen(context, screen: AppointmentsScreen());
                    })
                : ButtonWidget(
                    title: 'Book Again',
                    color: ThemeClass.blueColor,
                    callBack: () {
                      Navigator.pop(context);
                    })
          ],
        ),
      ),
    );
  }
}
