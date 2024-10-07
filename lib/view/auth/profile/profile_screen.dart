import 'package:flutter/material.dart';
import '../../../app/enums/enums.dart';
import '../../components/custom_bottom_nav_bar.dart';
import 'components/p_body.dart';

class ProfileScreen extends StatelessWidget {
  static String routeName = "/profile";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: PBody(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.profile),
    );
  }
}
