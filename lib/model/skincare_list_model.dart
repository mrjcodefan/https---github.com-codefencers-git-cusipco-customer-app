// To parse this JSON data, do
//
//     final skinListModel = skinListModelFromJson(jsonString);

import 'dart:convert';

SkinListModel skinListModelFromJson(String str) => SkinListModel.fromJson(json.decode(str));

String skinListModelToJson(SkinListModel data) => json.encode(data.toJson());

class SkinListModel {
    SkinListModel({
        required this.success,
        required this.status,
        required this.message,
        required this.data,
    });

    String success;
    String status;
    String message;
    List<Datum> data;

    factory SkinListModel.fromJson(Map<String, dynamic> json) => SkinListModel(
        success: json["success"],
        status: json["status"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    Datum({
        required this.id,
        required this.image,
        required this.title,
        required this.owner,
        required this.price,
        required this.rating,
    });

    String id;
    String image;
    String title;
    String owner;
    String price;
    String rating;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        image: json["image"],
        title: json["title"],
        owner: json["owner"],
        price: json["price"],
        rating: json["rating"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "title": title,
        "owner": owner,
        "price": price,
        "rating": rating,
    };
}
