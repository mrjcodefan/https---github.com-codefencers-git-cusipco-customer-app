// To parse this JSON data, do
//
//     final checkOutModel = checkOutModelFromJson(jsonString);

import 'dart:convert';

CheckOutModel checkOutModelFromJson(String str) =>
    CheckOutModel.fromJson(json.decode(str));

String checkOutModelToJson(CheckOutModel data) => json.encode(data.toJson());

class CheckOutModel {
  CheckOutModel({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  String? success;
  String? status;
  String? message;
  CheckOutData? data;

  factory CheckOutModel.fromJson(Map<String, dynamic> json) => CheckOutModel(
        success: json["success"] == null ? null : json["success"],
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : CheckOutData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toJson(),
      };
}

class CheckOutData {
  CheckOutData({
    this.totalItem,
    this.tax,
    this.totalAmount,
    this.items,
    this.address,
    this.itemTotal,
    this.grandTotal,
    this.paymentMethods,
    this.deliveryFee,
    this.couponDiscount,
    this.isItemDiscount,
    this.isDeliveryCharge,
    this.itemDiscount,
    this.totalSavings,
    this.textLabel,
    this.isShowDeliveryAddress,
  });

  String? totalItem;
  String? tax;
  String? totalAmount;
  String? grandTotal;

  String? itemTotal;
  String? deliveryFee;
  String? couponDiscount;
  String? itemDiscount;
  String? totalSavings;
  String? isItemDiscount;
  String? isDeliveryCharge;
  String? textLabel;
  String? isShowDeliveryAddress;

  List<CheckOutItem>? items;
  List<CheckOutAddress>? address;
  List<PaymentMethod>? paymentMethods;

  factory CheckOutData.fromJson(Map<String, dynamic> json) => CheckOutData(
        totalItem: json["total_item"] == null ? null : json["total_item"],
        tax: json["tax"] == null ? null : json["tax"],
        isShowDeliveryAddress: json["is_show_delivery_address"] == null
            ? null
            : json["is_show_delivery_address"],
        grandTotal: json["grand_total"] == null ? null : json["grand_total"],
        itemTotal: json["item_total"] == null ? null : json["item_total"],
        deliveryFee: json["delivery_fee"] == null ? null : json["delivery_fee"],
        couponDiscount:
            json["coupon_discount"] == null ? null : json["coupon_discount"],
        itemDiscount:
            json["item_discount"] == null ? null : json["item_discount"],
        totalAmount: json["total_amount"] == null ? null : json["total_amount"],
        totalSavings:
            json["total_savings"] == null ? null : json["total_savings"],
        isItemDiscount:
            json["is_item_discount"] == null ? null : json["is_item_discount"],
        isDeliveryCharge: json["is_delivery_charge"] == null
            ? null
            : json["is_delivery_charge"],
        textLabel: json["tax_label"] == null ? null : json["tax_label"],
        items: json["items"] == null
            ? null
            : List<CheckOutItem>.from(
                json["items"].map((x) => CheckOutItem.fromJson(x))),
        address: json["address"] == null
            ? null
            : List<CheckOutAddress>.from(
                json["address"].map((x) => CheckOutAddress.fromJson(x))),
        paymentMethods: json["payment_methods"] == null
            ? null
            : List<PaymentMethod>.from(
                json["payment_methods"].map((x) => PaymentMethod.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_item": totalItem == null ? null : totalItem,
        "tax": tax == null ? null : tax,
        "is_show_delivery_address":
            isShowDeliveryAddress == null ? null : isShowDeliveryAddress,
        "textLabel": textLabel == null ? null : textLabel,
        "grand_total": grandTotal == null ? null : grandTotal,
        "item_total": itemTotal == null ? null : itemTotal,
        "delivery_fee": deliveryFee == null ? null : deliveryFee,
        "coupon_discount": couponDiscount == null ? null : couponDiscount,
        "total_amount": totalAmount == null ? null : totalAmount,
        "item_discount": itemDiscount == null ? null : itemDiscount,
        "total_savings": totalSavings == null ? null : totalSavings,
        "items": items == null
            ? null
            : List<dynamic>.from(items!.map((x) => x.toJson())),
        "address": address == null
            ? null
            : List<dynamic>.from(address!.map((x) => x.toJson())),
        "payment_methods": paymentMethods == null
            ? null
            : List<dynamic>.from(paymentMethods!.map((x) => x.toJson())),
      };
}

class CheckOutAddress {
  CheckOutAddress({
    this.id,
    this.name,
    this.phoneNumber,
    this.addressType,
    this.address,
    this.pincode,
    this.latitude,
    this.longitude,
  });

  String? id;
  String? name;
  String? phoneNumber;
  String? addressType;
  String? address;
  String? pincode;
  String? latitude;
  String? longitude;

  factory CheckOutAddress.fromJson(Map<String, dynamic> json) =>
      CheckOutAddress(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        phoneNumber: json["phone_number"] == null ? null : json["phone_number"],
        addressType: json["address_type"] == null ? null : json["address_type"],
        address: json["address"] == null ? null : json["address"],
        pincode: json["pincode"] == null ? null : json["pincode"],
        latitude: json["latitude"] == null ? null : json["latitude"],
        longitude: json["longitude"] == null ? null : json["longitude"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "phone_number": phoneNumber == null ? null : phoneNumber,
        "address_type": addressType == null ? null : addressType,
        "address": address == null ? null : address,
        "pincode": pincode == null ? null : pincode,
        "latitude": latitude == null ? null : latitude,
        "longitude": longitude == null ? null : longitude,
      };
}

class CheckOutItem {
  CheckOutItem({
    this.id,
    this.productId,
    this.title,
    this.image,
    this.ownerId,
    this.quantity,
    this.price,
    this.salePrice,
    this.priceTxt,
    this.description,
  });

  String? id;
  String? productId;
  String? title;
  String? image;
  String? ownerId;
  String? quantity;
  String? price;
  String? salePrice;
  String? priceTxt;
  String? description;

  factory CheckOutItem.fromJson(Map<String, dynamic> json) => CheckOutItem(
        id: json["id"] == null ? null : json["id"],
        productId: json["product_id"] == null ? null : json["product_id"],
        title: json["title"] == null ? null : json["title"],
        image: json["image"] == null ? null : json["image"],
        ownerId: json["owner_id"] == null ? null : json["owner_id"],
        quantity: json["quantity"] == null ? null : json["quantity"],
        price: json["price"] == null ? null : json["price"],
        salePrice: json["sale_price"] == null ? null : json["sale_price"],
        priceTxt: json["price_txt"] == null ? null : json["price_txt"],
        description: json["description"] == null ? null : json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "product_id": productId == null ? null : productId,
        "title": title == null ? null : title,
        "image": image == null ? null : image,
        "owner_id": ownerId == null ? null : ownerId,
        "quantity": quantity == null ? null : quantity,
        "price": price == null ? null : price,
        "sale_price": salePrice == null ? null : salePrice,
        "price_txt": priceTxt == null ? null : priceTxt,
        "description": description == null ? null : description,
      };
}

class PaymentMethod {
  PaymentMethod({
    this.id,
    this.title,
  });

  String? id;
  String? title;

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "title": title == null ? null : title,
      };
}
