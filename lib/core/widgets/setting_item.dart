
 import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
  
  Widget settingItem(
      {required IconData icon,
        required Color iconBackground,
        required String title,
        required String subtitle,
        String image = "",
        Function()? onTap}) {
    return StatefulBuilder(builder: (context, _) {
      return Card(
        color: Theme.of(context).cardColor,
        elevation: 0.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          onTap: onTap,
          trailing: onTap != null
              ? Icon(translator.activeLanguageCode == 'ar'
              ? Ionicons.chevron_back
              : Ionicons.chevron_forward)
              : null,
          leading: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: iconBackground,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: image == ""? Icon(
                icon,
                color: Colors.white,
              ):Image.asset(image),
            ),
          ),
          title: Text(title, style: Theme.of(context).textTheme.displaySmall),
          subtitle: Text(subtitle, style:Theme.of(context).textTheme.labelMedium,),
        ),
      );
    });
  }