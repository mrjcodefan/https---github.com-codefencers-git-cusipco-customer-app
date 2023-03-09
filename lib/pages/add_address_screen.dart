import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:heal_u/Global/global_enum_class.dart';
import 'package:heal_u/Global/global_variable_for_show_messge.dart';
import 'package:heal_u/model/common_model.dart';
import 'package:heal_u/model/get_address_model.dart';
import 'package:heal_u/pages/manage_address_screen.dart';
import 'package:heal_u/service/address_services/add_address_services.dart';
import 'package:heal_u/themedata.dart';
import 'package:heal_u/widgets/app_bars/appbar_with_text.dart';
import 'package:heal_u/widgets/button_widget/rounded_button_widget.dart';
import 'package:heal_u/widgets/general_widget.dart';
import 'package:heal_u/widgets/text_boxes/text_box_normal.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class AddAddressScreen extends StatefulWidget {
  AddAddressScreen(
      {Key? key,
      this.isEdit = false,
      this.addressData,
      this.isFromCheckout = false})
      : super(key: key);

  bool isEdit;
  AddressData? addressData;
  bool isFromCheckout;
  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isFirstSubmit = true;
  String type = "Home";

  enumAddress _radioAddressGroup = enumAddress.Home;
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();

  GoogleMapController? _controller;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  bool isEnabled = true;

  double _lat = 20.5937;
  double _long = 78.9629;

  bool isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      _loadDataforEdit();
    } else {
      _determinePosition();
    }
  }

  _loadDataforEdit() {
    var type = widget.addressData!.addressType.toString();
    setState(() {
      _radioAddressGroup = type == "Home"
          ? enumAddress.Home
          : type == "Office"
              ? enumAddress.Office
              : enumAddress.Other;

      _pincodeController.text = widget.addressData!.pincode.toString();
      _addressController.text = widget.addressData!.address.toString();
      _nameController.text = widget.addressData!.name.toString();
      _numberController.text = widget.addressData!.phoneNumber.toString();

      _lat = widget.addressData!.latitude.toString() != ""
          ? double.parse(widget.addressData!.latitude.toString())
          : 0;
      _long = widget.addressData!.longitude.toString() != ""
          ? double.parse(widget.addressData!.longitude.toString())
          : 0;

      if (_lat == 0.0 || _long == 0.0) {
        _determinePosition();
      } else {
        _updateMarker(_lat, _long);
      }
    });
  }

  Future _determinePosition() async {
    setState(() {
      isLoadingLocation = true;
    });
    bool serviceEnabled;
    LocationPermission permission;
    try {
      // Test if location services are enabled.

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted)
          setState(() {
            isEnabled = false;
          });
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted)
            setState(() {
              isEnabled = false;
            });
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.

        await openAppSettings();
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      Position? position;

      try {
        position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
            forceAndroidLocationManager: true,
            timeLimit: Duration(seconds: 15));
      } catch (e) {
        position = await Geolocator.getLastKnownPosition(
          forceAndroidLocationManager: true,
        );
      }

      if (position == null) {
        showToast(
            "Unable to detect your location please select location manually.");
        return;
      }

      if (mounted) {
        if (position != null) {
          _updateMarker(position.latitude, position.longitude);
        }
      }
    } on TimeoutException {
      bool isHasConnection = await InternetConnectionChecker().hasConnection;

      if (isHasConnection) {
        showToast(GlobalVariableForShowMessage.timeoutExceptionMessage);
      } else {
        Navigator.pop(context);
        showToast(GlobalVariableForShowMessage.internetNotConneted);
      }
    } catch (e) {
      debugPrint("--------------------->");

      showToast(e.toString());

      debugPrint(e.toString());
    } finally {
      setState(() {
        isLoadingLocation = false;
      });
    }
  }

  _updateMarker(latitude, longitude) {
    final MarkerId markerId = MarkerId("markerIdVal");

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
        latitude,
        longitude,
      ),
      //infoWindow: InfoWindow(title: "title", snippet: '*'),
      onTap: () {},
    );
    if (mounted)
      setState(() {
        _lat = latitude;
        _long = longitude;

        markers[markerId] = marker;
      });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      color: ThemeClass.safeareBackGround,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false, // th
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(65.0),
              child: AppBarWithTextAndBackWidget(
                onbackPress: () {
                  Navigator.pop(context);
                },
                title: widget.isEdit ? "Edit Address" : "Add New Address",
              )),
          body: Container(
            color: ThemeClass.whiteColor,
            height: height,
            width: width,
            child: Stack(
              children: [
                SingleChildScrollView(
                  reverse: true,
                  primary: false,
                  // physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 25, left: 25, right: 25),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: !isFirstSubmit
                          ? AutovalidateMode.always
                          : AutovalidateMode.disabled,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextBoxSimpleWidget(
                            hinttext: "Pincode*",
                            isNumber: true,
                            controllers: _pincodeController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return GlobalVariableForShowMessage
                                        .EmptyErrorMessage +
                                    "Pincode";
                              } else if (value.length != 6) {
                                return GlobalVariableForShowMessage
                                    .pincodeinvalied;
                              }
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextBoxSimpleWidget(
                              hinttext: "House Number, Building and Locality**",
                              controllers: _addressController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return GlobalVariableForShowMessage
                                          .EmptyErrorMessage +
                                      "Address";
                                }
                              }),
                          SizedBox(
                            height: 15,
                          ),
                          TextBoxSimpleWidget(
                            hinttext: "Name*",
                            controllers: _nameController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return GlobalVariableForShowMessage
                                        .EmptyErrorMessage +
                                    "Name";
                              }
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextBoxSimpleWidget(
                            hinttext: "Contact Number*",
                            isNumber: true,
                            controllers: _numberController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return GlobalVariableForShowMessage
                                        .EmptyErrorMessage +
                                    "Phone Number";
                              } else if (value.length != 10) {
                                return GlobalVariableForShowMessage
                                    .phoneNumberinvalied;
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          _buildRadioButton(),
                          _buildGoogleMap(),
                          SizedBox(
                            height: 150,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                _buildBottomButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ClipRRect _buildGoogleMap() => ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 300,
          child: isEnabled == false
              ? Center(
                  child: Text(
                    'Location Permission Required For Google Map',
                  ),
                )
              : isLoadingLocation
                  ? Center(
                      child: CircularProgressIndicator(
                        color: ThemeClass.blueColor,
                      ),
                    )
                  : GoogleMap(
                      gestureRecognizers: <
                          Factory<OneSequenceGestureRecognizer>>{
                        Factory<OneSequenceGestureRecognizer>(
                          () => EagerGestureRecognizer(),
                        ),
                      },
                      scrollGesturesEnabled: true,
                      onTap: (LatLng cordinate) {
                        _updateMarker(cordinate.latitude, cordinate.longitude);
                      },
                      mapType: MapType.normal,
                      initialCameraPosition:
                          CameraPosition(target: LatLng(_lat, _long), zoom: 5),
                      onMapCreated: (GoogleMapController controller) {
                        _controller = controller;
                      },
                      markers: Set<Marker>.of(markers.values),
                    ),
        ),
      );

  Align _buildBottomButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: 15,
        ),
        height: 110,
        child: ButtonWidget(
          title: widget.isEdit ? "Update Address" : "Add New Address",
          color: ThemeClass.blueColor,
          callBack: () async {
            setState(() {
              isFirstSubmit = false;
            });
            if (_formKey.currentState!.validate()) {
              if (widget.isEdit) {
                _updateAddress();
              } else {
                _addAddress();
              }
            }
          },
        ),
      ),
    );
  }

  _updateAddress() async {
    EasyLoading.show();
    String _lat1 = "";
    String _long1 = "";
    try {
      markers.forEach((key, value) {
        _lat1 = value.position.latitude.toString();
        _long1 = value.position.longitude.toString();
      });

      var add = AddressData(
          id: widget.addressData!.id,
          name: _nameController.text,
          phoneNumber: _numberController.text,
          addressType: _radioAddressGroup.name,
          address: _addressController.text,
          pincode: _pincodeController.text,
          latitude: _lat1,
          longitude: _long1);

      CommonModel? model =
          await updateNewAddress(address: add, context: context);

      showToast(model!.message);
      if (model.status == "200") {
        Navigator.pop(context, true);
      }
      print("done-------");
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint(e.toString());
    } finally {
      EasyLoading.dismiss();
    }
  }

  _addAddress() async {
    String _lat = "";
    String _long = "";
    try {
      markers.forEach((key, value) {
        _lat = value.position.latitude.toString();
        _long = value.position.longitude.toString();
      });

      if (_lat == "" && _long == "") {
        showToast("Please select location from google map.");
        throw "";
      }

      EasyLoading.show();
      CommonModel? model = await addNewAddress(
          _nameController.text,
          type,
          _addressController.text,
          _pincodeController.text,
          _lat,
          _long,
          _numberController.text,
          context: context);

      showToast(model!.message);
      if (model.status == "200") {
        if (widget.isFromCheckout) {
          Navigator.pop(context);
        } else {
          pushNewScreen(
            context,
            screen: ManageAddressScreen(),
            withNavBar: true,
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        }
      }

      print("done--------");
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint(e.toString());
    } finally {
      EasyLoading.dismiss();
    }
  }

  Row _buildRadioButton() {
    return Row(
      children: [
        Radio(
          value: enumAddress.Home,
          activeColor: ThemeClass.blueColor,
          fillColor: MaterialStateProperty.all(ThemeClass.blueColor),
          groupValue: _radioAddressGroup,
          onChanged: (enumAddress? value) {
            setState(() {
              _radioAddressGroup = value!;
              type = "Home";
            });
          },
        ),
        Text(
          'Home',
          style: TextStyle(
              color: ThemeClass.greyDarkColor,
              fontSize: 12,
              fontWeight: FontWeight.w400),
        ),
        Radio(
          value: enumAddress.Office,
          activeColor: ThemeClass.blueColor,
          fillColor: MaterialStateProperty.all(ThemeClass.blueColor),
          groupValue: _radioAddressGroup,
          onChanged: (enumAddress? value) {
            setState(() {
              _radioAddressGroup = value!;
              type = "Office";
            });
          },
        ),
        Text(
          'Office',
          style: TextStyle(
              color: ThemeClass.greyDarkColor,
              fontSize: 12,
              fontWeight: FontWeight.w400),
        ),
        Radio(
          value: enumAddress.Other,
          activeColor: ThemeClass.blueColor,
          fillColor: MaterialStateProperty.all(ThemeClass.blueColor),
          groupValue: _radioAddressGroup,
          onChanged: (enumAddress? value) {
            setState(() {
              _radioAddressGroup = value!;
              type = "Other";
            });
          },
        ),
        Text(
          'Other',
          style: TextStyle(
              color: ThemeClass.greyDarkColor,
              overflow: TextOverflow.ellipsis,
              fontSize: 12,
              fontWeight: FontWeight.w400),
        )
      ],
    );
  }
}
