import 'package:flutter/material.dart';

import 'package:heal_u/screens/main_screen/home/store/store_product_details_model.dart';
import 'package:heal_u/screens/main_screen/home/store/store_product_details_screen.dart';

import 'package:heal_u/themedata.dart';

import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class ProductSellerListTile extends StatefulWidget {
  ProductSellerListTile({Key? key, required this.seller}) : super(key: key);

  final Seller seller;

  @override
  State<ProductSellerListTile> createState() => _ProductSellerListTileState();
}

class _ProductSellerListTileState extends State<ProductSellerListTile> {
  String isShowCart = "";

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    isShowCart = widget.seller.isCart.toString() == ""
        ? "0"
        : widget.seller.isCart.toString();
  }

  // _addToCart() async {
  //   EasyLoading.show();

  //   try {
  //     Map<String, String> queryParameters = {
  //       "product_id": widget.seller.id.toString(),
  //       "clear_cart": "0",
  //       "quantity": "1",
  //       "variation_id": widget.seller.variationId.toString()
  //     };

  //     var response = await HttpService.httpPost("addToCart", queryParameters,
  //         context: context);

  //     if (response.statusCode == 201 || response.statusCode == 200) {
  //       var res = jsonDecode(response.body);

  //       if (res['success'].toString() == "1" &&
  //           res['status'].toString() == "200") {
  //         var provider1 =
  //             Provider.of<CardProviderService>(context, listen: false);
  //         await provider1.getCart();
  //         showToast(res['message']);

  //         setState(() {
  //           int tempCartItem = int.parse(isShowCart);
  //           tempCartItem = tempCartItem + 1;
  //           isShowCart = tempCartItem.toString();
  //         });
  //       } else {
  //         showToast(res['message']);
  //       }
  //     } else if (response.statusCode == 401) {
  //       showToast(GlobalVariableForShowMessage.unauthorizedUser);
  //       await UserPrefService().removeUserData();
  //       NavigationService().navigatWhenUnautorized();
  //     } else {
  //       showToast(GlobalVariableForShowMessage.somethingwentwongMessage);
  //     }
  //   } catch (e) {
  //     if (e is SocketException) {
  //       showToast(GlobalVariableForShowMessage.socketExceptionMessage);
  //     } else if (e is TimeoutException) {
  //       showToast(GlobalVariableForShowMessage.timeoutExceptionMessage);
  //     } else {
  //       showToast(e.toString());
  //     }
  //   } finally {
  //     EasyLoading.dismiss();
  //   }
  // }

  // _updateCart(String quntiy) async {
  //   EasyLoading.show();

  //   if (quntiy == "0") {
  //     try {
  //       Map<String, String> queryParameters = {
  //         "product_id": widget.seller.id.toString(),
  //       };

  //       var response = await HttpService.httpPost("deleteCart", queryParameters,
  //           context: context);

  //       if (response.statusCode == 201 || response.statusCode == 200) {
  //         var res = jsonDecode(response.body);

  //         if (res['success'].toString() == "1" &&
  //             res['status'].toString() == "200") {
  //           var provider1 =
  //               Provider.of<CardProviderService>(context, listen: false);
  //           await provider1.getCart();
  //           showToast(res['message']);

  //           setState(() {
  //             isShowCart = quntiy;
  //           });
  //         } else {
  //           showToast(res['message']);
  //         }
  //       } else if (response.statusCode == 401) {
  //         showToast(GlobalVariableForShowMessage.unauthorizedUser);
  //         await UserPrefService().removeUserData();
  //         NavigationService().navigatWhenUnautorized();
  //       } else {
  //         showToast(GlobalVariableForShowMessage.somethingwentwongMessage);
  //       }
  //     } catch (e) {
  //       if (e is SocketException) {
  //         showToast(GlobalVariableForShowMessage.socketExceptionMessage);
  //       } else if (e is TimeoutException) {
  //         showToast(GlobalVariableForShowMessage.timeoutExceptionMessage);
  //       } else {
  //         showToast(e.toString());
  //       }
  //     } finally {
  //       EasyLoading.dismiss();
  //     }
  //   } else {
  //     try {
  //       Map<String, String> queryParameters = {
  //         "product_id": widget.seller.id.toString(),
  //         "clear_cart": "0",
  //         "quantity": quntiy,
  //         "variation_id": widget.seller.variationId.toString()
  //       };

  //       var response = await HttpService.httpPost("updateCart", queryParameters,
  //           context: context);

  //       if (response.statusCode == 201 || response.statusCode == 200) {
  //         var res = jsonDecode(response.body);

  //         if (res['success'].toString() == "1" &&
  //             res['status'].toString() == "200") {
  //           var provider1 =
  //               Provider.of<CardProviderService>(context, listen: false);
  //           await provider1.getCart();
  //           showToast(res['message']);

  //           setState(() {
  //             isShowCart = quntiy;
  //           });
  //         } else {
  //           showToast(res['message']);
  //         }
  //       } else if (response.statusCode == 401) {
  //         showToast(GlobalVariableForShowMessage.unauthorizedUser);
  //         await UserPrefService().removeUserData();
  //         NavigationService().navigatWhenUnautorized();
  //       } else {
  //         showToast(GlobalVariableForShowMessage.somethingwentwongMessage);
  //       }
  //     } catch (e) {
  //       if (e is SocketException) {
  //         showToast(GlobalVariableForShowMessage.socketExceptionMessage);
  //       } else if (e is TimeoutException) {
  //         showToast(GlobalVariableForShowMessage.timeoutExceptionMessage);
  //       } else {
  //         showToast(e.toString());
  //       }
  //     } finally {
  //       setState(() {
  //         EasyLoading.dismiss();
  //       });
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () {
          pushNewScreen(
            context,
            screen: StoreProductDetailsScreen(id: widget.seller.id.toString()),
            withNavBar: false,
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        },
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: width * 0.2,
                  height: width * 0.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    image: DecorationImage(
                      image: NetworkImage(widget.seller.image.toString()),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.seller.title.toString(),
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        widget.seller.variation.toString(),
                        style: TextStyle(
                            fontSize: 12,
                            color: ThemeClass.greyColor,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        "Sold by : ${widget.seller.soldBy.toString()}",
                        style: TextStyle(
                            fontSize: 12,
                            color: ThemeClass.blueColor,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Text(
                        "₹${widget.seller.price.toString()}",
                        style: TextStyle(
                            // overflow: TextOverflow.ellipsis,
                            fontSize: 14,
                            color: ThemeClass.blueColor,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
