// To parse this JSON data, do
//
//     final commoListModel = commoListModelFromJson(jsonString);

import 'dart:convert';

CommoListModel commoListModelFromJson(String str) => CommoListModel.fromJson(json.decode(str));

String commoListModelToJson(CommoListModel data) => json.encode(data.toJson());

class CommoListModel {
    CommoListModel({
        required this.success,
        required this.status,
        required this.message,
        required this.data,
    });

    String success;
    String status;
    String message;
    List<Datum> data;

    factory CommoListModel.fromJson(Map<String, dynamic> json) => CommoListModel(
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
        required this.location,
        required this.rating,
    });

    String id;
    String image;
    String title;
    String location;
    String rating;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        image: json["image"],
        title: json["title"],
        location: json["location"],
        rating: json["rating"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "title": title,
        "location": location,
        "rating": rating,
    };
}
