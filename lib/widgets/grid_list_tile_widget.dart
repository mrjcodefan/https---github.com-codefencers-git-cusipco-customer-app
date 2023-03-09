import 'package:flutter/material.dart';
import 'package:heal_u/model/category_model.dart';

// ignore: must_be_immutable
class GridListTileWidget extends StatefulWidget {
  GridListTileWidget({Key? key, required this.data, required this.callback})
      : super(key: key);
  CategoryData data;
  Function callback;
  @override
  State<GridListTileWidget> createState() => _GridListTileWidgetState();
}

class _GridListTileWidgetState extends State<GridListTileWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.callback();
      },
      child: Column(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              padding: EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0,
                      blurRadius: 5,
                      offset: Offset(0, 4), // changes position of shadow
                    ),
                  ],
                  image: DecorationImage(
                    image: NetworkImage(widget.data.image.toString()),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                child: Text(
                  "${widget.data.title.toString()}",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
