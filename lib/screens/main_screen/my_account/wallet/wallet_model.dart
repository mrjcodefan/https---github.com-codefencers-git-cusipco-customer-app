// To parse this JSON data, do
//
//     final walletModel = walletModelFromJson(jsonString);

import 'dart:convert';

WalletModel walletModelFromJson(String str) =>
    WalletModel.fromJson(json.decode(str));

String walletModelToJson(WalletModel data) => json.encode(data.toJson());

class WalletModel {
  WalletModel({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  String? success;
  String? status;
  String? message;
  WalletData? data;

  factory WalletModel.fromJson(Map<String, dynamic> json) => WalletModel(
        success: json["success"] == null ? null : json["success"],
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : WalletData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toJson(),
      };
}

class WalletData {
  WalletData({
    this.id,
    this.balance,
    this.history,
  });

  String? id;
  String? balance;
  List<History>? history;

  factory WalletData.fromJson(Map<String, dynamic> json) => WalletData(
        id: json["id"] == null ? null : json["id"],
        balance: json["balance"] == null ? null : json["balance"],
        history: json["history"] == null
            ? null
            : List<History>.from(
                json["history"].map((x) => History.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "balance": balance == null ? null : balance,
        "history": history == null
            ? null
            : List<dynamic>.from(history!.map((x) => x.toJson())),
      };
}

class History {
  History({
    this.id,
    this.date,
    this.time,
    this.balance,
    this.type,
    this.status,
  });

  String? id;
  String? date;
  String? time;
  String? balance;
  String? type;
  String? status;

  factory History.fromJson(Map<String, dynamic> json) => History(
        id: json["id"] == null ? null : json["id"],
        date: json["date"] == null ? null : json["date"],
        time: json["time"] == null ? null : json["time"],
        balance: json["balance"] == null ? null : json["balance"],
        type: json["type"] == null ? null : json["type"],
        status: json["status"] == null ? null : json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "date": date == null ? null : date,
        "time": time == null ? null : time,
        "balance": balance == null ? null : balance,
        "type": type == null ? null : type,
        "status": status == null ? null : status,
      };
}
