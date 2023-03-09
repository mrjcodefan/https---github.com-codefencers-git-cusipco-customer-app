import 'package:flutter/material.dart';
import 'package:heal_u/themedata.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget(
      {Key? key,
      this.isLoading = false,
      required this.title,
      required this.color,
      this.isdisable = false,
      required this.callBack})
      : super(key: key);
  final bool isLoading;
  final bool isdisable;
  final String title;
  final Function callBack;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: isdisable ? color.withOpacity(0.5) : color,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          gradient: LinearGradient(
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter,
            colors: [
              ThemeClass.blueColor,
              ThemeClass.blueColor3,
            ],
          ),
        ),
        width: MediaQuery.of(context).size.width,
        child: InkWell(
          onTap: () {
            if (!isdisable) {
              callBack();
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
            ),
            child: isLoading
                ? SizedBox(
                    width: MediaQuery.of(context).size.width * 0.06,
                    height: MediaQuery.of(context).size.height * 0.03,
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        color: Colors.white,
                      ),
                    ),
                  )
                : Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
  // Widget build(BuildContext context) {
  //   return Center(
  //     child: MaterialButton(
  //       minWidth: MediaQuery.of(context).size.width,
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //       child: Padding(
  //         padding: const EdgeInsets.symmetric(
  //           // horizontal: 50,
  //           vertical: 12,
  //         ),
  //         child: isLoading
  //             ? SizedBox(
  //                 width: MediaQuery.of(context).size.width * 0.06,
  //                 height: MediaQuery.of(context).size.height * 0.03,
  //                 child: CircularProgressIndicator(
  //                   strokeWidth: 2.0,
  //                   color: Colors.white,
  //                 ),
  //               )
  //             : Text(
  //                 title,
  //                 style: TextStyle(
  //                   color: Colors.white,
  //                   fontWeight: FontWeight.w500,
  //                   fontSize: 16,
  //                 ),
  //               ),
  //       ),
  //       color: isdisable ? color.withOpacity(0.5) : color,
  //       onPressed: () {
  //         if (!isdisable) {
  //           callBack();
  //         }
  //       },
  //     ),
  //   );
  // }
}
