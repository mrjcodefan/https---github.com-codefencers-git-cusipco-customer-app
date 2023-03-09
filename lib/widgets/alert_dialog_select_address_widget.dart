import 'package:flutter/material.dart';
import 'package:heal_u/model/get_address_model.dart';
import 'package:heal_u/pages/add_address_screen.dart';
import 'package:heal_u/service/prowider/get_address_provider.dart';
import 'package:heal_u/themedata.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class AlertDialogSelectAddress extends StatefulWidget {
  const AlertDialogSelectAddress({Key? key}) : super(key: key);

  @override
  State<AlertDialogSelectAddress> createState() =>
      _AlertDialogSelectAddressState();
}

class _AlertDialogSelectAddressState extends State<AlertDialogSelectAddress> {
  String radioAddressGroupValue = "addressRadioGP";
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer<GetAddressService>(builder: (context, address, child) {
        if (address.loading) {
          return Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Center(
                  child: CircularProgressIndicator(
                color: ThemeClass.blueColor,
              )));
        } else {
          if (address.getAddressModel != null) {
            if (address.getAddressModel!.data.isNotEmpty) {
              return Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: SingleChildScrollView(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    ...address.getAddressModel!.data
                        .map((e) => _buildAddressListTile1(
                            e, address.getAddressModel!.data))
                        .toList(),
                  ]),
                ),
              );
            } else {
              return _buildAddAddress(context);
              // return ;
            }
          } else {
            return _buildAddAddress(context);
          }
        }
      }),
    );
  }

  Container _buildAddAddress(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.5,
      ),
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text("address not found!"),
        SizedBox(
          height: 30,
        ),
        _buildAddPlanButton(context),
        SizedBox(
          height: 10,
        ),
        Text(
          "Add New Address",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ]),
    );
  }

  InkWell _buildAddPlanButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        pushNewScreen(
          context,
          screen: AddAddressScreen(),
          withNavBar: false,
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
      },
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: ThemeClass.blueColor, width: 2),
        ),
        child: Center(
          child: Icon(
            Icons.add_rounded,
            size: 40,
            color: ThemeClass.blueColor,
          ),
        ),
      ),
    );
  }

  Column _buildAddressListTile1(AddressData data, List<AddressData> list) {
    var index = list.indexOf(data);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              radioAddressGroupValue = data.id.toString();
            });
            Navigator.pop(context, data);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
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
                flex: 6,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.name.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        color: ThemeClass.blackColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      data.address.toString(),
                      style: TextStyle(
                        fontSize: 10,
                        color: ThemeClass.greyColor,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 40,
                width: 40,
                child: Radio(
                  value: data.id.toString(),
                  activeColor: ThemeClass.blueColor,
                  fillColor: MaterialStateProperty.all(ThemeClass.blueColor),
                  groupValue: radioAddressGroupValue,
                  onChanged: (value) {
                    setState(() {
                      radioAddressGroupValue = value.toString();
                    });
                    Navigator.pop(context, data);
                  },
                ),
              ),
            ],
          ),
        ),
        list.length != index + 1 ? _buildDivider() : SizedBox()
      ],
    );
  }

  Padding _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Divider(
        thickness: 1,
        color: ThemeClass.greyLightColor1,
      ),
    );
  }
}
