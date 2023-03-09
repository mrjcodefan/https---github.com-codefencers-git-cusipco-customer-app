// To parse this JSON data, do
//
//     final generalInformationModel = generalInformationModelFromJson(jsonString);

import 'dart:convert';

GeneralInformationModel generalInformationModelFromJson(String str) =>
    GeneralInformationModel.fromJson(json.decode(str));

String generalInformationModelToJson(GeneralInformationModel data) =>
    json.encode(data.toJson());

class GeneralInformationModel {
  GeneralInformationModel({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  String? success;
  String? status;
  String? message;
  GeneralInformation? data;

  factory GeneralInformationModel.fromJson(Map<String, dynamic> json) =>
      GeneralInformationModel(
        success: json["success"] == null ? null : json["success"],
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : GeneralInformation.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toJson(),
      };
}

class GeneralInformation {
  GeneralInformation({
    this.title,
    this.contactNo,
    this.contactEmail,
    this.fcmServerKey,
    this.googleMapApiKey,
    this.copyRightsYear,
    this.xdMobile,
    this.xdDeliveryBoy,
    this.xdVendor,
    this.xdDoctor,
    this.consultationCharges,
    this.orderPreparationTime,
    this.appVersion,
    this.forceUpdateVersion,
    this.playstoreUrl,
    this.appstoreUrl,
    this.appVersionIos,
    this.deliveryBoyApp,
    this.managementApp,
    this.appoinmentApp,
    this.userActivites,
  });

  String? title;
  String? contactNo;
  String? contactEmail;
  String? fcmServerKey;
  String? googleMapApiKey;
  String? copyRightsYear;
  String? xdMobile;
  String? xdDeliveryBoy;
  String? xdVendor;
  String? xdDoctor;
  String? consultationCharges;
  String? orderPreparationTime;
  String? appVersion;
  String? appVersionIos;
  String? forceUpdateVersion;
  String? playstoreUrl;
  String? appstoreUrl;
  App? deliveryBoyApp;
  App? managementApp;
  App? appoinmentApp;
  List<UserActivite>? userActivites;

  factory GeneralInformation.fromJson(Map<String, dynamic> json) =>
      GeneralInformation(
        title: json["title"] == null ? null : json["title"],
        contactNo: json["contact_no"] == null ? null : json["contact_no"],
        contactEmail:
            json["contact_email"] == null ? null : json["contact_email"],
        fcmServerKey:
            json["fcm_server_key"] == null ? null : json["fcm_server_key"],
        googleMapApiKey: json["google_map_api_key"] == null
            ? null
            : json["google_map_api_key"],
        copyRightsYear:
            json["copy_rights_year"] == null ? null : json["copy_rights_year"],
        xdMobile: json["xd_mobile"] == null ? null : json["xd_mobile"],
        xdDeliveryBoy:
            json["xd_delivery_boy"] == null ? null : json["xd_delivery_boy"],
        xdVendor: json["xd_vendor"] == null ? null : json["xd_vendor"],
        xdDoctor: json["xd_doctor"] == null ? null : json["xd_doctor"],
        consultationCharges: json["consultation_charges"] == null
            ? null
            : json["consultation_charges"],
        orderPreparationTime: json["order_preparation_time"] == null
            ? null
            : json["order_preparation_time"],
        appVersion: json["app_version"] == null ? null : json["app_version"],
        appVersionIos:
            json["app_version_ios"] == null ? null : json["app_version_ios"],
        forceUpdateVersion: json["force_update_version"] == null
            ? null
            : json["force_update_version"],
        playstoreUrl:
            json["playstore_url"] == null ? null : json["playstore_url"],
        appstoreUrl: json["appstore_url"] == null ? null : json["appstore_url"],
        deliveryBoyApp: json["delivery_boy_app"] == null
            ? null
            : App.fromJson(json["delivery_boy_app"]),
        managementApp: json["management_app"] == null
            ? null
            : App.fromJson(json["management_app"]),
        appoinmentApp: json["appoinment_app"] == null
            ? null
            : App.fromJson(json["appoinment_app"]),
        userActivites: json["user_activites"] == null
            ? null
            : List<UserActivite>.from(
                json["user_activites"].map((x) => UserActivite.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title == null ? null : title,
        "contact_no": contactNo == null ? null : contactNo,
        "contact_email": contactEmail == null ? null : contactEmail,
        "fcm_server_key": fcmServerKey == null ? null : fcmServerKey,
        "google_map_api_key": googleMapApiKey == null ? null : googleMapApiKey,
        "copy_rights_year": copyRightsYear == null ? null : copyRightsYear,
        "xd_mobile": xdMobile == null ? null : xdMobile,
        "xd_delivery_boy": xdDeliveryBoy == null ? null : xdDeliveryBoy,
        "xd_vendor": xdVendor == null ? null : xdVendor,
        "xd_doctor": xdDoctor == null ? null : xdDoctor,
        "consultation_charges":
            consultationCharges == null ? null : consultationCharges,
        "order_preparation_time":
            orderPreparationTime == null ? null : orderPreparationTime,
        "app_version": appVersion == null ? null : appVersion,
        "force_update_version":
            forceUpdateVersion == null ? null : forceUpdateVersion,
        "playstore_url": playstoreUrl == null ? null : playstoreUrl,
        "appstore_url": appstoreUrl == null ? null : appstoreUrl,
        "delivery_boy_app":
            deliveryBoyApp == null ? null : deliveryBoyApp!.toJson(),
        "management_app":
            managementApp == null ? null : managementApp!.toJson(),
        "appoinment_app":
            appoinmentApp == null ? null : appoinmentApp!.toJson(),
        "user_activites": userActivites == null
            ? null
            : List<dynamic>.from(userActivites!.map((x) => x.toJson())),
      };
}

class App {
  App({
    this.appVersion,
    this.appVersionIos,
    this.forceUpdateVersion,
    this.playstoreUrl,
    this.appstoreUrl,
  });

  String? appVersion;
  String? appVersionIos;
  String? forceUpdateVersion;
  String? playstoreUrl;
  String? appstoreUrl;

  factory App.fromJson(Map<String, dynamic> json) => App(
        appVersion: json["app_version"] == null ? null : json["app_version"],
        appVersionIos:
            json["app_version_ios"] == null ? null : json["app_version_ios"],
        forceUpdateVersion: json["force_update_version"] == null
            ? null
            : json["force_update_version"],
        playstoreUrl:
            json["playstore_url"] == null ? null : json["playstore_url"],
        appstoreUrl: json["appstore_url"] == null ? null : json["appstore_url"],
      );

  Map<String, dynamic> toJson() => {
        "app_version": appVersion == null ? null : appVersion,
        "force_update_version":
            forceUpdateVersion == null ? null : forceUpdateVersion,
        "playstore_url": playstoreUrl == null ? null : playstoreUrl,
        "appstore_url": appstoreUrl == null ? null : appstoreUrl,
      };
}

class UserActivite {
  UserActivite({
    this.title,
    this.slug,
  });

  String? title;
  String? slug;

  factory UserActivite.fromJson(Map<String, dynamic> json) => UserActivite(
        title: json["title"] == null ? null : json["title"],
        slug: json["slug"] == null ? null : json["slug"],
      );

  Map<String, dynamic> toJson() => {
        "title": title == null ? null : title,
        "slug": slug == null ? null : slug,
      };
}
