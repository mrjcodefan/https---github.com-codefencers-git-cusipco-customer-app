import 'package:flutter/material.dart';
import 'package:heal_u/themedata.dart';

class FutureBuildWidget extends StatelessWidget {
  FutureBuildWidget(
      {Key? key,
      required this.child,
      this.errorchild,
      required this.future,
      this.errorMessage,
      this.isList = false})
      : super(key: key);
  Function child;
  Widget? errorchild;
  dynamic future;

  String? errorMessage;
  bool isList;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              if (snapshot.data != null) {
                if (isList) {
                  if (snapshot.data.isNotEmpty) {
                    return child(data: snapshot.data);
                  } else {
                    return errorchild ??
                        _buildDataNotFound1(errorMessage ?? "Data Not Found!");
                  }
                } else {
                  return child(snapshot.data);
                }
              } else {
                return errorchild ??
                    _buildDataNotFound1(errorMessage ?? "Data Not Found!");
              }
            } else if (snapshot.hasError) {
              return _buildDataNotFound1(snapshot.error.toString());
            } else {
              return errorchild ??
                  _buildDataNotFound1(errorMessage ?? "Data Not Found!");
            }
          } else {
            return Center(
              child: CircularProgressIndicator(color: ThemeClass.blueColor),
            );
          }
        });
  }

  Center _buildDataNotFound1(
    String text,
  ) {
    return Center(child: Text("$text"));
  }
}
