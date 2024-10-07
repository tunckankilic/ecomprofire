import 'package:ecomprofire/app/repositories/cart_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../app/base/models/cart.dart';
import '../../../app/constants/size_config.dart';
import 'cart_card.dart';

class CBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CartRepository cartRepository = CartRepository();
    return StreamBuilder<List<Cart>>(
      stream: cartRepository.getCartItems(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('An error occurred: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('There is no Product'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/home');
                  },
                  child: Text('Go to Home Page'),
                ),
              ],
            ),
          );
        } else {
          return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Dismissible(
                  key: Key(snapshot.data![index].id.toString()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    cartRepository
                        .removeCartItem(snapshot.data![index].id.toString());
                  },
                  background: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFE6E6),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Spacer(),
                        SvgPicture.asset("assets/icons/Trash.svg"),
                      ],
                    ),
                  ),
                  child: CartCard(cart: snapshot.data![index]),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
