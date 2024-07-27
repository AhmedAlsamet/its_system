import 'package:flutter/material.dart';
import 'package:its_system/controllers/general_controller.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:its_system/constants.dart';
import 'package:its_system/core/models/menu.dart';
import 'package:its_system/core/widgets/animated_bar.dart';
import 'package:rive/rive.dart';


class BtmNavItem extends StatelessWidget {
  const BtmNavItem(
      {super.key,
      required this.navBar,
      required this.press,
      required this.riveOnInit,
      this.showNotificationSign = false,
      required this.controller,
      required this.selectedNav});

  final Menu navBar;
  final VoidCallback press;
  final bool showNotificationSign;
  final ValueChanged<Artboard> riveOnInit;
  final Menu selectedNav;
  final GeneralController controller;

  @override
  Widget build(BuildContext context) {
        List<String> titles = [    
          "home".tr(),
          "myOrders".tr(),
          "notifications".tr(),
          "settings".tr(),
     ];
    return GestureDetector(
      onTap: press,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBar(isActive: selectedNav == navBar,isHorizontal: true),
          if(navBar.index == 2 && showNotificationSign)
          Container(
          width: 5,
          height: 5,
          decoration: const BoxDecoration(shape: BoxShape.circle,color: redColor),),
          SizedBox(
            height: 36,
            width: 36,
            child: Opacity(
              opacity: selectedNav == navBar ? 1 : 0.5,
              child: RiveAnimation.asset(
                navBar.rive.src,
                artboard: navBar.rive.artboard,
                onInit: riveOnInit,
              )
            ),
          ),
          Flexible(child:Opacity(
              opacity: selectedNav == navBar ? 1 : 0.5,child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(titles[navBar.index],style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.white),))))
        ],
      ),
    );
  }
}
