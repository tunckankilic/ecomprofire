import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Product.dart';

class Cart {
  final String id;
  final Product product;
  int numOfItem;

  Cart({
    required this.id,
    required this.product,
    required this.numOfItem,
  });

  Cart copyWith({
    String? id,
    Product? product,
    int? numOfItem,
  }) {
    return Cart(
      id: id ?? this.id,
      product: product ?? this.product,
      numOfItem: numOfItem ?? this.numOfItem,
    );
  }

  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
      id: map['id'] as String,
      product: Product.fromSnapshot(map['product']),
      numOfItem: map['numOfItem'] as int,
    );
  }

  factory Cart.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Cart(
      id: snapshot.id,
      product: Product.fromSnapshot(data['product']),
      numOfItem: data['numOfItem'] as int,
    );
  }

  // Yeni eklenen toJson metodu
  Map<String, dynamic> toJson() => {
        'id': id,
        'product': product.toMap(), // Product sınıfında da toJson metodu olmalı
        'numOfItem': numOfItem,
      };

  // Toplam fiyatı hesaplayan getter
  double get totalPrice => product.price * numOfItem;

  // Ürün miktarını artıran metod
  void incrementQuantity() {
    numOfItem++;
  }

  // Ürün miktarını azaltan metod
  void decrementQuantity() {
    if (numOfItem > 1) {
      numOfItem--;
    }
  }

  // Belirli bir miktar kadar ürün ekleyen metod
  void addQuantity(int quantity) {
    numOfItem += quantity;
  }

  @override
  String toString() =>
      'Cart(id: $id, product: ${product.title}, numOfItem: $numOfItem, totalPrice: $totalPrice)';

  @override
  bool operator ==(covariant Cart other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.product == product &&
        other.numOfItem == numOfItem;
  }

  @override
  int get hashCode => id.hashCode ^ product.hashCode ^ numOfItem.hashCode;
}

// Demo data for our cart
List<Cart> demoCarts = [
  Cart(id: '1', product: demoProducts[0], numOfItem: 2),
  Cart(id: '2', product: demoProducts[1], numOfItem: 1),
  Cart(id: '3', product: demoProducts[3], numOfItem: 1),
];
