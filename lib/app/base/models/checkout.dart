// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:ecomprofire/app/base/models/product.dart';

class Checkout {
  final String id;
  final List<Product> products;
  final int total;
  Checkout({
    required this.id,
    required this.products,
    required this.total,
  });

  Checkout copyWith({
    String? id,
    List<Product>? products,
    int? total,
  }) {
    return Checkout(
      id: id ?? this.id,
      products: products ?? this.products,
      total: total ?? this.total,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'products': products.map((x) => x.toMap()).toList(),
      'total': total,
    };
  }

  factory Checkout.fromMap(Map<String, dynamic> map) {
    return Checkout(
      id: map['id'] as String,
      products: List<Product>.from(
        (map['products'] as List<int>).map<Product>(
          (x) => Product.fromMap(x as Map<String, dynamic>),
        ),
      ),
      total: map['total'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Checkout.fromJson(String source) =>
      Checkout.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Checkout(id: $id, products: $products, total: $total)';

  @override
  bool operator ==(covariant Checkout other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        listEquals(other.products, products) &&
        other.total == total;
  }

  @override
  int get hashCode => id.hashCode ^ products.hashCode ^ total.hashCode;
}
