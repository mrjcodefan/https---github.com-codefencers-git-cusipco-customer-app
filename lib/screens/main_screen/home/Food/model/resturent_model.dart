import 'dart:convert';

ResturentModel resturentModelFromJson(String str) =>
    ResturentModel.fromJson(json.decode(str));

String resturentModelToJson(ResturentModel data) => json.encode(data.toJson());

class ResturentModel {
  ResturentModel({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  String? success;
  String? status;
  String? message;
  List<ResturentData>? data;

  factory ResturentModel.fromJson(Map<String, dynamic> json) => ResturentModel(
        success: json["success"] == null ? null : json["success"],
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<ResturentData>.from(
                json["data"].map((x) => ResturentData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ResturentData {
  ResturentData({
    this.id,
    this.image,
    this.title,
    this.location,
    this.rating,
    this.status,
  });

  String? id;
  String? image;
  String? title;
  String? location;
  String? rating;
  String? status;
  factory ResturentData.fromJson(Map<String, dynamic> json) => ResturentData(
        id: json["id"] == null ? null : json["id"],
        image: json["image"] == null ? null : json["image"],
        title: json["title"] == null ? null : json["title"],
        location: json["location"] == null ? null : json["location"],
        rating: json["rating"] == null ? null : json["rating"],
        status: json["status"] == null ? null : json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "image": image == null ? null : image,
        "title": title == null ? null : title,
        "location": location == null ? null : location,
        "rating": rating == null ? null : rating,
        "status": status == null ? null : status,
      };
}
