import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecomprofire/view/details/details_controller.dart';
import 'package:ecomprofire/view/diy/edit_upload_product_form.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'subtitle_text.dart';
import 'title_text.dart';

class ProductWidget extends GetWidget<DetailsController> {
  final String productId;

  const ProductWidget({
    Key? key,
    required this.productId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Obx(() {
      final getCurrProduct = controller.findByProdId(productId);

      if (getCurrProduct == null) {
        return const SizedBox.shrink();
      }

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            Get.to(() => EditOrUploadProductScreen(
                  productModel: getCurrProduct,
                ));
          },
          child: Column(
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  height: size.height * 0.22,
                  viewportFraction: 1,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                ),
                items: getCurrProduct.images.map((image) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: FancyShimmerImage(
                            imageUrl: image,
                            boxFit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 12.0),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: TitlesTextWidget(
                  label: getCurrProduct.title,
                  fontSize: 18,
                  maxLines: 2,
                ),
              ),
              const SizedBox(height: 6.0),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: SubtitleTextWidget(
                  label: "${getCurrProduct.price}\$",
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 12.0),
            ],
          ),
        ),
      );
    });
  }
}
