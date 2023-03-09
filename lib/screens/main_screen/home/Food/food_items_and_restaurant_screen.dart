import 'package:flutter/material.dart';
import 'package:heal_u/screens/main_screen/home/Food/food_item_list_widget.dart';
import 'package:heal_u/screens/main_screen/home/Food/resturent_list_widget.dart';
import 'package:heal_u/themedata.dart';
import 'package:heal_u/widgets/app_bars/appbar_with_location.dart';

class FoodItemsAndRestaurantScreen extends StatefulWidget {
  FoodItemsAndRestaurantScreen({Key? key, this.isshowToggle = true})
      : super(key: key);
  final bool isshowToggle;

  @override
  State<FoodItemsAndRestaurantScreen> createState() =>
      _FoodItemsAndRestaurantScreenState();
}

class _FoodItemsAndRestaurantScreenState
    extends State<FoodItemsAndRestaurantScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(length: 2, vsync: this);
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
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 50,
                    decoration: BoxDecoration(
                      color: ThemeClass.greyLightColor.withOpacity(0.45),
                      borderRadius: BorderRadius.circular(
                        25.0,
                      ),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          25.0,
                        ),
                        color: ThemeClass.blueColor,
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: ThemeClass.blueColor,
                      tabs: const [
                        Tab(
                          child: Text(
                            ' Food Items',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Restaurants  ',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        FoodListItemWidget(),
                        ResturentListItemWidget(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
