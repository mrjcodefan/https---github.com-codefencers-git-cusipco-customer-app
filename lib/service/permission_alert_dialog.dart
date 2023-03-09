import 'package:flutter/material.dart';
import 'package:heal_u/themedata.dart';

import 'package:permission_handler/permission_handler.dart';

class PermissionAlertDialogWidget extends StatefulWidget {
  const PermissionAlertDialogWidget({Key? key}) : super(key: key);

  @override
  State<PermissionAlertDialogWidget> createState() =>
      _PermissionAlertDialogWidgetState();
}

class _PermissionAlertDialogWidgetState
    extends State<PermissionAlertDialogWidget> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(vertical: 10),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            SizedBox(
              height: 20,
            ),
            Center(
                child: Text(
              "Storage Peremission is Permanently Denied, Please Allow",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            )),
            SizedBox(
              height: 20,
            ),
            Center(
                child: Text(
              " Open App Setting  ->  Permissions  ->  Allow Storage Permission",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ))
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text(
            "Cancel",
            style: TextStyle(color: ThemeClass.orangeColor),
          ),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        TextButton(
          child: Text(
            "Go To Setting",
            style: TextStyle(color: ThemeClass.orangeColor),
          ),
          onPressed: () {
            openAppSettings();
            Navigator.pop(context, true);
          },
        )
      ],
    );
  }
}
