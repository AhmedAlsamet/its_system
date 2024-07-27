import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:its_system/core/widgets/input_field.dart';
import 'package:its_system/models/general_model.dart';

// ignore: curly_braces_in_flow_control_structures,
List<Widget> getLanguagesAsWidgets(GeneralModel name,[bool byCurentLang = false]) {

  List<Widget> result = [];
      if(byCurentLang){
        if(translator.activeLanguageCode == "ar"){
          result.add(InputField(
              isRequired: true,
              node: FocusNode(),
              keyboardType: TextInputType.name,
              controller: name.englishTitle!,
              hint: "${name.arabicHint!} ${"withArabic".tr()}",
            ));
          result.add(InputField(
              isRequired: true,
              node: FocusNode(),
              keyboardType: TextInputType.name,
              controller: name.englishTitle!,
              hint: "${name.arabicHint!} ${"withEnglish".tr()}",
            ));
            return result;
        }
        result.add(InputField(
          isRequired: true,
          node: FocusNode(),
          keyboardType: TextInputType.name,
          controller: name.englishTitle!,
          hint: "${name.arabicHint!} ${"withEnglish".tr()}",
        ));
        return result;
      }
          result.add(InputField(
              isRequired: true,
              node: FocusNode(),
              keyboardType: TextInputType.name,
              controller: name.englishTitle!,
              hint: "${name.arabicHint!} ${"withArabic".tr()}",
            ));
          result.add(InputField(
              isRequired: true,
              node: FocusNode(),
              keyboardType: TextInputType.name,
              controller: name.englishTitle!,
              hint: "${name.arabicHint!} ${"withEnglish".tr()}",
            ));
          result.add(InputField(
            isRequired: true,
            node: FocusNode(),
            keyboardType: TextInputType.name,
            controller: name.englishTitle!,
            hint: "${name.arabicHint!} ${"withKurdish".tr()}",
          ));

  return result;
}

List<Widget> getLanguagesAsWidgets2(GeneralModel name,FocusNode node,[List<String>? languagList,int? maxLines,FocusNode? nextNode]) {
  List<FocusNode> nodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];
List<Widget> result = [];
  if(languagList == null || languagList.isEmpty){
    return [
      InputField(
              isRequired: true,
              node: node,
              maxLines: maxLines,
              keyboardType: maxLines != null? TextInputType.multiline : TextInputType.text,
              controller: name.arabicTitle!,
              label: name.arabicHint!,
              onFieldSubmitted: (v){
                nodes[0].requestFocus();
              },
            )];
    }
  for (var i = 0; i < languagList.length; i++) {
        if(languagList[i] == "ar"){
          result.add(InputField(
              isRequired: true,
              node: node,
              maxLines: maxLines,
              keyboardType: maxLines != null? TextInputType.multiline : TextInputType.text,
              controller: name.arabicTitle!,
              label: "${name.arabicHint??""} ${"withArabic".tr()}",
              onFieldSubmitted: (v){
                nodes[0].requestFocus();
              },
            ));
          result.add(SizedBox(height: 10,));
        }
         if(languagList[i] == "en"){
          result.add(InputField(
              isRequired: true,
              node: nodes[1],
              maxLines: maxLines,
              keyboardType: maxLines != null? TextInputType.multiline : TextInputType.text,
              controller: name.englishTitle!,
              label: "${name.englishHint??""} ${"withEnglish".tr()}",
              onFieldSubmitted: (v){
                if(nextNode != null) {
                  nextNode.requestFocus();
                }
              },
            ));
        }
  }
  return result;
}
