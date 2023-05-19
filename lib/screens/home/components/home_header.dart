import 'package:flutter/material.dart';

import '../../../components/icon_btn_with_counter.dart';
import '../../../utils/constants.dart';
import '../../../utils/size_config.dart';
import '../../cart/cart_screen.dart';
import '../../notification/notification_screen.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "SnapCart",
            style: TextStyle(
                fontSize: getProportionateScreenWidth(18),
                color: kPrimaryColor,
                fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconBtnWithCounter(
                svgSrc: "assets/icons/Bell.svg",
                numOfitem: 3,
                press: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) {
                      return const NotificationScreen();
                    },
                  ),
                ),
              ),
              SizedBox(width: getProportionateScreenWidth(8)),
              IconBtnWithCounter(
                svgSrc: "assets/icons/Cart Icon.svg",
                press: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) {
                      return const CartScreen();
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
