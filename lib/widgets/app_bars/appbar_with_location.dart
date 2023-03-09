import 'package:flutter/material.dart';
import 'package:heal_u/screens/main_screen/cart/cart_prowider_service.dart';
import 'package:heal_u/screens/main_screen/cart/cart_screen.dart';
import 'package:heal_u/service/prowider/location_prowider_service.dart';
import 'package:heal_u/themedata.dart';
import 'package:heal_u/widgets/select_address_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class AppBarWithLocationWidget extends StatefulWidget {
  const AppBarWithLocationWidget(
      {Key? key, this.isBackShow = false, this.onbackPress})
      : super(key: key);

  final bool isBackShow;
  final Function? onbackPress;

  @override
  State<AppBarWithLocationWidget> createState() =>
      _AppBarWithLocationWidgetState();
}

class _AppBarWithLocationWidgetState extends State<AppBarWithLocationWidget> {
  @override
  void initState() {
    super.initState();
  }

  String? dropdownvalue;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ThemeClass.blackColor,
      toolbarHeight: 70,
      centerTitle: false,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          widget.isBackShow
              ? IconButton(
                  onPressed: () {
                    if (widget.isBackShow) {
                      widget.onbackPress!();
                    }
                  },
                  icon: Icon(Icons.arrow_back),
                )
              : SizedBox(),
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Container(
              height: 25,
              width: 25,
              child: Image.asset(
                "assets/images/location_wihte_icon.png",
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Consumer<LocationProwiderService>(
              builder: (context, locationService, child) {
            return InkWell(
              onTap: () {
                pushNewScreen(
                  context,
                  screen: SelectAddressScreen(),
                  withNavBar: false,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
              child: Text(
                locationService.currentLocationCity == null
                    ? "Select City"
                    : locationService.currentLocationCity!.name.toString(),
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: ThemeClass.whiteColor),
              ),
            );
          }),
        ],
      ),
      actions: [
        InkWell(
          onTap: () {
            // onCartPress!();
            pushNewScreen(
              context,
              screen: CartScreen(),
              withNavBar: false,
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 0),
            child: Stack(
              children: [
                Align(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Image.asset(
                      "assets/images/cart_wihte_icon.png",
                      height: 30,
                      width: 30,
                    ),
                  ),
                ),
                Positioned(
                  top: 17,
                  right: 17,
                  child: Consumer<CardProviderService>(
                      builder: (context, initdataService, child) {
                    if (initdataService.cartData != null &&
                        initdataService.cartData!.items != null &&
                        initdataService.cartData!.items!.isNotEmpty) {
                      return Container(
                        padding: EdgeInsets.all(2),
                        height: 17,
                        width: 17,
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: FittedBox(
                            child: Text(initdataService.cartData!.items!.length
                                .toString()),
                          ),
                        ),
                      );
                    } else {
                      return Text("");
                    }
                  }),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
