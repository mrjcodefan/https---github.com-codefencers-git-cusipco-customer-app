import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:heal_u/model/get_address_model.dart';
import 'package:heal_u/pages/add_address_screen.dart';
import 'package:heal_u/service/address_services/remove_address_services.dart';
import 'package:heal_u/service/navigation_service.dart';
import 'package:heal_u/service/prowider/get_address_provider.dart';

import 'package:heal_u/themedata.dart';
import 'package:heal_u/widgets/app_bars/appbar_with_text.dart';
import 'package:heal_u/widgets/button_widget/rounded_button_widget.dart';

import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class ManageAddressScreen extends StatefulWidget {
  ManageAddressScreen({Key? key}) : super(key: key);

  @override
  State<ManageAddressScreen> createState() => _ManageAddressScreenState();
}

class _ManageAddressScreenState extends State<ManageAddressScreen> {
  @override
  void initState() {
    Provider.of<GetAddressService>(context, listen: false).getAddressData();
    super.initState();
  }

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 500));
    Provider.of<GetAddressService>(context, listen: false).getAddressData();
  }

  @override
  Widget build(BuildContext context) {
    final addressDetails = Provider.of<GetAddressService>(context);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
      color: ThemeClass.safeareBackGround,
      child: SafeArea(
        child: Scaffold(
          // resizeToAvoidBottomInset: false, // th
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(65.0),
              child: AppBarWithTextAndBackWidget(
                onbackPress: () {
                  Navigator.pop(context);
                },
                title: "Manage Address",
              )),
          body: Container(
            color: ThemeClass.whiteColor,
            height: height,
            width: width,
            child: Stack(
              children: [
                addressDetails.loading
                    ? Center(
                        child: CircularProgressIndicator(
                            color: ThemeClass.blueColor),
                      )
                    : addressDetails.isError
                        ? Center(
                            child: Text(addressDetails.errorMessage),
                          )
                        : SizedBox(
                            height: height / 1.4,
                            child: SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              child: Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: addressDetails
                                          .getAddressModel!.data.length,
                                      itemBuilder: (context, index) {
                                        return _buildAddressListTile1(
                                            addressDetails, index, context);
                                      })),
                            ),
                          ),
                _buildBottomButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column _buildAddressListTile1(GetAddressService model, int index, context) {
    final data = model.getAddressModel!.data[index];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(data.addressType == "Home"
                        ? 'assets/images/home_icon.png'
                        : 'assets/images/office_icon.png'),
                    fit: BoxFit.cover,
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
                    data.name,
                    style: TextStyle(
                      fontSize: 14,
                      color: ThemeClass.blackColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    data.address,
                    style: TextStyle(
                      fontSize: 10,
                      color: ThemeClass.greyColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        "Number",
                        style: TextStyle(
                          fontSize: 12,
                          color: ThemeClass.greyColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        data.phoneNumber,
                        style: TextStyle(
                          fontSize: 12,
                          color: ThemeClass.blueColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: PopupMenuButton<String>(
                onSelected: (value) =>
                    choiceAction(value, context, data, model, index),
                itemBuilder: (BuildContext context) {
                  return {'Delete', 'Edit'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Column(
                        children: [
                          Text(choice),
                        ],
                      ),
                    );
                  }).toList();
                },
              ),
            )
          ],
        ),
        _buildDivider()
      ],
    );
  }

  void choiceAction(String choice, BuildContext context, AddressData data,
      model, index) async {
    print("--------------------------------$choice");

    if (choice == "Delete") {
      _deleteData(data, model, index);
    } else {
      // pushNewScreen(
      //   context,
      //   screen: AddAddressScreen(isEdit: true, addressData: data),
      //   withNavBar: false,
      //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
      // );

      var data1 = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                AddAddressScreen(isEdit: true, addressData: data)),
      );

      if (data1 != null) {
        _onRefresh();
      }
    }
  }

  _deleteData(data, model, index) async {
    EasyLoading.show();
    try {
      await removeAddress(data.id, context: context).then((value) {
        if (value == "true") {
          model.getAddressModel!.data.removeAt(index);
          _onRefresh();
        }
      });
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      EasyLoading.dismiss();
    }
  }

  Padding _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Divider(
        thickness: 1,
        color: ThemeClass.greyLightColor1,
      ),
    );
  }

  Align _buildBottomButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: 15,
        ),
        height: 110,
        child: ButtonWidget(
          title: "Add New Address",
          color: ThemeClass.blueColor,
          callBack: () {
            // Navigator.pop(context);

            pushNewScreen(
              context,
              screen: AddAddressScreen(),
              withNavBar: true,
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          },
        ),
      ),
    );
  }
}
