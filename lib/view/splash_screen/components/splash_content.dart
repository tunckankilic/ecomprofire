import 'package:flutter/material.dart';
import '../../../app/constants/constants.dart';
import '../../../app/constants/size_config.dart';

class SplashContent extends StatelessWidget {
  final String text;
  final String img;

  const SplashContent({super.key, required this.text, required this.img});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: getProportionateScreenWidth(30),
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text("Welcome to Tokoto, Let's shop!!"),
        Spacer(
          flex: 2,
        ),
        Image.asset(
          img,
          height: getProportionateScreenHeight(230),
          width: getProportionateScreenWidth(235),
        )
      ],
    );
  }
}
