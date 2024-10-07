import 'package:ecomprofire/view/components/components.dart';
import 'package:ecomprofire/view/details/details_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/constants/size_config.dart';
import 'section_title.dart';

class PopularProducts extends StatelessWidget {
  final DetailsController productController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SectionTitle(title: "Popular Products", press: () {}),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: productController.products.isEmpty
              ? Center(
                  child: Text("There is no Product"),
                )
              : Obx(() => Row(
                    children: [
                      ...productController.products
                          .where((product) => product.isPopular)
                          .map((product) => ProductCard(product: product))
                          .toList(),
                      SizedBox(width: getProportionateScreenWidth(20)),
                    ],
                  )),
        )
      ],
    );
  }
}
