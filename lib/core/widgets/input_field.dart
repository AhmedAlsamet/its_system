import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:its_system/constants.dart';

class InputField extends StatelessWidget {
  const InputField({
    super.key,
    required this.isRequired,
    this.readOnly = false,
    this.isNumber = false,
    this.isZero = true,
    this.isNagative = true,
    this.obscureText = false,
    this.withBorder = true,
    this.enabled = true,
    this.autoFocus = false,
    required this.node,
    required this.keyboardType,
    required this.controller,
    this.label,
    this.hint,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
    this.onTapOutside,
    this.onEditingComplete,
    this.maxLines,
    this.maxLength,
    this.suffix,
    this.textForErrorMessage,
    this.additionsalCondection = false,
  });

  final bool isRequired;
  final bool? readOnly;
  final bool enabled;
  final bool isNumber;
  final bool isZero;
  final bool isNagative;
  final bool obscureText;
  final bool? additionsalCondection;
  final bool withBorder;
  final bool autoFocus;
  final FocusNode node;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final String? textForErrorMessage;
  final int? maxLines;
  final int? maxLength;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final void Function()? onTap;
  final Function(PointerDownEvent)? onTapOutside;
  final Function()? onEditingComplete;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: (maxLength == null && keyboardType == TextInputType.number)? 10 : maxLength ,
      enabled: enabled,
      autofocus: autoFocus,
      onTapOutside: onTapOutside,
      onEditingComplete: onEditingComplete,
      onTap: onTap,
      readOnly: readOnly!,
      obscureText: obscureText,
      // contextMenuBuilder: (context, editableTextState) => const SizedBox(),
      validator: (v){
                if(isRequired){
                  if(v!.trim() == "")
                  {
                    return "emptyValue".tr();
                  }
                  if(v.trim().contains("drop") || v.trim().contains("alter") || v.trim().contains("--") || v.trim().contains(" delete ") || v.trim().contains(" rem ") || v.trim().contains(" and ") || v.trim().contains(" or ")||v.trim().contains(" in "))
                  {
                    return "wrongValue".tr();
                  }
                  if(isNumber){
                    if(num.tryParse(v) == null){
                      return "youShouldJustEnterNumbersInThisField".tr();
                    }
                    if(isZero && (num.tryParse(v)?? 0) == 0 ){
                      return "youShouldNotEnterZeroInThisField".tr();
                    }
                    if(isNagative && (num.tryParse(v)?? 0) < 0 ){
                      return "youShouldNotEnterANagativeValueInThisField".tr();
                    }
                  }
                  return null;
                }
                if(additionsalCondection! && controller.text != ""){
                  return textForErrorMessage;
                }
                return null;
              },
      onFieldSubmitted:onFieldSubmitted,
      maxLines: obscureText ? 1 : maxLines,
      style: Theme.of(context).textTheme.displaySmall,
      onChanged: onChanged,
              focusNode: node,
              keyboardType: keyboardType,
              controller:controller ,
              // style: const TextStyle(color: Colors.black),
              cursorColor: Theme.of(context).primaryColor,
              decoration: InputDecoration(
                suffixIcon: suffix,
                counter: const SizedBox(),
                errorStyle: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: redColor
                ),
                errorBorder: withBorder ? OutlineInputBorder(
                    borderSide: const BorderSide(color: redColor),
                    borderRadius: BorderRadius.circular(20)) : null,
                enabledBorder: withBorder ? OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).primaryColor.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(20)) : null,
                focusedBorder: withBorder ? OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Theme.of(context).primaryColor, width: 2),
                    borderRadius: BorderRadius.circular(20)) : null,
                label: label == null ? null :Text(label!),
                labelStyle: Theme.of(context).textTheme.displaySmall!.copyWith(
                  fontWeight: FontWeight.w500,
                  // for label TextFailed
                ),
                hintStyle: Theme.of(context).textTheme.labelLarge!.copyWith(
                  fontWeight: FontWeight.w500,
                  // for label TextFailed
                ),
                hintText: hint ?? ""
              ),
            );
          }
}