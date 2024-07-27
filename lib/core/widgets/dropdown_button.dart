import 'package:flutter/material.dart';
import 'package:its_system/core/models/dropdown_button_model.dart';


class DropdownButtonWidget<T> extends StatelessWidget {
  const DropdownButtonWidget({
    super.key,
    this.readOnly = false,
    this.onChanged,
    this.onTap,
    this.menuMaxHeight,
    this.selectedItem,
    required this.node,
    required this.items,
    required this.title,
  });

  final bool? readOnly;
  final String title;
  final void Function(T?)? onChanged;
  final void Function()? onTap;
  final FocusNode node;
  final double? menuMaxHeight;
  final T? selectedItem;
  final List<DropdownButtonModel> items;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("$title :",style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold)),
        Expanded(
          child: DropdownButton<T>(
            items: items.map((e) => DropdownMenuItem<T>(
              value: e.dropValue,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  e.dropName!,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              ),).toList(),
            onChanged: readOnly! ? null :  onChanged,
            // icon: SizedBox(),
            isExpanded: true,
            focusNode: node,
            onTap: onTap,
            menuMaxHeight: menuMaxHeight,
            value: selectedItem,
            dropdownColor: Theme.of(context).cardColor,
              ),
        ),
      ],
    );
    }
}
class PopupMenuWidget<T> extends StatelessWidget {
  const PopupMenuWidget({
    super.key,
    this.readOnly = false,
    this.onChanged,
    this.onTap,
    this.menuMaxHeight,
    this.selectedItem,
    required this.node,
    required this.items,
  });

  final bool? readOnly;
  final void Function(T?)? onChanged;
  final void Function()? onTap;
  final FocusNode node;
  final double? menuMaxHeight;
  final T? selectedItem;
  final List<DropdownButtonModel> items;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context){
        return items.map((e) => PopupMenuItem<T>(
        value: e.dropValue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              e.dropName!,
              style: Theme.of(context).textTheme.displayMedium!,
            ),
            if(e.dropImage != null)
                  Image.asset(e.dropImage!,width: 50,)
          ],
        ),
        ),).toList();
      },
      onOpened: onTap,
      onSelected: onChanged,
      tooltip: "",
      initialValue: selectedItem,
      child: Row(
        children: [
          Text(items.firstWhere((element) => element.dropValue == selectedItem).dropName!,
              style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.white,fontWeight: FontWeight.bold),),
              const SizedBox(width: 10,),
              if(items.firstWhere((element) => element.dropValue == selectedItem).dropImage != null)
                  Image.asset(items.firstWhere((element) => element.dropValue == selectedItem).dropImage!,width: 50,)
        ],
      ),
        );
    }
}