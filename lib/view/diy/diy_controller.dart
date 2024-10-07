// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:ecomprofire/app/base/base.dart';
import 'package:ecomprofire/app/service/my_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import "package:cloud_firestore/cloud_firestore.dart";

import 'package:uuid/uuid.dart';

class DIYController extends GetxController {
  final RxList<Product> productListSearch = <Product>[].obs;
  final RxList<String> productsCountList = <String>[].obs;
  final searchController = TextEditingController();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final RxList<TextEditingController> stepTextControllers =
      <TextEditingController>[].obs;
  final RxList<String> productsToAdd = <String>[].obs;
  final formKey = GlobalKey<FormState>();
  final Rx<String?> productNetworkImage = Rx<String?>(null);
  final Rx<XFile?> pickedImage = Rx<XFile?>(null);
  final Rx<String?> imagePath = Rx<String?>(null);
  final RxBool isEditing = false.obs;
  final RxBool isLoading = false.obs;
  final uuid = const Uuid().v4();
  final RxList<String> productSearchResults = <String>[].obs;
  final Rx<String?> selectedProduct = Rx<String?>(null);
  final Rx<String?> selectedLetter = Rx<String?>(null);
  final RxString error = ''.obs;
  void setSelectedLetter(String letter) {
    selectedLetter.value = letter;
  }

  void setLoading(bool value) {
    isLoading.value = value;
  }

  void addTextField() {
    stepTextControllers.add(TextEditingController());
  }

  void removeTextField(int index) {
    stepTextControllers[index].dispose();
    stepTextControllers.removeAt(index);
  }

  Future<void> searchProducts(String query) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('productTitle', isGreaterThanOrEqualTo: query)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        productSearchResults.value =
            querySnapshot.docs.map((doc) => doc['name'] as String).toList();
      } else {
        productSearchResults.clear();
      }
    } catch (error) {
      log('Error searching products: $error');
    }
  }

  Future<void> localImagePicker({required BuildContext context}) async {
    final ImagePicker picker = ImagePicker();
    await MyAppFunctions.imagePickerDialog(
      context: context,
      cameraFCT: () async {
        pickedImage.value = await picker.pickImage(source: ImageSource.camera);
        productNetworkImage.value = null;
      },
      galleryFCT: () async {
        pickedImage.value = await picker.pickImage(source: ImageSource.gallery);
        productNetworkImage.value = null;
      },
      removeFCT: () {
        pickedImage.value = null;
      },
    );
  }

  void addProductsToCountList(List<String> productIds) {
    for (final productId in productIds) {
      if (!productsCountList.contains(productId)) {
        productsCountList.add(productId);
        stepTextControllers.add(TextEditingController(text: productId));
      }
    }
  }

  Future<void> sendRecipeToFirestore({
    String? title,
    String? description,
    required List<String> steps,
  }) async {
    try {
      final CollectionReference recipes =
          FirebaseFirestore.instance.collection('recipes');

      String imageUrl = await uploadImageToFirestoreStorage(pickedImage.value);

      List<Map<String, dynamic>> stepsList =
          steps.map((step) => {'description': step}).toList();

      await recipes.add({
        'title': title,
        'description': description,
        'steps': stepsList,
        'image_url': imageUrl,
      });

      log('Recipe added to Firestore');
    } catch (e) {
      log('Error adding recipe to Firestore: $e');
    }
  }

  Future<String> uploadImageToFirestoreStorage(XFile? pickedImage) async {
    if (pickedImage == null) {
      return '';
    }

    try {
      final storageRef = FirebaseStorage.instance.ref();
      final TaskSnapshot uploadTask = await storageRef
          .child('recipe_images/${DateTime.now().millisecondsSinceEpoch}.jpg')
          .putFile(File(pickedImage.path));

      final String imageUrl = await uploadTask.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      log('Error uploading image to Firestore Storage: $e');
      return '';
    }
  }

  void clearForm() {
    titleController.clear();
    descriptionController.clear();
    for (var controller in stepTextControllers) {
      controller.clear();
    }
    pickedImage.value = null;
    imagePath.value = null;
  }

  Future<void> uploadDIY(
    BuildContext context, {
    required String title,
    required String description,
    required List<String> steps,
    required File imageFile,
  }) async {
    try {
      setLoading(true);

      final storageRef =
          FirebaseStorage.instance.ref().child("diyImages").child("$title.jpg");
      await storageRef.putFile(imageFile);
      final imageUrl = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance
          .collection("diyCollection")
          .doc(uuid)
          .set({
        'id': uuid,
        'title': title,
        'description': description,
        'imagePath': imageUrl,
        'steps': steps,
      });

      clearForm();

      Get.snackbar(
        "Success",
        "Item Uploaded",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (error) {
      Get.snackbar(
        "Error",
        "Error: $error",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      setLoading(false);
    }
  }

  Future<void> editDIY() async {
    final isValid = formKey.currentState!.validate();

    if (pickedImage.value == null && imagePath.value == null) {
      return;
    }

    if (isValid) {
      try {
        setLoading(true);

        if (pickedImage.value != null) {
          final ref = FirebaseStorage.instance
              .ref()
              .child("diyImages")
              .child("${titleController.text}.jpg");
          await ref.putFile(File(pickedImage.value!.path));
          imagePath.value = await ref.getDownloadURL();
        }

        await FirebaseFirestore.instance
            .collection("diyCollection")
            .doc(uuid)
            .update({
          'title': titleController.text,
          'description': descriptionController.text,
          'imagePath': imagePath.value ?? '',
          'steps':
              stepTextControllers.map((controller) => controller.text).toList(),
        });

        clearForm();
      } catch (error) {
        // Handle errors specific to your DIY panel editing
      } finally {
        setLoading(false);
      }
    }
  }
}
