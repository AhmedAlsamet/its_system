// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'package:its_system/core/widgets/circle_icon.dart';

class SearchBox extends StatefulWidget {
  void Function(String) onSubmitted;
  void Function(String) onChanged;
  void Function() onFilter;
  void Function() onStart;
  void Function() onEnd;
  TextEditingController controller;
  FocusNode node;
  String searchTitle;
  bool showIcon;
  SearchBox({
    Key? key,
    this.showIcon = true,
    required this.onSubmitted,
    required this.onFilter,
    required this.onChanged,
    required this.onStart,
    required this.onEnd,
    required this.controller,
    required this.node,
    required this.searchTitle,
  }) : super(key: key);

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.black87.withOpacity(0.1),//headColor.withOpacity(0.3),
              offset: const Offset(1,1),
              blurRadius: 5
          ),
        ],
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(30),
      ),
      // height: AppBar().preferredSize.height,
      child: TextFormField(
        style: Theme.of(context).textTheme.displaySmall,
        // onTap: onStart,
        // onEditingComplete: onEnd,
        focusNode: widget.node,
        cursorRadius: const Radius.circular(10),
        textDirection: TextDirection.rtl,
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onSubmitted,
        keyboardType:  TextInputType.text,
        controller: widget.controller,
        // style: const TextStyle(
        //     color: Colors.black),
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          suffixIcon: circleIcon(
            icon: Icon(widget.showIcon ? Icons.filter_alt_outlined : Icons.search,color: Colors.white,)
          ,backgroundColor: Theme.of(context).primaryColor,
          onTap: ()async{
            // widget.onSubmitted(widget.controller.text);
            widget.onFilter();
            }
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide.none
          ),
          // OutlineInputBorder(
          //     borderSide: BorderSide(
          //         color: headColor
          //             .withOpacity(0.5)),
          //     borderRadius:
          //     BorderRadius.circular(
          //         20)),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide.none
          ),
        // OutlineInputBorder(
        //       borderSide: const BorderSide(
        //           color: headColor,
        //           width: 2),
        //       borderRadius:
        //       BorderRadius.circular(
        //           20)),
          label: Text(widget.searchTitle),
          labelStyle: Theme.of(context).textTheme.displaySmall!.copyWith(
            fontWeight: FontWeight.w900,
            // for label TextFailed
          ),

        ),
        validator: (v){
          if(v!.trim() == ""){
            return "emptyValue".tr();
          }
          return null;
        },
      ),
    );
  
  }
}
