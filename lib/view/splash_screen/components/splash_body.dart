import 'package:ecomprofire/app/constants/constants.dart';
import 'package:flutter/material.dart';
import '../../../app/constants/size_config.dart';
import '../../components/default_button.dart';
import '../../auth/sign_in/sign_in_screen.dart';
import 'splash_content.dart';

class SplashBody extends StatefulWidget {
  const SplashBody({Key? key}) : super(key: key);

  @override
  State<SplashBody> createState() => _SplashBodyState();
}

class _SplashBodyState extends State<SplashBody> {
  int _currentPage = 0;
  List<Map<String, String>> splashData = [
    {
      "text": "TOKOTO",
      "image": "assets/images/splash_1.png",
    },
    {
      "text": "We help people to connect with store \naround Turkey",
      "image": "assets/images/splash_2.png",
    },
    {
      "text": "We show easy way to shop",
      "image": "assets/images/splash_3.png",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    _currentPage = value;
                  });
                },
                itemCount: splashData.length,
                itemBuilder: (context, index) => SplashContent(
                  text: splashData[index]["text"].toString(),
                  img: splashData[index]["image"].toString(),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: Column(
                  children: <Widget>[
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        splashData.length,
                        (index) => buildDot(index: index),
                      ),
                    ),
                    Spacer(flex: 3),
                    DefaultButton(
                      text: "Continue",
                      press: () {
                        Navigator.pushNamed(context, SignInScreen.routeName);
                      },
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildDot({required int index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: _currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: _currentPage == index ? kPrimaryColor : Colors.grey,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
