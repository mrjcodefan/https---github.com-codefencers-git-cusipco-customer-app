// To parse this JSON data, do
//
//     final getAddressModel = getAddressModelFromJson(jsonString);

import 'dart:convert';

GetAddressModel getAddressModelFromJson(String str) =>
    GetAddressModel.fromJson(json.decode(str));

String getAddressModelToJson(GetAddressModel data) =>
    json.encode(data.toJson());

class GetAddressModel {
  GetAddressModel({
    required this.success,
    required this.status,
    required this.message,
    required this.data,
  });

  String success;
  String status;
  String message;
  List<AddressData> data;

  factory GetAddressModel.fromJson(Map<String, dynamic> json) =>
      GetAddressModel(
        success: json["success"],
        status: json["status"],
        message: json["message"],
        data: List<AddressData>.from(
            json["data"].map((x) => AddressData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "status": status,
        "message": message,
        "data": List<AddressData>.from(data.map((x) => x.toJson())),
      };
}

class AddressData {
  AddressData({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.addressType,
    required this.address,
    required this.pincode,
    required this.latitude,
    required this.longitude,
  });

  String id;
  String name;
  String phoneNumber;
  String addressType;
  String address;
  String pincode;
  String latitude;
  String longitude;

  factory AddressData.fromJson(Map<String, dynamic> json) => AddressData(
        id: json["id"],
        name: json["name"],
        phoneNumber: json["phone_number"],
        addressType: json["address_type"],
        address: json["address"],
        pincode: json["pincode"],
        latitude: json["latitude"],
        longitude: json["longitude"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone_number": phoneNumber,
        "address_type": addressType,
        "address": address,
        "pincode": pincode,
        "latitude": latitude,
        "longitude": longitude,
      };
}
