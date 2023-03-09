// To parse this JSON data, do
//
//     final mySubscriptionModel = mySubscriptionModelFromJson(jsonString);

import 'dart:convert';

MySubscriptionModel mySubscriptionModelFromJson(String str) =>
    MySubscriptionModel.fromJson(json.decode(str));

String mySubscriptionModelToJson(MySubscriptionModel data) =>
    json.encode(data.toJson());

class MySubscriptionModel {
  MySubscriptionModel({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  String? success;
  String? status;
  String? message;
  MySubscriptionData? data;

  factory MySubscriptionModel.fromJson(Map<String, dynamic> json) =>
      MySubscriptionModel(
        success: json["success"] == null ? null : json["success"],
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : MySubscriptionData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toJson(),
      };
}

class MySubscriptionData {
  MySubscriptionData({
    this.restaurants,
    this.dietPlans,
  });

  List<MySubscriptionDataRestaurant>? restaurants;
  List<MySubscriptionDataDietPlan>? dietPlans;

  factory MySubscriptionData.fromJson(Map<String, dynamic> json) =>
      MySubscriptionData(
        restaurants: json["restaurants"] == null
            ? null
            : List<MySubscriptionDataRestaurant>.from(json["restaurants"]
                .map((x) => MySubscriptionDataRestaurant.fromJson(x))),
        dietPlans: json["diet_plans"] == null
            ? null
            : List<MySubscriptionDataDietPlan>.from(json["diet_plans"]
                .map((x) => MySubscriptionDataDietPlan.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "restaurants": restaurants == null
            ? null
            : List<dynamic>.from(restaurants!.map((x) => x.toJson())),
        "diet_plans": dietPlans == null
            ? null
            : List<dynamic>.from(dietPlans!.map((x) => x.toJson())),
      };
}

class MySubscriptionDataDietPlan {
  MySubscriptionDataDietPlan({
    this.id,
    this.title,
    this.diatPlanType,
    this.price,
    this.purchaseDate,
    this.expiryDate,
    this.benefits,
    this.image,
    this.dietChartUrl,
  });

  String? id;
  String? title;
  String? diatPlanType;
  String? price;
  String? purchaseDate;
  String? expiryDate;
  String? dietChartUrl;
  String? image;
  List<MySubscriptionDataDietPlanBenefit>? benefits;

  factory MySubscriptionDataDietPlan.fromJson(Map<String, dynamic> json) =>
      MySubscriptionDataDietPlan(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        diatPlanType:
            json["diat_plan_type"] == null ? null : json["diat_plan_type"],
        price: json["price"] == null ? null : json["price"],
        purchaseDate:
            json["purchase_date"] == null ? null : json["purchase_date"],
        expiryDate: json["expiry_date"] == null ? null : json["expiry_date"],
        dietChartUrl:
            json["diet_chart_url"] == null ? null : json["diet_chart_url"],
        image: json["image"] == null ? null : json["image"],
        benefits: json["benefits"] == null
            ? null
            : List<MySubscriptionDataDietPlanBenefit>.from(json["benefits"]
                .map((x) => MySubscriptionDataDietPlanBenefit.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "title": title == null ? null : title,
        "diat_plan_type": diatPlanType == null ? null : diatPlanType,
        "price": price == null ? null : price,
        "image": image == null ? null : image,
        "diet_chart_url": dietChartUrl == null ? null : dietChartUrl,
        "purchase_date": purchaseDate == null ? null : purchaseDate,
        "expiry_date": expiryDate == null ? null : expiryDate,
        "benefits": benefits == null
            ? null
            : List<dynamic>.from(benefits!.map((x) => x.toJson())),
      };
}

class MySubscriptionDataDietPlanBenefit {
  MySubscriptionDataDietPlanBenefit({
    this.id,
    this.title,
  });

  String? id;
  String? title;

  factory MySubscriptionDataDietPlanBenefit.fromJson(
          Map<String, dynamic> json) =>
      MySubscriptionDataDietPlanBenefit(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "title": title == null ? null : title,
      };
}

class MySubscriptionDataRestaurant {
  MySubscriptionDataRestaurant({
    this.title,
    this.id,
    this.days,
    this.planType,
    this.status,
    this.image,
    this.isExpired,
    this.paymentUrl,
    this.dietChartId,
    this.deliveryFee,
    this.itemTotal,
    this.restaurantCharges,
    this.tax,
    this.grandTotal,
    this.showPaymentOption,
    this.healuCharges,
  });

  String? title;
  String? id;
  String? days;
  String? planType;
  String? status;
  String? restaurantCharges;
  String? image;
  String? isExpired;

  String? paymentUrl;
  String? tax;
  String? deliveryFee;
  String? itemTotal;
  String? grandTotal;

  String? dietChartId;
  String? showPaymentOption;
  String? healuCharges;
  factory MySubscriptionDataRestaurant.fromJson(Map<String, dynamic> json) =>
      MySubscriptionDataRestaurant(
        title: json["title"] == null ? null : json["title"],
        id: json["id"] == null ? null : json["id"],
        days: json["days"] == null ? null : json["days"],
        planType: json["plan_type"] == null ? null : json["plan_type"],
        status: json["status"] == null ? null : json["status"],
        tax: json["tax"] == null ? null : json["tax"],
        restaurantCharges: json["restaurant_charges"] == null
            ? null
            : json["restaurant_charges"],
        image: json["image"] == null ? null : json["image"],
        deliveryFee: json["delivery_fee"] == null ? null : json["delivery_fee"],
        itemTotal: json["item_total"] == null ? null : json["item_total"],
        isExpired: json["is_expired"] == null ? null : json["is_expired"],
        paymentUrl: json["payment_url"] == null ? null : json["payment_url"],
        healuCharges:
            json["healu_charges"] == null ? null : json["healu_charges"],
        grandTotal: json["grand_total"] == null ? null : json["grand_total"],
        dietChartId:
            json["diet_chart_id"] == null ? null : json["diet_chart_id"],
        showPaymentOption: json["show_payment_option"] == null
            ? null
            : json["show_payment_option"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "title": title == null ? null : title,
        "days": days == null ? null : days,
        "plan_type": planType == null ? null : planType,
        "status": status == null ? null : status,
        "restaurant_charges":
            restaurantCharges == null ? null : restaurantCharges,
        "payment_url": paymentUrl == null ? null : paymentUrl,
        "healu_charges": healuCharges == null ? null : healuCharges,
        "diet_chart_id": dietChartId == null ? null : dietChartId,
        "delivery_fee": deliveryFee == null ? null : deliveryFee,
        "grand_total": grandTotal == null ? null : grandTotal,
        "item_total": itemTotal == null ? null : itemTotal,
        "image": image == null ? null : image,
        "is_expired": isExpired == null ? null : isExpired,
        "show_payment_option":
            showPaymentOption == null ? null : showPaymentOption,
      };
}
