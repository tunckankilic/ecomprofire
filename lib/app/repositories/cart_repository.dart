import 'package:cloud_firestore/cloud_firestore.dart';
import '../../app/base/models/cart.dart';

class CartRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _cartCollection = 'carts';

  Stream<List<Cart>> getCartItems() {
    return _firestore.collection(_cartCollection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Cart.fromSnapshot(doc)).toList();
    });
  }

  Future<void> removeCartItem(String cartItemId) {
    return _firestore.collection(_cartCollection).doc(cartItemId).delete();
  }

  Future<void> addCartItem(Cart cart) {
    return _firestore
        .collection(_cartCollection)
        .doc(cart.id)
        .set(cart.toJson());
  }

  Future<void> updateCartItem(Cart cart) {
    return _firestore
        .collection(_cartCollection)
        .doc(cart.id)
        .update(cart.toJson());
  }

  Future<void> clearCart() {
    return _firestore.collection(_cartCollection).get().then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
  }

  Future<Cart?> getCartItem(String cartItemId) async {
    final doc =
        await _firestore.collection(_cartCollection).doc(cartItemId).get();
    return doc.exists ? Cart.fromSnapshot(doc) : null;
  }

  Future<void> incrementItemQuantity(String cartItemId) async {
    return _firestore
        .collection(_cartCollection)
        .doc(cartItemId)
        .update({'numOfItem': FieldValue.increment(1)});
  }

  Future<void> decrementItemQuantity(String cartItemId) async {
    final doc =
        await _firestore.collection(_cartCollection).doc(cartItemId).get();
    final currentQuantity =
        (doc.data() as Map<String, dynamic>)['numOfItem'] as int;

    if (currentQuantity > 1) {
      return _firestore
          .collection(_cartCollection)
          .doc(cartItemId)
          .update({'numOfItem': FieldValue.increment(-1)});
    } else {
      return removeCartItem(cartItemId);
    }
  }
}
