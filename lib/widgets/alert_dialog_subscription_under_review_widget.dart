import 'package:flutter/material.dart';
import 'package:heal_u/themedata.dart';

class AlertDialogSubcsriptionUnderReview extends StatelessWidget {
  const AlertDialogSubcsriptionUnderReview({Key? key, required this.title})
      : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 300,
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Container(
              color: ThemeClass.whiteColor,
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              height: 250,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            "assets/images/temlate_setting_blue.png"),
                        // fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: ThemeClass.blueColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      "You will get notified once the nutritionist will give approval.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ThemeClass.greyColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 60,
                width: 60,
                child: InkWell(
                  onTap: () {
                    print("close clicked");
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: ThemeClass.blueColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                    child: Icon(
                      Icons.close,
                      size: 25,
                      color: ThemeClass.whiteColor,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
