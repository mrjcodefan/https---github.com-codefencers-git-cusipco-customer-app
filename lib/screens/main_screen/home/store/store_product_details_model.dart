// To parse this JSON data, do
//
//     final storeProductDetailsModel = storeProductDetailsModelFromJson(jsonString);

import 'dart:convert';

StoreProductDetailsModel storeProductDetailsModelFromJson(String str) =>
    StoreProductDetailsModel.fromJson(json.decode(str));

String storeProductDetailsModelToJson(StoreProductDetailsModel data) =>
    json.encode(data.toJson());

class StoreProductDetailsModel {
  StoreProductDetailsModel({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  String? success;
  String? status;
  String? message;
  StoreProductDetailsData? data;

  factory StoreProductDetailsModel.fromJson(Map<String, dynamic> json) =>
      StoreProductDetailsModel(
        success: json["success"] == null ? null : json["success"].toString(),
        status: json["status"] == null ? null : json["status"].toString(),
        message: json["message"] == null ? null : json["message"].toString(),
        data: json["data"] == null
            ? null
            : StoreProductDetailsData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toJson(),
      };
}

class StoreProductDetailsData {
  StoreProductDetailsData(
      {this.id,
      this.title,
      this.image,
      this.soldBy,
      this.price,
      this.salePrice,
      this.description,
      this.variation,
      this.isCart,
      this.variations,
      this.sellers,
      this.countInCart});

  String? id;
  String? title;
  List<String>? image;
  String? soldBy;
  String? price;
  String? salePrice;
  String? description;
  String? countInCart;
  String? variation;
  String? isCart;
  List<Variation>? variations;
  List<Seller>? sellers;

  factory StoreProductDetailsData.fromJson(Map<String, dynamic> json) =>
      StoreProductDetailsData(
        id: json["id"] == null ? null : json["id"].toString(),
        title: json["title"] == null ? null : json["title"],
        image: json["image"] == null
            ? null
            : List<String>.from(json["image"].map((x) => x)),
        soldBy: json["sold_by"] == null ? null : json["sold_by"],
        price: json["price"] == null ? null : json["price"],
        countInCart:
            json["count_in_cart"] == null ? null : json["count_in_cart"],
        salePrice: json["sale_price"] == null ? null : json["sale_price"],
        description: json["description"] == null ? null : json["description"],
        variation: json["variation"] == null ? null : json["variation"],
        isCart: json["is_cart"] == null ? null : json["is_cart"],
        variations: json["variations"] == null
            ? null
            : List<Variation>.from(
                json["variations"].map((x) => Variation.fromJson(x))),
        sellers: json["sellers"] == null
            ? null
            : List<Seller>.from(json["sellers"].map((x) => Seller.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "title": title == null ? null : title,
        "image":
            image == null ? null : List<dynamic>.from(image!.map((x) => x)),
        "sold_by": soldBy == null ? null : soldBy,
        "price": price == null ? null : price,
        "sale_price": salePrice == null ? null : salePrice,
        "count_in_cart": countInCart == null ? null : countInCart,
        "description": description == null ? null : description,
        "variation": variation == null ? null : variation,
        "is_cart": isCart == null ? null : isCart,
        "variations": variations == null
            ? null
            : List<dynamic>.from(variations!.map((x) => x.toJson())),
        "sellers": sellers == null
            ? null
            : List<dynamic>.from(sellers!.map((x) => x.toJson())),
      };
}

class Seller {
  Seller({
    this.id,
    this.ownerId,
    this.categoryId,
    this.productinfoId,
    this.brandId,
    this.module,
    this.image,
    this.quantity,
    this.price,
    this.salePrice,
    this.sku,
    this.type,
    this.status,
    this.seoMeta,
    this.seoTitle,
    this.seoKeywords,
    this.seoDescription,
    this.createdAt,
    this.updatedAt,
    this.title,
    this.description,
    this.soldBy,
    this.variation,
    this.variationId,
    this.translations,
    this.isCart,
  });

  String? id;
  String? ownerId;
  String? categoryId;
  String? productinfoId;
  String? brandId;
  String? module;
  String? image;
  String? quantity;
  String? price;
  String? salePrice;
  String? sku;
  String? type;
  String? status;
  String? seoMeta;
  String? seoTitle;
  String? seoKeywords;
  String? seoDescription;
  String? createdAt;
  String? updatedAt;
  String? soldBy;
  String? title;
  String? description;
  String? variation;
  String? variationId;
  String? isCart;

  List<Translation>? translations;

  factory Seller.fromJson(Map<String, dynamic> json) => Seller(
        id: json["id"] == null ? null : json["id"].toString(),
        isCart: json["is_cart"] == null ? null : json["is_cart"].toString(),
        variationId: json["variation_id"] == null
            ? null
            : json["variation_id"].toString(),
        ownerId: json["owner_id"] == null ? null : json["owner_id"].toString(),
        categoryId:
            json["category_id"] == null ? null : json["category_id"].toString(),
        productinfoId: json["productinfo_id"] == null
            ? null
            : json["productinfo_id"].toString(),
        brandId: json["brand_id"] == null ? null : json["brand_id"].toString(),
        variation:
            json["variation"] == null ? null : json["variation"].toString(),
        soldBy: json["sold_by"] == null ? null : json["sold_by"].toString(),
        module: json["module"] == null ? null : json["module"].toString(),
        image: json["image"] == null ? null : json["image"].toString(),
        quantity: json["quantity"].toString(),
        price: json["price"] == null ? null : json["price"].toString(),
        salePrice:
            json["sale_price"] == null ? null : json["sale_price"].toString(),
        sku: json["sku"].toString(),
        type: json["type"] == null ? null : json["type"].toString(),
        status: json["status"] == null ? null : json["status"].toString(),
        seoMeta: json["seo_meta"].toString(),
        seoTitle:
            json["seo_title"] == null ? null : json["seo_title"].toString(),
        seoKeywords: json["seo_keywords"] == null
            ? null
            : json["seo_keywords"].toString(),
        seoDescription: json["seo_description"] == null
            ? null
            : json["seo_description"].toString(),
        createdAt:
            json["created_at"] == null ? null : json["created_at"].toString(),
        updatedAt:
            json["updated_at"] == null ? null : json["updated_at"].toString(),
        title: json["title"] == null ? null : json["title"].toString(),
        description:
            json["description"] == null ? null : json["description"].toString(),
        translations: json["translations"] == null
            ? null
            : List<Translation>.from(
                json["translations"].map((x) => Translation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "is_cart": isCart == null ? null : isCart,
        "sold_by": soldBy == null ? null : soldBy,
        "owner_id": ownerId == null ? null : ownerId,
        "category_id": categoryId == null ? null : categoryId,
        "productinfo_id": productinfoId == null ? null : productinfoId,
        "variation": variation == null ? null : variation,
        "variation_id": variationId == null ? null : variationId,
        "brand_id": brandId == null ? null : brandId,
        "module": module == null ? null : module,
        "image": image == null ? null : image,
        "quantity": quantity,
        "price": price == null ? null : price,
        "sale_price": salePrice == null ? null : salePrice,
        "sku": sku,
        "type": type == null ? null : type,
        "status": status == null ? null : status,
        "seo_meta": seoMeta,
        "seo_title": seoTitle == null ? null : seoTitle,
        "seo_keywords": seoKeywords == null ? null : seoKeywords,
        "seo_description": seoDescription == null ? null : seoDescription,
        "created_at": createdAt == null ? null : createdAt,
        "updated_at": updatedAt == null ? null : updatedAt,
        "title": title == null ? null : title,
        "description": description == null ? null : description,
        "translations": translations == null
            ? null
            : List<dynamic>.from(translations!.map((x) => x.toJson())),
      };
}

class Translation {
  Translation({
    this.id,
    this.productId,
    this.title,
    this.description,
    this.locale,
  });

  String? id;
  String? productId;
  String? title;
  String? description;
  String? locale;

  factory Translation.fromJson(Map<String, dynamic> json) => Translation(
        id: json["id"] == null ? null : json["id"].toString(),
        productId:
            json["product_id"] == null ? null : json["product_id"].toString(),
        title: json["title"] == null ? null : json["title"].toString(),
        description:
            json["description"] == null ? null : json["description"].toString(),
        locale: json["locale"] == null ? null : json["locale"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "product_id": productId == null ? null : productId,
        "title": title == null ? null : title,
        "description": description == null ? null : description,
        "locale": locale == null ? null : locale,
      };
}

class Variation {
  Variation({
    this.id,
    this.productId,
    this.variationId,
    this.variationGroupId,
    this.price,
    this.salePrice,
    this.createdAt,
    this.updatedAt,
    this.title,
  });

  String? id;
  String? productId;
  String? variationId;
  String? variationGroupId;
  String? price;
  String? salePrice;
  String? createdAt;
  String? updatedAt;
  String? title;
  factory Variation.fromJson(Map<String, dynamic> json) => Variation(
        id: json["id"] == null ? null : json["id"].toString(),
        productId:
            json["product_id"] == null ? null : json["product_id"].toString(),
        title: json["title"] == null ? null : json["title"].toString(),
        variationId: json["variation_id"] == null
            ? null
            : json["variation_id"].toString(),
        variationGroupId: json["variation_group_id"] == null
            ? null
            : json["variation_group_id"].toString(),
        price: json["price"] == null ? null : json["price"].toString(),
        salePrice:
            json["sale_price"] == null ? null : json["sale_price"].toString(),
        createdAt:
            json["created_at"] == null ? null : json["created_at"].toString(),
        updatedAt:
            json["updated_at"] == null ? null : json["updated_at"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "title": title == null ? null : title,
        "product_id": productId == null ? null : productId,
        "variation_id": variationId == null ? null : variationId,
        "variation_group_id":
            variationGroupId == null ? null : variationGroupId,
        "price": price == null ? null : price,
        "sale_price": salePrice == null ? null : salePrice,
        "created_at": createdAt == null ? null : createdAt,
        "updated_at": updatedAt == null ? null : updatedAt,
      };
}
