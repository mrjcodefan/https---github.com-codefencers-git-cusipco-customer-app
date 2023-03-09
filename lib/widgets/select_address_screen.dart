import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:heal_u/model/city_list_model.dart';
import 'package:heal_u/service/prowider/location_prowider_service.dart';
import 'package:heal_u/themedata.dart';
import 'package:heal_u/widgets/app_bars/appbar_with_location.dart';
import 'package:heal_u/widgets/app_bars/appbar_with_text.dart';
import 'package:heal_u/widgets/text_boxes/text_box_with_sufix.dart';
import 'package:provider/provider.dart';

class SelectAddressScreen extends StatefulWidget {
  SelectAddressScreen({Key? key}) : super(key: key);

  @override
  State<SelectAddressScreen> createState() => _SelectAddressScreenState();
}

class _SelectAddressScreenState extends State<SelectAddressScreen> {
  TextEditingController _searchController = TextEditingController();
  _filterList() {
    setState(() {
      displayCityList = globleCityList.where((e) {
        if (e.name!
            .toLowerCase()
            .contains(_searchController.text.toLowerCase())) {
          return true;
        } else {
          return false;
        }
      }).toList();
    });
  }

  List<CityList> globleCityList = [];
  List<CityList> displayCityList = [];

  @override
  void initState() {
    // TODO: implement initState
    var pro = Provider.of<LocationProwiderService>(context, listen: false);

    globleCityList = pro.globleCityList;
    displayCityList = pro.globleCityList;
    super.initState();
  }

  _closeKeyBoard() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  _selectCurrentCity() {}

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(65.0),
              child: AppBarWithTextAndBackWidget(
                onbackPress: () {
                  Navigator.pop(context);
                },
                title: " ",
              )),
          body: Container(
            color: ThemeClass.whiteColor,
            height: height,
            width: width,
            child: GestureDetector(
              onTap: () {
                _closeKeyBoard();
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                child: Column(
                  children: [
                    TextFiledWidget(
                      onChange: (value) {
                        _filterList();
                      },
                      backColor: ThemeClass.whiteDarkshadow,
                      hinttext: "Search Location",
                      controllers: _searchController,
                      radius: 10,
                      oniconTap: () {
                        _filterList();
                        _closeKeyBoard();
                      },
                      icon: "assets/images/search_icon.png",
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    displayCityList.isEmpty
                        ? Padding(
                            padding: EdgeInsets.only(top: height / 3),
                            child: Text(
                              "No Record Found!",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          )
                        : Expanded(
                            child: SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              child: Consumer<LocationProwiderService>(
                                  builder: (context, locationService, child) {
                                return Column(
                                  children: [
                                    ...displayCityList
                                        .map(
                                          (e) => Column(
                                            children: [
                                              ListTile(
                                                onTap: () {
                                                  locationService
                                                      .setCurrentCity(e);

                                                  EasyLoading.show();
                                                  Future.delayed(
                                                      Duration(seconds: 1), () {
                                                    EasyLoading.dismiss();
                                                    Navigator.pop(context);
                                                  });
                                                },
                                                title: Text(e.name.toString()),
                                                minVerticalPadding: 0,
                                                leading: Icon(
                                                    Icons.location_on_outlined),
                                              ),
                                              Divider()
                                            ],
                                          ),
                                        )
                                        .toList()
                                  ],
                                );
                              }),
                            ),
                          )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
