import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecomprofire/view/components/subtitle_text.dart';
import 'package:ecomprofire/view/components/title_text.dart';
import 'package:ecomprofire/view/details/details_controller.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductTile extends GetWidget<DetailsController> {
  final String productId;
  final VoidCallback? onTap;
  final bool choice;

  const ProductTile({
    Key? key,
    required this.productId,
    this.onTap,
    required this.choice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final getCurrProduct = controller.findByProdId(productId);

      if (getCurrProduct == null) {
        return const SizedBox.shrink();
      }

      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: GestureDetector(
          onTap: choice ? onTap : null,
          child: Column(
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  height: 150,
                  viewportFraction: 0.9,
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
              ListTile(
                title: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: TitlesTextWidget(
                    label: getCurrProduct.title,
                    fontSize: 18,
                    maxLines: 2,
                  ),
                ),
                trailing: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: SubtitleTextWidget(
                    label: "${getCurrProduct.price}\$",
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
