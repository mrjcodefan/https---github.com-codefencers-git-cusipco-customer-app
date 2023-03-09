import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:heal_u/model/city_list_model.dart';
import 'package:heal_u/service/http_service/http_service.dart';
import 'package:heal_u/widgets/general_widget.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationProwiderService with ChangeNotifier {
  CityList? currentLocationCity;
  List<CityList> globleCityList = [];

  bool ischangeLocation = false;

  setCurrentCity(CityList? value) {
    currentLocationCity = value;
    ischangeLocation = true;
    Future.delayed(Duration(seconds: 1), () {
      ischangeLocation = false;
    });
    notifyListeners();
  }

  Future getCityList() async {
    try {
      var url = "get_cities";

      var response = await HttpService.httpGetWithoutToken(
        url,
      );

      if (response.statusCode == 200) {
        CityListModel citydata =
            CityListModel.fromJson(jsonDecode(response.body));

        if (citydata.status == "200" && citydata.success == "1") {
          if (globleCityList.isEmpty) {
            globleCityList.addAll(citydata.data!.toList());
          }
        }

        notifyListeners();
      }
    } catch (e) {
      debugPrint("--- getCityList --- ${e.toString()}");
    }
  }

  Future getCurrentCityLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        openAppSettings();
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return showToast('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return showToast(
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
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        var tempcurrentLocationCity =
            placemarks[0].subAdministrativeArea != null &&
                    placemarks[0].subAdministrativeArea != ""
                ? placemarks[0].subAdministrativeArea.toString()
                : "";

        if (tempcurrentLocationCity == "") {
          tempcurrentLocationCity =
              placemarks[0].locality != null && placemarks[0].locality != ""
                  ? placemarks[0].locality.toString()
                  : "";
        }

        var isinserted = globleCityList
            .where((element) =>
                element.name.toString().toLowerCase() ==
                tempcurrentLocationCity.toLowerCase().toString())
            .toList();

        if (isinserted.isNotEmpty) {
          currentLocationCity = isinserted.first;
        }
      }

      return;
    } catch (e) {
      debugPrint("--- location Provider --- ${e.toString()}");
    } finally {
      print("finally call===============");
      notifyListeners();
    }
  }
}
