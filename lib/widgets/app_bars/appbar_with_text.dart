import 'package:flutter/material.dart';
import 'package:heal_u/screens/main_screen/cart/cart_prowider_service.dart';
import 'package:heal_u/screens/main_screen/cart/cart_screen.dart';
import 'package:heal_u/themedata.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class AppBarWithTextAndBackWidget extends StatelessWidget {
  const AppBarWithTextAndBackWidget(
      {Key? key,
      required this.title,
      this.isShowCart = false,
      this.isClickOnCart = true,
      this.onCartPress,
      required this.onbackPress})
      : super(key: key);

  final String title;
  final Function onbackPress;
  final bool isShowCart;
  final bool isClickOnCart;

  final Function? onCartPress;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ThemeClass.blueColor,
      toolbarHeight: 70,
      leading: IconButton(
        onPressed: () {
          onbackPress();
        },
        icon: Icon(Icons.arrow_back),
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
      ),
      actions: [
        isShowCart
            ? InkWell(
                splashFactory: NoSplash.splashFactory,
                onTap: () {
                  if (isClickOnCart) {
                    pushNewScreen(
                      context,
                      screen: CartScreen(),
                      withNavBar: false,
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino,
                    );
                  }
                  // onCartPress!();
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
                                  child: Text(initdataService
                                      .cartData!.items!.length
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
            : SizedBox(),
      ],
    );
  }
}
