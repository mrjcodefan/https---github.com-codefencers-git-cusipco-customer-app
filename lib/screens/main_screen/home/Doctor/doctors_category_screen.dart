import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:heal_u/screens/main_screen/home/Doctor/doctor_list_screen.dart';
import 'package:heal_u/service/animation_service.dart';
import 'package:heal_u/service/prowider/doctor_category_provider.dart';
import 'package:heal_u/widgets/app_bars/appbar_with_text.dart';
import 'package:heal_u/widgets/online_offline_bottom_sheet.dart';

import 'package:heal_u/widgets/slider_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../../../themedata.dart';

class DoctorsCategoryScreen extends StatefulWidget {
  const DoctorsCategoryScreen({Key? key}) : super(key: key);

  @override
  State<DoctorsCategoryScreen> createState() => _DoctorsCategoryScreenState();
}

class _DoctorsCategoryScreenState extends State<DoctorsCategoryScreen> {
  @override
  void initState() {
    Provider.of<DoctorsCategoryService>(context, listen: false)
        .getDoctorsCategory(context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<DoctorsCategoryService>(context);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      color: ThemeClass.safeareBackGround,
      child: SafeArea(
          child: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(65.0),
            child: AppBarWithTextAndBackWidget(
              onbackPress: () {
                Navigator.pop(context);
              },
              title: "Doctor Categories",
              isShowCart: true,
            )),
        body: Container(
          color: ThemeClass.whiteColor,
          height: height,
          width: width,
          child: Column(
            children: [
              SliderWidget(
                type: "ConsultWithDoctor",
              ),
              model.loading
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.width / 2,
                        ),
                        child: CircularProgressIndicator(
                          color: ThemeClass.blueColor,
                        ),
                      ),
                    )
                  : model.isError
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.width / 2,
                            ),
                            child: Text(model.errorMessage),
                          ),
                        )
                      : Expanded(
                          child: LiveList.options(
                              itemCount: model.categoryModel.data!.length,
                              physics: BouncingScrollPhysics(),
                              options: AnimationService.animationOption,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (BuildContext context, int index,
                                  Animation<double> animation) {
                                final data = model.categoryModel.data![index];

                                return FadeTransition(
                                  opacity: Tween<double>(
                                    begin: 0,
                                    end: 1,
                                  ).animate(animation),
                                  child: SlideTransition(
                                    position: Tween<Offset>(
                                      begin: Offset(0, 0),
                                      end: Offset.zero,
                                    ).animate(animation),
                                    child: Column(
                                      children: [
                                        index == 0
                                            ? SizedBox(
                                                height: 16,
                                              )
                                            : SizedBox(),
                                        ListTile(
                                          onTap: () {
                                            _checkNavigation(data);
                                          },
                                          leading: Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Image.network(
                                              data.image.toString(),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          title: Text(
                                            data.title.toString(),
                                            style: TextStyle(
                                              color: ThemeClass.blackColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        Divider()
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
            ],
          ),
        ),
      )),
    );
  }

  _checkNavigation(data) async {
    var res = await showModalBottomSheet(
        context: context,
        useRootNavigator: true,
        builder: (context) {
          return BottomSheetForOnlineOffLineDoctore();
        });
    // pushNewScreen(context,
    //     screen: DoctorListScreen(
    //       mode: "",
    //       categoryId: data.id.toString(),
    //     ),
    //     withNavBar: true);

    print(res);
    if (res != null) {
      pushNewScreen(context,
          screen: DoctorListScreen(
            mode: res,
            categoryId: data.id.toString(),
          ),
          withNavBar: true);
      print(res);
    }
  }
}
