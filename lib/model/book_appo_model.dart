// To parse this JSON data, do
//
//     final bookAppoModel = bookAppoModelFromJson(jsonString);

import 'dart:convert';

BookAppoModel bookAppoModelFromJson(String str) =>
    BookAppoModel.fromJson(json.decode(str));

String bookAppoModelToJson(BookAppoModel data) => json.encode(data.toJson());

class BookAppoModel {
  BookAppoModel({
    required this.success,
    required this.status,
    required this.message,
    required this.data,
  });

  String success;
  String status;
  String message;
  Data data;

  factory BookAppoModel.fromJson(Map<String, dynamic> json) => BookAppoModel(
        success: json["success"],
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.paymentUrl,
  });

  String paymentUrl;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        paymentUrl: json["payment_url"],
      );

  Map<String, dynamic> toJson() => {
        "payment_url": paymentUrl,
      };
}
