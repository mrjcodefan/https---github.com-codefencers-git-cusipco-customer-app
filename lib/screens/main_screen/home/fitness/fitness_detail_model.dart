// To parse this JSON data, do
//
//     final fitnessDetailModel = fitnessDetailModelFromJson(jsonString);

import 'dart:convert';

FitnessDetailModel fitnessDetailModelFromJson(String str) =>
    FitnessDetailModel.fromJson(json.decode(str));

String fitnessDetailModelToJson(FitnessDetailModel data) =>
    json.encode(data.toJson());

class FitnessDetailModel {
  FitnessDetailModel({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  String? success;
  String? status;
  String? message;
  FitnessData? data;

  factory FitnessDetailModel.fromJson(Map<String, dynamic> json) =>
      FitnessDetailModel(
        success: json["success"] == null ? null : json["success"],
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : FitnessData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toJson(),
      };
}

class FitnessData {
  FitnessData(
      {this.id,
      this.title,
      this.subTitle,
      this.price,
      this.image,
      this.trainer,
      this.description,
      this.countInCart});

  String? id;
  String? title;
  String? subTitle;
  String? price;
  String? countInCart;
  String? image;
  List<Trainer>? trainer;
  String? description;

  factory FitnessData.fromJson(Map<String, dynamic> json) => FitnessData(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        subTitle: json["sub_title"] == null ? null : json["sub_title"],
        price: json["price"] == null ? null : json["price"],
        image: json["image"] == null ? null : json["image"],
        countInCart:
            json["count_in_cart"] == null ? null : json["count_in_cart"],
        trainer: json["trainer"] == null
            ? null
            : List<Trainer>.from(
                json["trainer"].map((x) => Trainer.fromJson(x))),
        description: json["description"] == null ? null : json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "title": title == null ? null : title,
        "sub_title": subTitle == null ? null : subTitle,
        "price": price == null ? null : price,
        "count_in_cart": countInCart == null ? null : countInCart,
        "image": image == null ? null : image,
        "trainer": trainer == null
            ? null
            : List<dynamic>.from(trainer!.map((x) => x.toJson())),
        "description": description == null ? null : description,
      };
}

class Trainer {
  Trainer({
    this.id,
    this.image,
    this.name,
  });

  String? id;
  String? image;
  String? name;

  factory Trainer.fromJson(Map<String, dynamic> json) => Trainer(
        id: json["id"] == null ? null : json["id"],
        image: json["image"] == null ? null : json["image"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "image": image == null ? null : image,
        "name": name == null ? null : name,
      };
}
