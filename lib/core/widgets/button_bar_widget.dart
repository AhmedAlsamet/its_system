// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:its_system/core/models/button_model.dart';

class ButtonBarWidget extends StatelessWidget {
  List<ButtonModel> allButtons;
  bool isMain;
  ButtonBarWidget({required this.isMain,required this.allButtons,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 5,right: 5,bottom: 5),
      height: AppBar().preferredSize.height,
      alignment: Alignment.center,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: allButtons.length,
          primary: false,
          shrinkWrap: true,
          itemBuilder: (context,index){
            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ButtonWidget(button: allButtons[index],isMain:isMain),
                SizedBox(width: isMain ? 0 : 5,)
              ],
            );
          }),
    );
  }
}

class ButtonWidget extends StatelessWidget {
  ButtonModel button;
  bool isMain;
  ButtonWidget({Key? key,required this.button,required this.isMain}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: button.onPressed,
        icon: Icon(button.icon,color: button.foregroundColor,),
        label: Text(button.title,style: Theme.of(context).textTheme.displaySmall!.copyWith(
          fontWeight: FontWeight.bold,
          color: button.foregroundColor,
          fontSize: !isMain ? 14 : null
        ),),
    style: ElevatedButton.styleFrom(
      elevation: !isMain ? 0 :5,
      backgroundColor: button.backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(5))
    ),);
  }
}
