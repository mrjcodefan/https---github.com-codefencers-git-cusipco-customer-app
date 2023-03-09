// To parse this JSON data, do
//
//     final SliderListModel = SliderListModelFromJson(jsonString);

import 'dart:convert';

SliderListModel SliderListModelFromJson(String str) =>
    SliderListModel.fromJson(json.decode(str));

String SliderListModelToJson(SliderListModel data) =>
    json.encode(data.toJson());

class SliderListModel {
  SliderListModel({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  String? success;
  String? status;
  String? message;
  SliderListData? data;

  factory SliderListModel.fromJson(Map<String, dynamic> json) =>
      SliderListModel(
        success: json["success"] == null ? null : json["success"],
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data:
            json["data"] == null ? null : SliderListData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toJson(),
      };
}

class SliderListData {
  SliderListData({
    this.food,
    this.diet,
    this.store,
    this.skincare,
    this.fitness,
    this.home,
    this.therapy,
    this.labtest,
    this.consultWithDoctor,
    this.dentalCare,
  });

  List<SlideData>? food;
  List<SlideData>? diet;
  List<SlideData>? store;
  List<SlideData>? skincare;
  List<SlideData>? fitness;
  List<SlideData>? home;
  List<SlideData>? labtest;
  List<SlideData>? dentalCare;
  List<SlideData>? therapy;
  List<SlideData>? consultWithDoctor;
  factory SliderListData.fromJson(Map<String, dynamic> json) => SliderListData(
        food: json["Food"] == null
            ? []
            : List<SlideData>.from(
                json["Food"].map((x) => SlideData.fromJson(x))),
        consultWithDoctor: json["ConsultWithDoctor"] == null
            ? []
            : List<SlideData>.from(
                json["ConsultWithDoctor"].map((x) => SlideData.fromJson(x))),
        labtest: json["labtest"] == null
            ? []
            : List<SlideData>.from(
                json["labtest"].map((x) => SlideData.fromJson(x))),
        dentalCare: json["dentalCare"] == null
            ? []
            : List<SlideData>.from(
                json["dentalCare"].map((x) => SlideData.fromJson(x))),
        diet: json["Diet"] == null
            ? []
            : List<SlideData>.from(
                json["Diet"].map((x) => SlideData.fromJson(x))),
        store: json["store"] == null
            ? []
            : List<SlideData>.from(
                json["store"].map((x) => SlideData.fromJson(x))),
        skincare: json["skincare"] == null
            ? []
            : List<SlideData>.from(
                json["skincare"].map((x) => SlideData.fromJson(x))),
        fitness: json["Fitness"] == null
            ? []
            : List<SlideData>.from(
                json["Fitness"].map((x) => SlideData.fromJson(x))),
        home: json["Home"] == null
            ? []
            : List<SlideData>.from(
                json["Home"].map((x) => SlideData.fromJson(x))),

        //
        //
        therapy: json["Therapy"] == null
            ? []
            : List<SlideData>.from(
                json["Therapy"].map((x) => SlideData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Food": food == null
            ? null
            : List<dynamic>.from(food!.map((x) => x.toJson())),
        "labtest": food == null
            ? null
            : List<dynamic>.from(labtest!.map((x) => x.toJson())),
        "dentalCare": food == null
            ? null
            : List<dynamic>.from(dentalCare!.map((x) => x.toJson())),
        "ConsultWithDoctor": food == null
            ? null
            : List<dynamic>.from(consultWithDoctor!.map((x) => x.toJson())),
        "Diet": diet == null
            ? null
            : List<dynamic>.from(diet!.map((x) => x.toJson())),
        "store": store == null
            ? null
            : List<dynamic>.from(store!.map((x) => x.toJson())),
        "skincare": skincare == null
            ? null
            : List<dynamic>.from(skincare!.map((x) => x.toJson())),
        "Fitness": fitness == null
            ? null
            : List<dynamic>.from(fitness!.map((x) => x.toJson())),
        "Home": home == null
            ? null
            : List<dynamic>.from(home!.map((x) => x.toJson())),
        "Therapy": therapy == null
            ? null
            : List<dynamic>.from(therapy!.map((x) => x.toJson())),
      };
}

class SlideData {
  SlideData({
    this.id,
    this.title,
    this.tagline,
    this.image,
    this.isClickable,
    this.redirectTo,
    this.buttonText,
    this.description,
  });

  String? id;
  String? title;
  String? tagline;
  String? image;
  String? isClickable;
  String? redirectTo;
  String? buttonText;
  String? description;

  factory SlideData.fromJson(Map<String, dynamic> json) => SlideData(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        tagline: json["tagline"] == null ? null : json["tagline"],
        image: json["image"] == null ? null : json["image"],
        isClickable: json["is_clickable"] == null ? null : json["is_clickable"],
        redirectTo: json["redirect_to"] == null ? null : json["redirect_to"],
        buttonText: json["button_text"] == null ? null : json["button_text"],
        description: json["description"] == null ? null : json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "title": title == null ? null : title,
        "tagline": tagline == null ? null : tagline,
        "image": image == null ? null : image,
        "is_clickable": isClickable == null ? null : isClickable,
        "redirect_to": redirectTo == null ? null : redirectTo,
        "button_text": buttonText == null ? null : buttonText,
        "description": description == null ? null : description,
      };
}
