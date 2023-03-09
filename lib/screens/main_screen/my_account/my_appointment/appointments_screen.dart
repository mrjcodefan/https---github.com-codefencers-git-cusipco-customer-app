import 'package:flutter/material.dart';
import 'package:heal_u/Global/globle_methd.dart';

import 'package:heal_u/screens/main_screen/my_account/my_appointment/appointment_detail_screen.dart';
import 'package:heal_u/service/prowider/get_appo_list_provider.dart';

import 'package:heal_u/themedata.dart';
import 'package:heal_u/widgets/app_bars/appbar_with_text.dart';

import 'package:heal_u/widgets/button_widget/small_blue_button_widget.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  @override
  void initState() {
    Provider.of<GetAppoServices>(context, listen: false).getAppointment();
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
                isShowCart: true,
                onbackPress: () {
                  Navigator.pop(context);
                },
                title: "Appointments",
              )),
          body: Consumer<GetAppoServices>(builder: (context, model, child) {
            return Container(
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
                          child: Text(model.errorMessage),
                        )
                      : model.getAppoModel!.data.isEmpty
                          ? Center(
                              child: Text('There are no appointments'),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, left: 8, bottom: 8),
                              child: ListView.builder(
                                  itemCount: model.getAppoModel!.data.length,
                                  itemBuilder: (context, index) {
                                    return _buildCard(model, index);
                                  }),
                            ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildCard(GetAppoServices model, index) {
    final data = model.getAppoModel!.data[index];

    var actualData = data.date.toString();

    DateTime tempDate1 = new DateFormat("yyyy-MM-dd").parse(actualData);
    var tempDate = new DateFormat("dd MM,yyyy").format(tempDate1);

    var tempTime = time24to12Format(data.time.toString());
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          pushNewScreen(
            context,
            screen: AppointmentDetailsScreen(id: data.id.toString()),
            withNavBar: true,
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        },
        child: Row(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            Expanded(
              flex: 3,
              child: CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage(data.image),
              ),
            ),
            Expanded(
              flex: 7,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    data.subTitle == "" || data.subTitle == "Unknown"
                        ? SizedBox()
                        : Text(
                            data.subTitle,
                            style: TextStyle(
                              fontSize: 12,
                              color: ThemeClass.greyDarkColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tempDate.toString(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    tempTime,
                    style: TextStyle(
                      fontSize: 12,
                      color: ThemeClass.greyDarkColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            SizedBox(
              child: ButtonSmallWidget(
                  fontSize: 8,
                  verticalPadding: 5,
                  horizontalPadding: 2,
                  title: data.status == "New" || data.status == "Pending"
                      ? "Pending"
                      : data.status,
                  callBack: () {},
                  color: data.status == "Completed"
                      ? ThemeClass.greenColor
                      : data.status == "Pending" || data.status == "Accepted"
                          ? ThemeClass.orangeColor
                          : data.status == "Canceled" ||
                                  data.status == "Rejected"
                              ? ThemeClass.redColor
                              : ThemeClass.orangeColor),
            )
          ],
        ),
      ),
    );
  }
}
