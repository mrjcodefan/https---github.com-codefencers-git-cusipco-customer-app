import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heal_u/service/prowider/general_information_service.dart';
import 'package:heal_u/service/shared_pref_service/user_pref_service.dart';
import 'package:heal_u/widgets/general_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

String time24to12Format(String time) {
  int h = int.parse(time.split(":").first);
  int m = int.parse(time.split(":").last.split(" ").first);
  String send = "";
  if (h > 12) {
    var temp = h - 12;
    send =
        "0$temp:${m.toString().length == 1 ? "0" + m.toString() : m.toString()} " +
            "PM";
  } else {
    send =
        "$h:${m.toString().length == 1 ? "0" + m.toString() : m.toString()}  " +
            "AM";
  }

  return send;
}

getddmmyyyy(String date) {
  print("-------------------------------------$date");
  try {
    String datePattern = "yyyy-MM-dd";

    DateTime birthDate = DateFormat(datePattern).parse(date);
    String formattedDate = DateFormat('dd-MM-yyyy').format(birthDate);
    print(formattedDate);

    return formattedDate;
  } catch (e) {
    print(e);
    return date;
  }
}

checkAppUpdate(BuildContext context, {required bool isShowNormalAlert}) async {
  var generalProw = Provider.of<GeneralInfoService>(context, listen: false);

  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String version = packageInfo.version;
  int? _versionFromAPI = Platform.isAndroid
      ? getExtendedVersionNumber(generalProw.generalData!.appVersion.toString())
      : getExtendedVersionNumber(
          generalProw.generalData!.appVersionIos.toString());

  int? _versionFromAPIForceUpdate = getExtendedVersionNumber(
      generalProw.generalData!.forceUpdateVersion.toString());

  int? _appversion = getExtendedVersionNumber(version);

  String _appLink = Platform.isAndroid
      ? generalProw.generalData!.playstoreUrl.toString()
      : generalProw.generalData!.appstoreUrl.toString();

  if (_versionFromAPI != null &&
      _versionFromAPIForceUpdate != null &&
      _appversion != null) {
    //
    // check force update
    if (_versionFromAPIForceUpdate > _appversion) {
      var res = await _updateAlert(context, true);
      if (res != null && res == true) {
        _openBrowser(_appLink);
      }
    }
    //
    // check normal update
    else if (_versionFromAPI > _appversion) {
      if (isShowNormalAlert) {
        var res = await _updateAlert(context, false);
        if (res) {
          _openBrowser(_appLink);
        }
      }
    } else {
      print("--------------  app is upto date   -------------");
    }
  } else {
    print("--------------  version is not formated   -------------");
  }
}

Future _updateAlert(BuildContext context, bool isForce) {
  return showDialog(
    barrierDismissible: !isForce,
    context: context,
    builder: (BuildContext context1) {
      return WillPopScope(
        onWillPop: () {
          return Future.value(!isForce);
        },
        child: AlertDialog(
          title: Text('New Version Available.'),
          content: Text('Please update the application'),
          actions: [
            !isForce
                ? TextButton(
                    child: Text("Remind me later"),
                    onPressed: () {
                      Navigator.pop(context1, false);
                    },
                  )
                : SizedBox(),
            TextButton(
              child: Text("Update"),
              onPressed: () {
                Navigator.pop(context1, true);
              },
            )
          ],
        ),
      );
    },
  );
}

Future<void> _openBrowser(String url) async {
  if (url == null || url == "") {
    showToast("Update link is not available");
  } else {
    await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  }
}

int? getExtendedVersionNumber(String version) {
  try {
    List versionCells = version.split('.');
    versionCells = versionCells.map((i) => int.parse(i)).toList();
    return versionCells[0] * 100000 + versionCells[1] * 1000 + versionCells[2];
  } catch (e) {
    return null;
  }
}
