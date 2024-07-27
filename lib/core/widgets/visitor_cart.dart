// ignore_for_file: must_be_immutable

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:its_system/core/widgets/cash_image.dart';

class VisitorCart extends StatelessWidget {
  File orderorImage;
  String orderorName;
  String orderorcode;
  VisitorCart(
      {required this.orderorImage,
      required this.orderorName,
      required this.orderorcode,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: ImageWidget(imagePath: orderorImage.path),
            ),
            const SizedBox(
              width: 5,
            ),
            Column(
              children: [
                Text(orderorName,
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall!
                        .copyWith(fontWeight: FontWeight.bold)),
                Text(orderorcode, style: Theme.of(context).textTheme.labelLarge!),
              ],
            )
          ],
        ),
      ),
    );
  }
}

/*
ListTile(
    shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(10)),
    onTap: null,

    leading: Card(
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(
                  10)),
      color: headColor,
      child: Padding(
          padding:
              const EdgeInsets.all(8.0),
          child: Image.file(
            s.value.orderorImage!,
            errorBuilder: (
              context,
              error,
              stackTrace,
            ) {
              return SizedBox(
                child: Image.asset(
                    "assets/images/none.png"),
              );
            },
            fit: BoxFit.cover,
          )),
    ),

    title: Text(
        s.value.orderorName!.text,
        style: Theme.of(context)
            .textTheme
            .displaySmall!
            .copyWith(
                color: Colors.black,
                fontWeight:
                    FontWeight.bold)),
    subtitle: Text(
      s.value.orderorBarcode!,
      style: Theme.of(context)
          .textTheme
          .labelLarge!
          .copyWith(
              color: Colors.black),
    ),
  ),
 */