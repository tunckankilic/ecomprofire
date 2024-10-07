import 'package:ecomprofire/app/repositories/repositories.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../app/base/models/cart.dart';

class CartController extends GetxController {
  final CartRepository _cartRepository = CartRepository();
  final RxList<Cart> cartItems = <Cart>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCartItems();
  }

  // Sepet öğelerini getir
  void fetchCartItems() {
    isLoading.value = true;
    _cartRepository.getCartItems().listen((items) {
      cartItems.assignAll(items);
      isLoading.value = false;
    }, onError: (error) {
      print("Error fetching cart items: $error");
      isLoading.value = false;
    });
  }

  // Sepet öğesini sil
  Future<void> removeCartItem(String cartItemId) async {
    try {
      await _cartRepository.removeCartItem(cartItemId);
      cartItems.removeWhere((item) => item.id == cartItemId);
    } catch (e) {
      print("Error removing cart item: $e");
    }
  }

  Future<void> incrementItemQuantity(String cartItemId) async {
    await _cartRepository.incrementItemQuantity(cartItemId);
    await refreshCartItems();
  }

  Future<void> decrementItemQuantity(String cartItemId) async {
    await _cartRepository.decrementItemQuantity(cartItemId);
    await refreshCartItems();
  }

  Future<void> refreshCartItems() async {
    isLoading.value = true;
    cartItems.value = await _cartRepository.getCartItems().first;
    isLoading.value = false;
  }

  // Toplam sepet tutarını hesapla
  double get totalAmount {
    return cartItems.fold(0, (sum, item) => sum + item.totalPrice);
  }

  // Sepetteki öğe sayısını al
  int get itemCount => cartItems.length;

  // Sepeti temizle
  Future<void> clearCart() async {
    try {
      await _cartRepository.clearCart();
      cartItems.clear();
    } catch (e) {
      print("Error clearing cart: $e");
    }
  }

  // Ödeme işlemini başlat
  Future<void> proceedToCheckout() async {
    // Ödeme işlemi mantığı buraya gelecek
    print("Proceeding to checkout with total amount: $totalAmount");
  }

  // Ana sayfaya git
  void goToHomePage() {
    Get.offNamed('/home');
  }
}
