// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
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

  factory Checkout.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Checkout(
      id: snapshot.id,
      products: List<Product>.from(
        (data['products'] as List<dynamic>).map(
          (productData) => Product.fromSnapshot(productData),
        ),
      ),
      total: data['total'] as int,
    );
  }

  String toJson() => json.encode(toMap());

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
