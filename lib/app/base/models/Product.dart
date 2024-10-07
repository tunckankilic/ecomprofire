// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Product {
  final String id;
  final String title;
  final String description;
  final List<String> images;
  final List<Color> colors;
  final double rating;
  final double price;
  final bool isPopular;
  final bool isFavourite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.images,
    required this.colors,
    required this.rating,
    required this.price,
    this.isPopular = false,
    this.isFavourite = false,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'images': images,
      'colors': colors.map((x) => x.value).toList(),
      'rating': rating,
      'price': price,
      'isPopular': isPopular,
      'isFavourite': isFavourite,
    };
  }

  factory Product.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Product(
      id: snapshot.id,
      title: data['title'] as String,
      description: data['description'] as String,
      images: List<String>.from(data['images']),
      colors: (data['colors'] as List<dynamic>)
          .map((colorValue) => Color(colorValue as int))
          .toList(),
      rating: (data['rating'] as num).toDouble(),
      price: (data['price'] as num).toDouble(),
      isFavourite: data['isFavourite'] as bool,
      isPopular: data['isPopular'] as bool,
    );
  }

  @override
  String toString() {
    return 'Product(id: $id, title: $title, description: $description, images: $images, colors: $colors, rating: $rating, price: $price, isPopular: $isPopular, isFavourite: $isFavourite)';
  }

  @override
  bool operator ==(covariant Product other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.description == description &&
        listEquals(other.images, images) &&
        listEquals(other.colors, colors) &&
        other.rating == rating &&
        other.price == price &&
        other.isPopular == isPopular &&
        other.isFavourite == isFavourite;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        images.hashCode ^
        colors.hashCode ^
        rating.hashCode ^
        price.hashCode ^
        isPopular.hashCode ^
        isFavourite.hashCode;
  }

  Product copyWith({
    String? id,
    String? title,
    String? description,
    List<String>? images,
    List<Color>? colors,
    double? rating,
    double? price,
    bool? isPopular,
    bool? isFavourite,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      images: images ?? this.images,
      colors: colors ?? this.colors,
      rating: rating ?? this.rating,
      price: price ?? this.price,
      isPopular: isPopular ?? this.isPopular,
      isFavourite: isFavourite ?? this.isFavourite,
    );
  }
}

// Our demo Products

List<Product> demoProducts = [
  Product(
    id: "1",
    images: [
      "assets/images/ps4_console_white_1.png",
      "assets/images/ps4_console_white_2.png",
      "assets/images/ps4_console_white_3.png",
      "assets/images/ps4_console_white_4.png",
    ],
    colors: [
      Color(0xFFF6625E),
      Color(0xFF836DB8),
      Color(0xFFDECB9C),
      Colors.white,
    ],
    title: "Wireless Controller for PS4™",
    price: 64.99,
    description: description,
    rating: 4.8,
    isFavourite: true,
    isPopular: true,
  ),
  Product(
    id: "2",
    images: [
      "assets/images/Image Popular Product 2.png",
    ],
    colors: [
      Color(0xFFF6625E),
      Color(0xFF836DB8),
      Color(0xFFDECB9C),
      Colors.white,
    ],
    title: "Nike Sport White - Man Pant",
    price: 50.5,
    description: description,
    rating: 4.1,
    isPopular: true,
  ),
  Product(
    id: "3",
    images: [
      "assets/images/glap.png",
    ],
    colors: [
      Color(0xFFF6625E),
      Color(0xFF836DB8),
      Color(0xFFDECB9C),
      Colors.white,
    ],
    title: "Gloves XC Omega - Polygon",
    price: 36.55,
    description: description,
    rating: 4.1,
    isFavourite: true,
    isPopular: true,
  ),
  Product(
    id: "4",
    images: [
      "assets/images/wireless headset.png",
    ],
    colors: [
      Color(0xFFF6625E),
      Color(0xFF836DB8),
      Color(0xFFDECB9C),
      Colors.white,
    ],
    title: "Logitech Head",
    price: 20.20,
    description: description,
    rating: 4.1,
    isFavourite: true,
  ),
];

const String description =
    "Wireless Controller for PS4™ gives you what you want in your gaming from over precision control your games to sharing …";
