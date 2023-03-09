import 'package:flutter/material.dart';
import 'package:heal_u/screens/main_screen/home/skin_and_care/global_product_detail_screen.dart';
import 'package:heal_u/service/prowider/skincare_list_provider.dart';
import 'package:heal_u/widgets/app_bars/appbar_with_location.dart';
import 'package:heal_u/widgets/general_button.dart';
import 'package:heal_u/widgets/text_boxes/text_box_with_sufix.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../../../themedata.dart';

class SkincareListScreen extends StatefulWidget {
  final String id;
  const SkincareListScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<SkincareListScreen> createState() => _SkincareListScreenState();
}

class _SkincareListScreenState extends State<SkincareListScreen> {
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    Provider.of<SkincareListService>(context, listen: false)
        .getSkincareList(widget.id, _searchController.text, context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final model = Provider.of<SkincareListService>(context);
    return Container(
      color: ThemeClass.safeareBackGround,
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(65.0),
              child: AppBarWithLocationWidget(
                isBackShow: true,
                onbackPress: () {
                  Navigator.pop(context);
                },
              )),
          body: Container(
            color: ThemeClass.whiteColor,
            height: height,
            width: width,
            child: model.loading
                ? Center(
                    child:
                        CircularProgressIndicator(color: ThemeClass.blueColor),
                  )
                : Column(children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: TextFiledWidget(
                        backColor: ThemeClass.whiteDarkshadow,
                        hinttext: "Search",
                        controllers: _searchController,
                        radius: 10,
                        icon: "assets/images/search_icon.png",
                        onChange: (text) {
                          Provider.of<SkincareListService>(context,
                                  listen: false)
                              .getSkincareList(
                                  widget.id, _searchController.text,
                                  context: context);
                        },
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: model.skinListModel.data.length,
                          itemBuilder: (context, index) {
                            return _buildMenuItemListTile(width, index, model);
                          }),
                    )
                  ]),
          ),
        ),
      ),
    );
  }

  Padding _buildMenuItemListTile(
      double width, int index, SkincareListService model) {
    final data = model.skinListModel.data[index];
    return Padding(
      padding: EdgeInsets.only(
          bottom: 10, top: index == 0 ? 15 : 0, right: 10, left: 10),
      child: TextButtonWidget(
        onPressed: () {
          pushNewScreen(
            context,
            screen: GlobalProductdetails(
              id: data.id,
              urlPerameter: "SkinCare",
              title: data.title.toString(),
            ),
            withNavBar: true,
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
                    color: Colors.red,
                    image: DecorationImage(
                      image: NetworkImage(data.image.toString()),
                      fit: BoxFit.cover,
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
                        data.title.toString(),
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        data.owner.toString(),
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 12,
                            color: ThemeClass.greyColor,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        "₹${data.price}",
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 12,
                            color: ThemeClass.blueColor,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.star,
                        color: ThemeClass.blueColor,
                      ),
                      Text(
                        data.rating,
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 16,
                            color: ThemeClass.blueColor,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: ThemeClass.greyLightColor1,
            )
          ],
        ),
      ),
    );
  }
}
