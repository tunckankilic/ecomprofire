import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomprofire/app/base/models/product.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../app/repositories/repositories.dart';

class CreateProductController extends GetxController {
  final ProductRepository _productService = ProductRepository();
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final ratingController = TextEditingController();

  final images = <String>[].obs;
  final colors = <Color>[].obs;
  final isPopular = false.obs;
  final isFavourite = false.obs;

  final isLoading = false.obs;

  void addImage(String imageUrl) {
    images.add(imageUrl);
  }

  void removeImage(int index) {
    images.removeAt(index);
  }

  void addColor(Color color) {
    colors.add(color);
  }

  void removeColor(int index) {
    colors.removeAt(index);
  }

  void togglePopular() {
    isPopular.toggle();
  }

  void toggleFavourite() {
    isFavourite.toggle();
  }

  Future<void> createProduct() async {
    // Validate inputs
    if (titleController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        priceController.text.isEmpty ||
        ratingController.text.isEmpty ||
        images.isEmpty ||
        colors.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    isLoading.value = true;

    try {
      // Create product
      final product = Product(
        id: '', // Firestore will generate an ID
        title: titleController.text,
        description: descriptionController.text,
        images: images,
        colors: colors,
        rating: double.parse(ratingController.text),
        price: double.parse(priceController.text),
        isPopular: isPopular.value,
        isFavourite: isFavourite.value,
      );

      // Save product to Firestore
      await _productService.addProduct(product);

      // Clear form
      clearForm();

      Get.snackbar('Success', 'Product created successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to create product: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    titleController.clear();
    descriptionController.clear();
    priceController.clear();
    ratingController.clear();
    images.clear();
    colors.clear();
    isPopular.value = false;
    isFavourite.value = false;
  }

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      final String imageUrl = await uploadImage(File(image.path));
      addImage(imageUrl);
    }
  }

  Future<String> uploadImage(File imageFile) async {
    final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final Reference storageRef =
        _storage.ref().child('product_images/$fileName');
    final UploadTask uploadTask = storageRef.putFile(imageFile);
    final TaskSnapshot snapshot = await uploadTask;
    final String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    ratingController.dispose();
    super.onClose();
  }
}
