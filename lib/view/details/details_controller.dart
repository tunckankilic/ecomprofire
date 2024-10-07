import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomprofire/app/base/base.dart';
import 'package:ecomprofire/app/repositories/repositories.dart';
import 'package:get/get.dart';

class DetailsController extends GetxController {
  final ProductRepository _repository = ProductRepository();
  final RxList<Product> products = <Product>[].obs;
  final Rx<Product?> selectedProduct = Rx<Product?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  List<Product> get getProducts => products;

  @override
  void onInit() {
    super.onInit();
    fetchAllProducts();
  }

  Future<void> fetchAllProducts() async {
    try {
      isLoading.value = true;
      error.value = '';
      products.value = await _repository.getAllProducts();
    } catch (e) {
      error.value = 'Error fetching all products: $e';
      print(error.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchProductById(String id) async {
    try {
      selectedProduct.value = await _repository.getProductById(id);
    } catch (e) {
      print('Error fetching product by id: $e');
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      await _repository.addProduct(product);
      await fetchAllProducts();
    } catch (e) {
      print('Error adding product: $e');
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      await _repository.updateProduct(product);
      await fetchAllProducts();
    } catch (e) {
      print('Error updating product: $e');
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await _repository.deleteProduct(id);
      await fetchAllProducts();
    } catch (e) {
      print('Error deleting product: $e');
    }
  }

  void setSelectedProduct(Product product) {
    selectedProduct.value = product;
  }

  void clearSelectedProduct() {
    selectedProduct.value = null;
  }

  Product? findByProdId(String productId) {
    return products.firstWhereOrNull((element) => element.id == productId);
  }

  List<Product> findByCategory({required String categoryName}) {
    return products
        .where((product) =>
            product.title.toLowerCase().contains(categoryName.toLowerCase()))
        .toList();
  }

  List<Product> searchQuery(
      {required String searchText, List<Product>? passedList}) {
    final List<Product> searchBase = passedList ?? products;
    return searchBase
        .where((product) =>
            product.title.toLowerCase().contains(searchText.toLowerCase()) ||
            product.description
                .toLowerCase()
                .contains(searchText.toLowerCase()))
        .toList();
  }

  Stream<List<Product>> fetchProductsStream() {
    isLoading.value = true;
    return FirebaseFirestore.instance
        .collection("products")
        .snapshots()
        .map((snapshot) {
      isLoading.value = false;
      products.value =
          snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();
      return products;
    }).handleError((e) {
      isLoading.value = false;
      error.value = 'Error fetching products: $e';
      print(error.value);
      return [];
    });
  }
}
