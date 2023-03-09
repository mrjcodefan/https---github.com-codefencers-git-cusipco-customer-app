import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:heal_u/Global/global_variable_for_show_messge.dart';
import 'package:heal_u/model/city_list_model.dart';
import 'package:heal_u/screens/main_screen/my_account/family_members/service/family_prowider_service.dart';
import 'package:heal_u/service/prowider/location_prowider_service.dart';
import 'package:http_parser/http_parser.dart';
import 'package:heal_u/service/shared_pref_service/user_pref_service.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class HttpService with ChangeNotifier {
  static const String API_BASE_URL_BASE = "http://admin.healuconsultancy.com/";

  static const String API_BASE_URL =
      "http://admin.healuconsultancy.com/api/customer/";

  static Map<String, String> requestHeaders = {
    HttpHeaders.contentTypeHeader: 'application/json',
    "Request-From": Platform.isAndroid ? "Android" : "Ios",
    HttpHeaders.acceptLanguageHeader: 'en'
  };

  static Future<Response> httpGetWithoutToken(String url) async {
    bool isHasConnection = await InternetConnectionChecker().hasConnection;

    if (isHasConnection) {
      return http.get(
        Uri.parse(API_BASE_URL + url),
        headers: requestHeaders,
      );
    } else {
      throw GlobalVariableForShowMessage.internetNotConneted;
    }
  }

  static Future<Response> httpGet(String url) async {
    var token = await UserPrefService().getToken();
    bool isHasConnection = await InternetConnectionChecker().hasConnection;

    if (isHasConnection) {
      print(API_BASE_URL + url);
      print(token);

      return http.get(
        Uri.parse(API_BASE_URL + url),
        headers: requestHeaders
          ..addAll({
            'Authorization': 'Bearer $token',
          }),
      );
    } else {
      throw GlobalVariableForShowMessage.internetNotConneted;
    }
  }

  static Future<Response> httpPost(String url, dynamic data,
      {required BuildContext context}) async {
    bool isHasConnection = await InternetConnectionChecker().hasConnection;

    if (isHasConnection) {
      var token = await UserPrefService().getToken();

      String memberid = "";
      CityList? _currentCity;
      var familyPro = Provider.of<FamilyMemberService>(context, listen: false);
      if (familyPro.isSelectFamilyMember) {
        memberid = familyPro.currentFamilyMember!.id.toString();
      }
      var locationService =
          Provider.of<LocationProwiderService>(context, listen: false);
      _currentCity = locationService.currentLocationCity;

      Map<String, String> tempdata1 = {"member_id": memberid};

      if (!data.containsKey("member_id")) {
        data.addAll(tempdata1);
      }

      print("----------------------------${memberid}");
      print("----------------------------${data}");

      print("----------------------------${API_BASE_URL + url}");
      print("----------------------------${token}");
      return http.post(
        Uri.parse(API_BASE_URL + url),
        body: jsonEncode(data),
        headers: requestHeaders
          ..addAll({
            'Authorization': 'Bearer $token',
            'City': _currentCity != null ? _currentCity.id.toString() : "0",
          }),
        // headers: requestHeaders,
      );
    } else {
      throw GlobalVariableForShowMessage.internetNotConneted;
    }
  }

  static Future<Response> httpPostWithoutContext(
    String url,
    dynamic data,
  ) async {
    bool isHasConnection = await InternetConnectionChecker().hasConnection;

    if (isHasConnection) {
      var token = await UserPrefService().getToken();

      print("----------------------------${data}");
      print("----------------------------${API_BASE_URL + url}");
      return http.post(
        Uri.parse(API_BASE_URL + url),
        body: jsonEncode(data),
        headers: requestHeaders
          ..addAll({
            'Authorization': 'Bearer $token',
          }),
        // headers: requestHeaders,
      );
    } else {
      throw GlobalVariableForShowMessage.internetNotConneted;
    }
  }

  static Future<Response> httpPostWithImageUpload(
      String url, File? imageFile, Map<String, dynamic> queryParameters,
      {required String peramterName}) async {
    bool isHasConnection = await InternetConnectionChecker().hasConnection;

    if (isHasConnection) {
      try {
        var request3 = http.MultipartRequest(
          'POST',
          Uri.parse(API_BASE_URL + url),
        );
        request3.headers.addAll(requestHeaders);

        request3.files.add(await http.MultipartFile.fromPath(
          peramterName,
          "${imageFile!.path}",
          contentType: MediaType('image', 'jpg'),
        ));

        queryParameters.forEach((key, value) {
          request3.fields[key] = value;
        });

        StreamedResponse res3 = await request3.send();
        var response = await http.Response.fromStream(
          res3,
        );

        return response;
      } catch (e) {
        print(e.toString());

        rethrow;

        // return [];
      }
    } else {
      throw GlobalVariableForShowMessage.internetNotConneted;
    }
  }

  static Future<Response> httpPostWithoutToken(String url, dynamic data,
      {required BuildContext context}) async {
    bool isHasConnection = await InternetConnectionChecker().hasConnection;

    if (isHasConnection) {
      CityList? _currentCity;
      var locationService =
          Provider.of<LocationProwiderService>(context, listen: false);
      _currentCity = locationService.currentLocationCity;
      print(url);
      print(data);

      return http.post(
        Uri.parse(API_BASE_URL + url),
        body: jsonEncode(data),
        headers: requestHeaders
          ..addAll({
            'City': _currentCity != null ? _currentCity.id.toString() : "0",
          }),
      );
    } else {
      throw GlobalVariableForShowMessage.internetNotConneted;
    }
  }
}
