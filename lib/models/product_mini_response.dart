// To parse this JSON data, do
//
//     final productMiniResponse = productMiniResponseFromJson(jsonString);

import 'dart:convert';

import 'package:grostore/models/common/category_info.dart';

import 'product_details_response.dart';

ProductMiniResponse productMiniResponseFromJson(String str) {
  try {
    var decodedJson = json.decode(str);

    if (decodedJson is Map<String, dynamic> &&
        decodedJson.containsKey("data")) {
      return ProductMiniResponse.fromJson(decodedJson);
    } else {
      print("Invalid JSON structure: $decodedJson");
      return ProductMiniResponse(data: []);
    }
  } catch (e) {
    print("Error decoding JSON: $e");
    return ProductMiniResponse(data: []);
  }
}
// ProductMiniResponse.fromJson(json.decode(str));

String productMiniResponseToJson(ProductMiniResponse data) =>
    json.encode(data.toJson());

class ProductMiniResponse {
  List<ProductMini> data;

  ProductMiniResponse({
    required this.data,
  });

  factory ProductMiniResponse.fromJson(Map<String, dynamic> json) =>
      ProductMiniResponse(
        data: List<ProductMini>.from(
            json["data"].map((x) => ProductMini.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class ProductMini {
  int id;
  String name;
  String slug;
  String brand;
  String unit;
  String thumbnailImage;
  String price;
  bool isDiscounted;
  int discount;
  var rewardPovars;
  List<CategoryInfo> categories;
  List<Variation> variations;

  ProductMini({
    required this.id,
    required this.variations,
    required this.name,
    required this.slug,
    required this.brand,
    required this.unit,
    required this.thumbnailImage,
    required this.price,
    required this.isDiscounted,
    required this.discount,
    required this.rewardPovars,
    required this.categories,
  });

  factory ProductMini.fromJson(Map<String, dynamic> json) => ProductMini(
        id: json["id"] ?? 0, // Ensuring 'id' is never null
        name: json["name"] ?? "", // Default empty string
        slug: json["slug"] ?? "",
        brand: json["brand"] ?? "",
        unit: json["unit"] ?? "",
        thumbnailImage: json["thumbnail_image"] ?? "",
        price:
            json["price"]?.toString() ?? "0.0", // Converting to string safely
        isDiscounted: json["is_discounted"] ?? false,
        discount: json["discount"] ?? 0,
        rewardPovars: json["reward_povars"] ?? 0,
        categories: json["categories"] != null
            ? List<CategoryInfo>.from(
                json["categories"].map((x) => CategoryInfo.fromJson(x)))
            : [],
        variations: json["variations"] != null
            ? List<Variation>.from(
                json["variations"].map((x) => Variation.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "slug": slug,
        "brand": brand,
        "unit": unit,
        "thumbnail_image": thumbnailImage,
        "price": price,
        "is_discounted": isDiscounted,
        "discount": discount,
        "reward_povars": rewardPovars,
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
      };
}
