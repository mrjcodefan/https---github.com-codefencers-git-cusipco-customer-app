import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/cupertino.dart';
import 'package:heal_u/screens/main_screen/home/Food/model/resturent_details_model.dart';
import 'package:heal_u/service/animation_service.dart';
import 'package:heal_u/widgets/animation_of_list_item_widget.dart';
import 'package:heal_u/widgets/product_item_resturent_widget.dart';

class ProductListWidget extends StatefulWidget {
  const ProductListWidget({
    Key? key,
    required this.item,
    required this.isOpen,
  }) : super(key: key);

  final ResturentCategory item;
  final bool isOpen;
  @override
  State<ProductListWidget> createState() => _ProductListWidgetState();
}

class _ProductListWidgetState extends State<ProductListWidget> {
  @override
  Widget build(BuildContext context) {
    return LiveList.options(
      itemCount: widget.item.items!.length,
      physics: BouncingScrollPhysics(),
      options: AnimationService.animationOption,
      itemBuilder:
          (BuildContext context, int index, Animation<double> animation) {
        return AnimatedListTileItem(
          animation: animation,
          child: ProductItemResturentWidget(
              isOpen: widget.isOpen,
              data: widget.item.items![index],
              isShowCart: widget.item.items![index].quantityInCart != "0",
              callback: () {}),
        );
      },
      scrollDirection: Axis.vertical,
    );
  }
}
