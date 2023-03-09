import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:heal_u/screens/main_screen/my_account/health_record/health_record_model.dart';
import 'package:heal_u/screens/main_screen/my_account/health_record/health_service.dart';
import 'package:heal_u/service/save_file_service.dart';

import 'package:heal_u/themedata.dart';
import 'package:heal_u/widgets/app_bars/appbar_with_text.dart';
import 'package:heal_u/widgets/future_builder_widget.dart';
import 'package:heal_u/widgets/general_widget.dart';
import 'package:open_file/open_file.dart';

class HealthRecordScreen extends StatefulWidget {
  HealthRecordScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HealthRecordScreen> createState() => _HealthRecordScreenState();
}

class _HealthRecordScreenState extends State<HealthRecordScreen> {
  var _futureCall;
  @override
  void initState() {
    super.initState();

    _futureCall = HealthService.getHealthRecord();
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
                onbackPress: () {
                  Navigator.pop(context);
                },
                title: "Health Records",
                isShowCart: true,
              )),
          body: Container(
            color: ThemeClass.whiteColor,
            height: height,
            width: width,
            child: FutureBuildWidget(
              future: HealthService.getHealthRecord(),
              child: (data) {
                return _buildView(data);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildView(List<HealthRecordData>? data) {
    if (data!.isEmpty) {
      return Center(
        child: Text("Data Not Found!"),
      );
    }

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      // ignore: prefer_const_literals_to_create_immutables
      child: Padding(
        padding: const EdgeInsets.only(top: 8, left: 8, bottom: 8),
        child: Column(
            // ignore: prefer_const_literals_to_create_immutables
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...data.map(
                (e) => _buildCard(e),
              ),
              SizedBox(
                height: 100,
              )
            ]),
      ),
    );
  }

  Padding _buildCard(HealthRecordData data) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 20),
      child: Row(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          Expanded(
            flex: 2,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(
                    width: 2, color: ThemeClass.greyDarkColor.withOpacity(0.3)),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                image: DecorationImage(
                  image: AssetImage("assets/images/pdf_thumbnail.png"),
                  fit: BoxFit.cover,
                ),
              ),
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
                    data.title.toString(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    data.status.toString(),
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
          Expanded(
            flex: 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.date.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  data.time.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    color: ThemeClass.greyDarkColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: InkWell(
              onTap: () async {
                _downloadPdf(data.files.toString());
                // var value = await showDialog(
                //   barrierDismissible: false,
                //   context: context,
                //   builder: (BuildContext context) {
                //     return LoadingAnimation();
                //   },
                // );
              },
              child: Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/cloud_download.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _downloadPdf(String url) async {
    try {
      EasyLoading.show();
      var path = await SaveFileService().createFolder(url);
      final _result = await OpenFile.open(path.path);
      print(_result.message);
    } catch (e) {
      showToast(e.toString());
    } finally {
      EasyLoading.dismiss();
    }
  }
}
