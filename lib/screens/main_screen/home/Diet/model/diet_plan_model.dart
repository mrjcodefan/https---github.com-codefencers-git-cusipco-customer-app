// To parse this JSON data, do
//
//     final dietPlanListModel = dietPlanListModelFromJson(jsonString);

import 'dart:convert';

DietPlanListModel dietPlanListModelFromJson(String str) =>
    DietPlanListModel.fromJson(json.decode(str));

String dietPlanListModelToJson(DietPlanListModel data) =>
    json.encode(data.toJson());

class DietPlanListModel {
  DietPlanListModel({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  String? success;
  String? status;
  String? message;
  List<DietPlan>? data;

  factory DietPlanListModel.fromJson(Map<String, dynamic> json) =>
      DietPlanListModel(
        success: json["success"] == null ? null : json["success"],
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<DietPlan>.from(
                json["data"].map((x) => DietPlan.fromJson(x))),
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

class DietPlan {
  DietPlan({
    this.id,
    this.image,
    this.title,
    this.diatPlanType,
    this.price,
    this.tax,
    this.grandTotal,
    this.days,
    this.purchaseDate,
    this.expiryDate,
    this.benefits,
    this.dietChartUrl,
  });

  String? id;
  String? image;
  String? title;
  String? diatPlanType;
  String? price;
  String? tax;
  String? grandTotal;
  String? days;
  String? purchaseDate;
  String? expiryDate;
  List<Benefit>? benefits;
  String? dietChartUrl;

  factory DietPlan.fromJson(Map<String, dynamic> json) => DietPlan(
        id: json["id"] == null ? null : json["id"],
        image: json["image"] == null ? null : json["image"],
        title: json["title"] == null ? null : json["title"],
        diatPlanType:
            json["diat_plan_type"] == null ? null : json["diat_plan_type"],
        price: json["price"] == null ? null : json["price"],
        tax: json["tax"] == null ? null : json["tax"],
        grandTotal: json["grand_total"] == null ? null : json["grand_total"],
        days: json["days"] == null ? null : json["days"],
        purchaseDate:
            json["purchase_date"] == null ? null : json["purchase_date"],
        expiryDate: json["expiry_date"] == null ? null : json["expiry_date"],
        benefits: json["benefits"] == null
            ? null
            : List<Benefit>.from(
                json["benefits"].map((x) => Benefit.fromJson(x))),
        dietChartUrl:
            json["diet_chart_url"] == null ? null : json["diet_chart_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "image": image == null ? null : image,
        "title": title == null ? null : title,
        "diat_plan_type": diatPlanType == null ? null : diatPlanType,
        "price": price == null ? null : price,
        "tax": tax == null ? null : tax,
        "grand_total": grandTotal == null ? null : grandTotal,
        "days": days == null ? null : days,
        "purchase_date": purchaseDate == null ? null : purchaseDate,
        "expiry_date": expiryDate == null ? null : expiryDate,
        "benefits": benefits == null
            ? null
            : List<dynamic>.from(benefits!.map((x) => x.toJson())),
        "diet_chart_url": dietChartUrl == null ? null : dietChartUrl,
      };
}

class Benefit {
  Benefit({
    this.id,
    this.title,
  });

  String? id;
  String? title;

  factory Benefit.fromJson(Map<String, dynamic> json) => Benefit(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "title": title == null ? null : title,
      };
}
