// ignore_for_file: must_be_immutable

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:its_system/core/models/dropdown_button_model.dart';
import 'package:its_system/core/utils/date_picker.dart';
import 'package:its_system/core/widgets/circle_button.dart';
import 'package:its_system/core/widgets/dropdown_button.dart';
import 'package:its_system/core/widgets/input_field.dart';
import 'package:its_system/core/widgets/switch_list_widget.dart';
import 'package:its_system/helper/open_camera_gallery.dart';
import 'package:its_system/models/service_model.dart';

class ColumnsAsWidgets extends StatefulWidget {
  FormFieldTypes columnType;
  Function generalChange;
  List<String>? values;
  TextEditingController value;
  String title;
  bool isNull;
  ColumnsAsWidgets({
    Key? key,
    required this.columnType,
    required this.generalChange,
    required this.value,
    required this.title,
    required this.isNull,
    this.values = const [],
  }) : super(key: key);

  @override
  State<ColumnsAsWidgets> createState() => _ColumnsAsWidgetsState();
}

class _ColumnsAsWidgetsState extends State<ColumnsAsWidgets> {
  @override
  Widget build(BuildContext context) {
    if (widget.columnType == FormFieldTypes.BOOLEAN) {
      return SizedBox(
        width: 300,
        child: SwitchListTileWidget(
            title: widget.title,
            subTitle: "",
            value: widget.value.text == "true",
            onChanged: (v) async {
              await widget.generalChange(
                value: v,
              );
            }),
      );
    }
    if (widget.columnType == FormFieldTypes.PDF_FILE ||
        widget.columnType == FormFieldTypes.IMAGE_FILE) {
      return SelectImageOrFile(
        onChanged: (v) async {
          await widget.generalChange(
            value: v,
          );
        },
        file: File(widget.value.text),
        title: widget.title,
        type: widget.columnType,
      );
    }
    if (widget.columnType == FormFieldTypes.DATE) {
      return DateTimeWidget(
          onChanged: (v) async {
            await widget.generalChange(
              value: v!.toString(),
            );
          },
          dateTime: DateTime.tryParse(widget.value.text) ?? DateTime.now(),
          title: widget.title,
          type: widget.columnType);
    }
    if (widget.columnType == FormFieldTypes.CHECKBOX ||
        widget.columnType == FormFieldTypes.RADIO ||
        widget.columnType == FormFieldTypes.COMPOBOX) {
      return Row(
        children: [
          Text(
            widget.title,
            style: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: Column(
              children: [
                 ...widget.values!.asMap().entries.map((cc) {
              if (widget.columnType == FormFieldTypes.CHECKBOX) {
                return CheckListTileWidget(
                  title: cc.value,
                  value: widget.value.text == cc.value,
                  onChanged: (v) async {
                    await widget.generalChange(value: v);
                  },
                );
              }
              if (widget.columnType == FormFieldTypes.RADIO) {
                return RadioButtonWidget(
                  groupValue: widget.value.text,
                  title: cc.value,
                  value: cc.value,
                  onChanged: (v) async {
                    await widget.generalChange(
                      value: v,
                    );
                  },
                );
              }
              return DropdownButtonWidget(
                  node: FocusNode(),
                  title: widget.title,
                  selectedItem: widget.value.text,
                  items: widget.values!
                      .asMap()
                      .entries
                      .map((cc) => DropdownButtonModel(
                          dropName: cc.value,
                          dropOrder: cc.key,
                          dropValue: cc.value))
                      .toList(),
                  onChanged: (v) async {
                    await widget.generalChange(
                      value: v,
                    );
                  });
            }),
              ],
            ),
          )
        ],
      );
    }
    if (widget.columnType == FormFieldTypes.INPUT_NUMBER ||
        widget.columnType == FormFieldTypes.INPUT_TEXT ||
        widget.columnType == FormFieldTypes.INPUT_EMAIL) {
      return SizedBox(
        child: InputField(
          isRequired: !widget.isNull,
          node: FocusNode(),
          keyboardType: widget.columnType == FormFieldTypes.INPUT_NUMBER
              ? TextInputType.number
              : widget.columnType == FormFieldTypes.INPUT_TEXT
                  ? TextInputType.text
                  : TextInputType.multiline,
          controller:  widget.value,
          isNumber: widget.columnType == FormFieldTypes.INPUT_NUMBER,
          label: widget.title,
        ),
      );
    }
    return const SizedBox();
  }
}

class SelectImageOrFile extends StatelessWidget {
  SelectImageOrFile({
    super.key,
    required this.file,
    this.title,
    required this.type,
    required this.onChanged,
  });

