import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomprofire/app/base/base.dart';

class ProductRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Product>> getAllProducts() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('products').get();
      return querySnapshot.docs
          .map((doc) => Product.fromSnapshot(doc))
          .toList();
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }

  Future<Product?> getProductById(String id) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('products').doc(id).get();
      if (doc.exists) {
        return Product.fromSnapshot(doc);
      }
      return null;
    } catch (e) {
      print('Error fetching product: $e');
      return null;
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      await _firestore.collection('products').add(product.toMap());
    } catch (e) {
      print('Error adding product: $e');
      throw e;
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      await _firestore
          .collection('products')
          .doc(product.id)
          .update(product.toMap());
    } catch (e) {
      print('Error updating product: $e');
      throw e;
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await _firestore.collection('products').doc(id).delete();
    } catch (e) {
      print('Error deleting product: $e');
      throw e;
    }
  }
}
