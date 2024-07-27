

import 'package:flutter/material.dart';
import 'package:its_system/core/widgets/input_field.dart';
import 'package:its_system/models/user_model.dart';
import 'package:its_system/responsive.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class ShowUser extends StatelessWidget {
  UserModel user;
  ShowUser({super.key,required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).cardColor,
        ),
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.all(12),
        width: Responsive.isDesktop(context) ? 300 : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Center(
              child: Text(
                "userInfo".tr(),
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
              InputField(
              controller: user.userName!.getTitleAsFaild,
              keyboardType: TextInputType.text,
              isRequired: true,
              node: FocusNode(),
              label: "name".tr(),
            ),
            const SizedBox(
              height: 10,
            ),
            InputField(
              controller: user.userEMail!,
              keyboardType: TextInputType.emailAddress,
              isRequired: true,
              node: FocusNode(),
              label: "emailAddress".tr(),
            ),
            const SizedBox(
              height: 10,
            ),
            InputField(
              controller: user.userPhoneNumber!,
              keyboardType: TextInputType.text,
              isRequired: true,
              node: FocusNode(),
              label: "${"phone".tr()} *",
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      );
  }
}