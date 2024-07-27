import 'package:flutter/material.dart';

class SwitchListTileWidget extends StatelessWidget {
  bool value;
  void Function(bool)? onChanged;
  String title;
  String subTitle;

  SwitchListTileWidget( {required this.title,required this.subTitle,required this.value,required  this.onChanged,super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: Theme.of(context).cardColor,
      child: SwitchListTile(
          contentPadding: const EdgeInsets.all(10),
          activeColor: Theme.of(context).primaryColor,
          activeTrackColor:
          Theme.of(context).primaryColor.withOpacity(0.5),
          inactiveTrackColor: Colors.grey,
          title: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
            ),
          ),
          subtitle: Text(
            subTitle,
            style: Theme.of(context)
                .textTheme
                .labelLarge!
                .copyWith(
                fontWeight: FontWeight.w200),
          ),
          value: value,
          onChanged: onChanged
    )
    );
  }
}
