import 'package:flutter/material.dart';
import 'package:its_system/core/models/menu.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:rive/rive.dart';
import 'animated_bar.dart';

class MenuItem extends StatelessWidget {
  const MenuItem(
      {super.key,
      required this.navBar,
      required this.press,
      required this.riveOnInit,
      required this.selectedNav});

  final Menu navBar;
  final VoidCallback press;
  final ValueChanged<Artboard> riveOnInit;
  final Menu selectedNav;

  @override
  Widget build(BuildContext context) {
        List<String> titles = [     
     "systemManagement".tr(),
     "servicesManagement".tr(),
     'controlPanel'.tr(),
     "employees".tr(),
     "citizens".tr(),
     "orders".tr(),
     "settings".tr(),
          "notifications".tr(),
     ];
    return GestureDetector(
      onTap: press,
      child: Row(
        children: [
          const SizedBox(width: 5,),
          AnimatedBar(isActive: selectedNav == navBar,isHorizontal: false),
          const SizedBox(width: 5,),
           Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: navBar.iconBackground,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              // child: Icon(icon),
              child:SizedBox(
              height: 30,
              width:  30,
              child: Opacity(
                opacity: selectedNav == navBar ? 1 : 0.5,
                child: RiveAnimation.asset(
                  navBar.rive.src,
                  artboard: navBar.rive.artboard,
                  onInit: riveOnInit,
                ),
              ),
            ),
          ),
            ),
          Flexible(child:Opacity(
              opacity: selectedNav == navBar ? 1 : 0.5,child: Text(titles[navBar.index],style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.white),)))
        ],
      ),
    );
  }
}
