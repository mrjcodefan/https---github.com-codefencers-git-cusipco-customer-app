import 'package:flutter/material.dart';
import 'package:heal_u/model/get_address_model.dart';
import 'package:heal_u/themedata.dart';
import 'package:heal_u/widgets/alert_dialog_select_address_widget.dart';

class AddressBottomSheetListTileWidget extends StatefulWidget {
  AddressBottomSheetListTileWidget(
      {Key? key, required this.title, required this.callBack})
      : super(key: key);
  final Function(List) callBack;
  final String title;
  @override
  State<AddressBottomSheetListTileWidget> createState() =>
      _AddressBottomSheetListTileWidgetState();
}

class _AddressBottomSheetListTileWidgetState
    extends State<AddressBottomSheetListTileWidget> {
  String _selectedValue = "Select Address";
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: InkWell(
                  onTap: () {
                    _showAlertDialogAddressSelect();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        border: Border.all(color: ThemeClass.greyLightColor1)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              _selectedValue,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: ThemeClass.greyDarkColor),
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: ThemeClass.blueColor,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(
          thickness: 1,
          color: ThemeClass.greyLightColor1,
        ),
      ],
    );
  }

  _showAlertDialogAddressSelect() async {
    var value = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialogSelectAddress();
      },
    );

    if (value != null) {
      AddressData data = value;
      setState(() {
        _selectedValue = data.address.toString();
        widget.callBack([widget.title, data.id.toString()]);
      });
    }
  }
}
