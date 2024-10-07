import 'package:ecomprofire/view/create/create_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';

class CreateProductPage extends StatelessWidget {
  final CreateProductController controller = Get.put(CreateProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Product'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: controller.titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: controller.descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            TextField(
              controller: controller.priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            TextField(
              controller: controller.ratingController,
              decoration: InputDecoration(labelText: 'Rating'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            Text('Images:'),
            Obx(() => Wrap(
                  spacing: 8,
                  children: [
                    ...controller.images.asMap().entries.map((entry) => Stack(
                          children: [
                            Image.network(
                              entry.value,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              right: 0,
                              child: IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () =>
                                    controller.removeImage(entry.key),
                              ),
                            ),
                          ],
                        )),
                    ActionChip(
                      label: Text('Add Image'),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Choose image source'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    GestureDetector(
                                      child: Text('Gallery'),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        controller
                                            .pickImage(ImageSource.gallery);
                                      },
                                    ),
                                    Padding(padding: EdgeInsets.all(8.0)),
                                    GestureDetector(
                                      child: Text('Camera'),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        controller
                                            .pickImage(ImageSource.camera);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                )),
            SizedBox(height: 16),
            Text('Colors:'),
            Obx(() => Wrap(
                  spacing: 8,
                  children: [
                    ...controller.colors
                        .asMap()
                        .entries
                        .map((entry) => GestureDetector(
                              onTap: () => controller.removeColor(entry.key),
                              child: CircleAvatar(
                                backgroundColor: entry.value,
                                radius: 15,
                                child: Icon(Icons.close,
                                    size: 15, color: Colors.white),
                              ),
                            )),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            Color pickerColor = Colors.blue;
                            return AlertDialog(
                              title: Text('Pick a color'),
                              content: SingleChildScrollView(
                                child: ColorPicker(
                                  pickerColor: pickerColor,
                                  onColorChanged: (Color color) {
                                    pickerColor = color;
                                  },
                                ),
                              ),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: Text('Add'),
                                  onPressed: () {
                                    controller.addColor(pickerColor);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        radius: 15,
                        child: Icon(Icons.add, size: 15),
                      ),
                    ),
                  ],
                )),
            SizedBox(height: 16),
            Row(
              children: [
                Obx(() => Checkbox(
                      value: controller.isPopular.value,
                      onChanged: (_) => controller.togglePopular(),
                    )),
                Text('Popular'),
                SizedBox(width: 16),
                Obx(() => Checkbox(
                      value: controller.isFavourite.value,
                      onChanged: (_) => controller.toggleFavourite(),
                    )),
                Text('Favourite'),
              ],
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: controller.createProduct,
              child: Text('Create Product'),
            ),
          ],
        ),
      ),
    );
  }
}
