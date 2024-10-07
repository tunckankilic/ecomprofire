// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:ecomprofire/app/base/models/Product.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class DIYModel {
  String id;
  String title;
  String description;
  String imagePath;
  List<String> steps;
  double price;
  DIYModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.steps,
    required this.price,
  });

  DIYModel copyWith({
    String? id,
    String? title,
    String? description,
    String? imagePath,
    List<String>? steps,
    double? price,
  }) {
    return DIYModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      steps: steps ?? this.steps,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'imagePath': imagePath,
      'steps': steps,
      'price': price,
    };
  }

  factory DIYModel.fromMap(Map<String, dynamic> map) {
    return DIYModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      imagePath: map['imagePath'] as String,
      steps: List<String>.from(
        (map['steps'] as List<String>),
      ),
      price: map['price'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory DIYModel.fromJson(String source) =>
      DIYModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DIYModel(id: $id, title: $title, description: $description, imagePath: $imagePath, steps: $steps, price: $price)';
  }

  @override
  bool operator ==(covariant DIYModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.description == description &&
        other.imagePath == imagePath &&
        listEquals(other.steps, steps) &&
        other.price == price;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        imagePath.hashCode ^
        steps.hashCode ^
        price.hashCode;
  }
}
