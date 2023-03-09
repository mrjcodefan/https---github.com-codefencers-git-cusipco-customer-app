// To parse this JSON data, do
//
//     final ChartModel = ChartModelFromJson(jsonString);

import 'dart:convert';

ChartModel chartModelFromJson(String str) =>
    ChartModel.fromJson(json.decode(str));

String chartModelToJson(ChartModel data) => json.encode(data.toJson());

class ChartModel {
  ChartModel({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  String? success;
  String? status;
  String? message;
  ChartData? data;

  factory ChartModel.fromJson(Map<String, dynamic> json) => ChartModel(
        success: json["success"] == null ? null : json["success"],
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : ChartData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toJson(),
      };
}

class ChartData {
  ChartData({
    this.count,
    this.dietChart,
  });

  Count? count;
  List<DietChart>? dietChart;

  factory ChartData.fromJson(Map<String, dynamic> json) => ChartData(
        count: json["count"] == null ? null : Count.fromJson(json["count"]),
        dietChart: json["diet_chart"] == null
            ? null
            : List<DietChart>.from(
                json["diet_chart"].map((x) => DietChart.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count == null ? null : count!.toJson(),
        "diet_chart": dietChart == null
            ? null
            : List<ChartData>.from(dietChart!.map((x) => x.toJson())),
      };
}

class Count {
  Count({
    this.id,
    this.breakfast,
    this.lunch,
    this.dinner,
  });

  String? id;
  String? breakfast;
  String? lunch;
  String? dinner;

  factory Count.fromJson(Map<String, dynamic> json) => Count(
        id: json["id"] == null ? null : json["id"],
        breakfast: json["breakfast"] == null ? null : json["breakfast"],
        lunch: json["lunch"] == null ? null : json["lunch"],
        dinner: json["dinner"] == null ? null : json["dinner"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "breakfast": breakfast == null ? null : breakfast,
        "lunch": lunch == null ? null : lunch,
        "dinner": dinner == null ? null : dinner,
      };
}

class DietChart {
  DietChart({
    this.day,
    this.data,
  });

  String? day;
  List<ChartDataDetails>? data;

  factory DietChart.fromJson(Map<String, dynamic> json) => DietChart(
        day: json["day"] == null ? null : json["day"],
        data: json["data"] == null
            ? null
            : List<ChartDataDetails>.from(
                json["data"].map((x) => ChartDataDetails.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "day": day == null ? null : day,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ChartDataDetails {
  ChartDataDetails({
    this.mealType,
    this.meals,
  });

  String? mealType;
  List<Meal>? meals;

  factory ChartDataDetails.fromJson(Map<String, dynamic> json) =>
      ChartDataDetails(
        mealType: json["meal_type"] == null ? null : json["meal_type"],
        meals: json["meals"] == null
            ? null
            : List<Meal>.from(json["meals"].map((x) => Meal.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "meal_type": mealType == null ? null : mealType,
        "meals": meals == null
            ? null
            : List<dynamic>.from(meals!.map((x) => x.toJson())),
      };
}

class Meal {
  Meal({
    this.id,
    this.title,
  });

  String? id;
  String? title;

  factory Meal.fromJson(Map<String, dynamic> json) => Meal(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "title": title == null ? null : title,
      };
}
