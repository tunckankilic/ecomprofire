// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:ecomprofire/app/base/models/Product.dart';

class DIYmodel {
  final String id;
  final String title;
  final String description;
  final List<Product> products;
  final int amount;
  final double rating;
  final double price;
  DIYmodel({
    required this.id,
    required this.title,
    required this.description,
    required this.products,
    required this.amount,
    required this.rating,
    required this.price,
  });

  DIYmodel copyWith({
    String? id,
    String? title,
    String? description,
    List<Product>? products,
    int? amount,
    double? rating,
    double? price,
  }) {
    return DIYmodel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      products: products ?? this.products,
      amount: amount ?? this.amount,
      rating: rating ?? this.rating,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'products': products.map((x) => x.toMap()).toList(),
      'amount': amount,
      'rating': rating,
      'price': price,
    };
  }

  factory DIYmodel.fromMap(DocumentSnapshot map) {
    return DIYmodel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      products: List<Product>.from(
        (map['products'] as List<int>).map<Product>(
          (x) => Product.fromMap(x as Map<String, dynamic>),
        ),
      ),
      amount: map['amount'] as int,
      rating: map['rating'] as double,
      price: map['price'] as double,
    );
  }

  @override
  String toString() {
    return 'DIYmodel(id: $id, title: $title, description: $description, products: $products, amount: $amount, rating: $rating, price: $price)';
  }

  @override
  bool operator ==(covariant DIYmodel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.description == description &&
        listEquals(other.products, products) &&
        other.amount == amount &&
        other.rating == rating &&
        other.price == price;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        products.hashCode ^
        amount.hashCode ^
        rating.hashCode ^
        price.hashCode;
  }
}
