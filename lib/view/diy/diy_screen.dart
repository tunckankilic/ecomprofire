import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:ecomprofire/app/base/base.dart';
import 'package:ecomprofire/view/components/product_tile.dart';
import 'package:ecomprofire/view/components/title_text.dart';
import 'package:ecomprofire/view/details/details_controller.dart';
import 'package:ecomprofire/view/diy/diy_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DIYPanel extends GetView<DIYController> {
  static const routeName = "/diy";

  DIYPanel({Key? key}) : super(key: key);

  final DetailsController productsController = Get.find<DetailsController>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('DIY Panel'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              productSearchBox(),
              Obx(() => controller.pickedImage.value == null
                  ? SizedBox(
                      width: size.width * 0.4 + 10,
                      height: size.width * 0.4,
                      child: DottedBorder(
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.image_outlined,
                                size: 80,
                                color: Colors.blue,
                              ),
                              TextButton(
                                onPressed: () => controller.localImagePicker(
                                    context: context),
                                child: const Text("Pick Product Image"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(controller.pickedImage.value!.path),
                            height: size.width * 0.5,
                            alignment: Alignment.center,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () =>
                                  controller.localImagePicker(context: context),
                              child: const Text("Pick another image"),
                            ),
                            TextButton(
                              onPressed: () =>
                                  controller.pickedImage.value = null,
                              child: const Text(
                                "Remove image",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
              const SizedBox(height: 25),
              TextFormField(
                controller: controller.titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: controller.descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 10,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              productList(),
              clearForm(),
              approveButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget productList() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const TitlesTextWidget(label: "Products"),
            const SizedBox(height: 15),
            SizedBox(
              height: 200,
              child: SingleChildScrollView(
                child: Obx(() => Column(
                      children: controller.productsCountList.isEmpty
                          ? [
                              Text(
                                "Add Products",
                                style: Get.textTheme.displaySmall,
                              )
                            ]
                          : controller.productsCountList.map((productId) {
                              return ProductTile(
                                choice: true,
                                productId: productId,
                                onTap: () {
                                  // Add any action you want to perform when a product is tapped
                                },
                              );
                            }).toList(),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget clearForm() {
    return ElevatedButton(
      onPressed: () => controller.clearForm(),
      child: const Text('Clear Form'),
    );
  }

  Widget approveButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final form = controller.formKey.currentState;
        if (form != null && form.validate()) {
          File imageFile = File("");

          if (controller.pickedImage.value != null) {
            imageFile = File(controller.pickedImage.value!.path);
          }

          await controller.uploadDIY(
            context,
            title: controller.titleController.text,
            description: controller.descriptionController.text,
            steps: controller.productsCountList,
            imageFile: imageFile,
          );
        } else {
          Get.snackbar(
            "Error",
            "Please fill in all fields correctly.",
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      },
      child: const Text('Send Recipe'),
    );
  }

  Widget productSearchBox() {
    return SizedBox(
      height: 400,
      child: Obx(() {
        if (productsController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (productsController.error.value.isNotEmpty) {
          return Center(child: SelectableText(productsController.error.value));
        } else if (productsController.products.isEmpty) {
          return const Center(
              child: SelectableText("No products have been added"));
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 15.0),
              TextField(
                controller: controller.searchController,
                decoration: InputDecoration(
                  hintText: "Search",
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      controller.searchController.clear();
                      controller.productListSearch.clear();
                    },
                    child: const Icon(Icons.clear, color: Colors.red),
                  ),
                ),
                onChanged: (value) {
                  controller.productListSearch.value =
                      productsController.searchQuery(
                    searchText: value,
                    passedList: productsController.products,
                  );
                },
              ),
              const SizedBox(height: 15.0),
              Obx(() {
                if (controller.searchController.text.isNotEmpty &&
                    controller.productListSearch.isEmpty) {
                  return const Center(
                      child: TitlesTextWidget(label: "No products found"));
                }
                return SizedBox(
                  height: 300,
                  child: ListView.builder(
                    itemCount: controller.searchController.text.isNotEmpty
                        ? controller.productListSearch.length
                        : productsController.products.length,
                    itemBuilder: (context, index) {
                      final Product product =
                          controller.searchController.text.isNotEmpty
                              ? controller.productListSearch[index]
                              : productsController.products[index];

                      return ProductTile(
                        choice: true,
                        productId: product.id,
                        onTap: () {
                          if (!controller.productsCountList
                              .contains(product.id)) {
                            controller.productsCountList.add(product.id);
                          }
                        },
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        );
      }),
    );
  }
}
