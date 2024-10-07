import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:ecomprofire/app/app.dart';
import 'package:ecomprofire/app/constants/validator.dart';
import 'package:ecomprofire/app/service/my_app.dart';
import 'package:ecomprofire/view/components/subtitle_text.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'loading_manager.dart';

class EditOrUploadProductScreen extends StatefulWidget {
  static const routeName = '/EditOrUploadProductScreen';
  const EditOrUploadProductScreen({super.key, this.productModel});
  final Product? productModel;

  @override
  State<EditOrUploadProductScreen> createState() =>
      _EditOrUploadProductScreenState();
}

class _EditOrUploadProductScreenState extends State<EditOrUploadProductScreen> {
  final _formKey = GlobalKey<FormState>();
  XFile? _pickedImage;
  late TextEditingController _titleController,
      _priceController,
      _descriptionController,
      _ratingController;
  List<String> _images = [];
  List<Color> _colors = [];
  bool isEditing = false;
  bool _isLoading = false;
  bool isPopular = false;
  bool isFavourite = false;

  @override
  void initState() {
    if (widget.productModel != null) {
      isEditing = true;
      _images = widget.productModel!.images;
      _colors = widget.productModel!.colors;
    }
    _titleController = TextEditingController(text: widget.productModel?.title);
    _priceController =
        TextEditingController(text: widget.productModel?.price.toString());
    _descriptionController =
        TextEditingController(text: widget.productModel?.description);
    _ratingController =
        TextEditingController(text: widget.productModel?.rating.toString());
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _ratingController.dispose();
    super.dispose();
  }

  void clearForm() {
    _titleController.clear();
    _priceController.clear();
    _descriptionController.clear();
    _ratingController.clear();
    setState(() {
      _images.clear();
      _colors.clear();
      isPopular = false;
      isFavourite = false;
    });
  }

  Future<void> _uploadProduct() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (_images.isEmpty) {
      MyAppFunctions.showErrorOrWarningDialog(
        context: context,
        subtitle: "Make sure to pick up at least one image",
        fct: () {},
      );
      return;
    }
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      try {
        final productId = const Uuid().v4();
        await FirebaseFirestore.instance
            .collection("products")
            .doc(productId)
            .set({
          'id': productId,
          'title': _titleController.text,
          'price': double.parse(_priceController.text),
          'images': _images,
          'colors': _colors.map((c) => c.value).toList(),
          'description': _descriptionController.text,
          'rating': double.parse(_ratingController.text),
          'isPopular': isPopular,
          'isFavourite': isFavourite,
        });
        Fluttertoast.showToast(
            msg: "Product has been added", textColor: Colors.white);
        clearForm();
      } catch (error) {
        await MyAppFunctions.showErrorOrWarningDialog(
          context: context,
          subtitle: error.toString(),
          fct: () {},
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _editProduct() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (_images.isEmpty) {
      MyAppFunctions.showErrorOrWarningDialog(
        context: context,
        subtitle: "Make sure to have at least one image",
        fct: () {},
      );
      return;
    }
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      try {
        await FirebaseFirestore.instance
            .collection("products")
            .doc(widget.productModel!.id)
            .update({
          'title': _titleController.text,
          'price': double.parse(_priceController.text),
          'images': _images,
          'colors': _colors.map((c) => c.value).toList(),
          'description': _descriptionController.text,
          'rating': double.parse(_ratingController.text),
          'isPopular': isPopular,
          'isFavourite': isFavourite,
        });
        Fluttertoast.showToast(
            msg: "Product has been updated", textColor: Colors.white);
      } catch (error) {
        await MyAppFunctions.showErrorOrWarningDialog(
          context: context,
          subtitle: error.toString(),
          fct: () {},
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      String imageUrl = await _uploadImageToFirebase(File(image.path));
      setState(() {
        _images.add(imageUrl);
      });
    }
  }

  Future<String> _uploadImageToFirebase(File imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('product_images/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  void _addColor() {
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
              child: const Text('Add'),
              onPressed: () {
                setState(() {
                  _colors.add(pickerColor);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _removeColor(int index) {
    setState(() {
      _colors.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return LoadingManager(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEditing ? "Edit Product" : "Upload a new product"),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image picker
                Text("Product Images:"),
                SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ..._images
                        .asMap()
                        .entries
                        .map((entry) => Stack(
                              children: [
                                Image.network(entry.value,
                                    width: 100, height: 100, fit: BoxFit.cover),
                                Positioned(
                                  right: 0,
                                  child: IconButton(
                                    icon: Icon(Icons.close),
                                    onPressed: () => _removeImage(entry.key),
                                  ),
                                ),
                              ],
                            ))
                        .toList(),
                    InkWell(
                      onTap: _pickImage,
                      child: DottedBorder(
                        child: Container(
                          width: 100,
                          height: 100,
                          child: Icon(Icons.add_photo_alternate, size: 40),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Title
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                  validator: (value) => MyValidators.uploadProdTexts(
                    value: value,
                    toBeReturnedString: "Please enter a valid title",
                  ),
                ),
                SizedBox(height: 10),

                // Price
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) => MyValidators.uploadProdTexts(
                    value: value,
                    toBeReturnedString: "Please enter a valid price",
                  ),
                ),
                SizedBox(height: 10),

                // Description
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  validator: (value) => MyValidators.uploadProdTexts(
                    value: value,
                    toBeReturnedString: "Please enter a description",
                  ),
                ),
                SizedBox(height: 10),

                // Rating
                TextFormField(
                  controller: _ratingController,
                  decoration: InputDecoration(labelText: 'Rating'),
                  keyboardType: TextInputType.number,
                  validator: (value) => MyValidators.uploadProdTexts(
                    value: value,
                    toBeReturnedString: "Please enter a valid rating",
                  ),
                ),
                SizedBox(height: 20),

                // Colors
                Text("Product Colors:"),
                SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ..._colors
                        .asMap()
                        .entries
                        .map((entry) => InkWell(
                              onTap: () => _removeColor(entry.key),
                              child: CircleAvatar(
                                backgroundColor: entry.value,
                                radius: 20,
                                child: Icon(Icons.close, color: Colors.white),
                              ),
                            ))
                        .toList(),
                    InkWell(
                      onTap: _addColor,
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        radius: 20,
                        child: Icon(Icons.add, color: Colors.black),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Checkboxes
                CheckboxListTile(
                  title: Text("Is Popular"),
                  value: isPopular,
                  onChanged: (value) {
                    setState(() {
                      isPopular = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text("Is Favourite"),
                  value: isFavourite,
                  onChanged: (value) {
                    setState(() {
                      isFavourite = value!;
                    });
                  },
                ),

                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isEditing ? _editProduct : _uploadProduct,
                  child: Text(isEditing ? "Update Product" : "Add Product"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