  File file;
  String? title;
  FormFieldTypes type;
  void Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    if (type == FormFieldTypes.PDF_FILE) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null)
            Text(title!, style: Theme.of(context).textTheme.displaySmall!),
          const SizedBox(
            width: 5,
          ),
          (file.path == '')
              ? CircleButton(
                  iconSize: 30,
                  onPressed: () async {
                    String path = await pickFile();
                    onChanged(path);
                    //  file = File(path);
                  },
                  icon: Icons.storage_outlined)
              : CircleButton(
                  iconSize: 30,
                  onPressed: () {
                    file = File('');
                  },
                  icon: Icons.cancel)
        ],
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null)
          Text(title!, style: Theme.of(context).textTheme.displaySmall!),
        const SizedBox(
          width: 5,
        ),
        (file.path == '')
            ? Row(
                children: [
                  CircleButton(
                      iconSize: 30,
                      onPressed: () async {
                        String path = await openGallery();
                        onChanged(path);
                        // file = File(path);
                      },
                      icon: Icons.storage_outlined),
                  CircleButton(
                      iconSize: 30,
                      onPressed: () async {
                        String path = await openCamera();
                        onChanged(path);
                        // file = File(path);
                      },
                      icon: Icons.camera_outlined),
                ],
              )
            : CircleButton(
                iconSize: 30,
                onPressed: () {
                  file = File('');
                },
                icon: Icons.cancel),
      ],
    );
  }
}

class DateTimeWidget extends StatelessWidget {
  DateTime dateTime;
  String? title;
  FormFieldTypes type;
  void Function(DateTime?) onChanged;

  DateTimeWidget(
      {required this.onChanged,
      required this.dateTime,
      this.title,
      required this.type,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (type == FormFieldTypes.DATE)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null)
                Text(
                  title!,
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              SizedBox(
                  width: 140,
                  child: Card(
                    elevation: 5,
                    color: Theme.of(context).backgroundColor,
                    child: ListTile(
                      focusNode: FocusNode(canRequestFocus: false),
                      onTap: () async {
                        final newDate = await selectDate(
                            context: context,
                            firesDate: DateTime(2000),
                            lastDate: DateTime.now());
                        // dateTime =
                        // DateTime(
                        //     newDate.year,
                        //     newDate.month,
                        //     newDate.day,
                        //     dateTime
                        //         .hour,
                        //     dateTime
                        //         .minute);
                        onChanged(DateTime(newDate.year, newDate.month,
                            newDate.day, dateTime.hour, dateTime.minute));
                      },
                      title: Text(DateFormat('yyyy-MM-dd').format(dateTime),
                          style: Theme.of(context).textTheme.displaySmall!),
                    ),
                  )),
            ],
          ),
      ],
    );
  }
}

class CheckListTileWidget extends StatelessWidget {
  bool value;
  void Function(bool?)? onChanged;
  String title;
  String? subTitle;

  CheckListTileWidget(
      {required this.title,
      this.subTitle,
      required this.value,
      required this.onChanged,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5,
        color: Theme.of(context).cardColor,
        child: CheckboxListTile(
            contentPadding: const EdgeInsets.all(10),
            activeColor: Theme.of(context).primaryColor,
            // tileColor: Theme.of(context).primaryColor.withOpacity(0.5),
            overlayColor:
                MaterialStateColor.resolveWith((states) => Colors.grey),
            title: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child:
                  Text(title, style: Theme.of(context).textTheme.displaySmall!),
            ),
            subtitle: subTitle != null
                ? Text(
                    subTitle!,
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(fontWeight: FontWeight.w200),
                  )
                : null,
            value: value,
            onChanged: onChanged));
  }
}

class RadioButtonWidget<T> extends StatelessWidget {
  T value;
  void Function(T?)? onChanged;
  T groupValue;
  String title;
  String? subTitle;

  RadioButtonWidget(
      {required this.title,
      this.subTitle,
      required this.value,
      required this.onChanged,
      required this.groupValue,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5,
        color: Theme.of(context).cardColor,
        child: RadioListTile<T>(
            groupValue: groupValue,
            contentPadding: const EdgeInsets.all(10),
            activeColor: Theme.of(context).primaryColor,
            // tileColor: Theme.of(context).primaryColor.withOpacity(0.5),
            overlayColor:
                MaterialStateColor.resolveWith((states) => Colors.grey),
            title: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child:
                  Text(title, style: Theme.of(context).textTheme.displaySmall!),
            ),
            subtitle: subTitle != null
                ? Text(
                    subTitle!,
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(fontWeight: FontWeight.w200),
                  )
                : null,
            value: value,
            onChanged: onChanged));
  }
}
