// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:its_system/core/utils/date_picker.dart';
import 'package:its_system/helper/time_picker.dart';

class DateWidget extends StatelessWidget {
  final String dateTitle;
  final String timeTitle;
  final bool withTime;
  DateTime date;
  Duration? duration;
  final Function(DateTime) onDateChange;
  DateWidget({super.key, required this.dateTitle, required this.withTime, required this.date, required this.onDateChange, required this.timeTitle,this.duration});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if(dateTitle != "")
        Text(
          dateTitle,
          style: Theme.of(context)
              .textTheme
              .displaySmall!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        Expanded(
            flex: 9,
            child: Card(
              elevation: 5,
              color: Theme.of(context).cardColor,
              child: ListTile(
                onTap: () async {
                  DateTime newDate = await selectDate(
                      context: context,
                      firesDate: DateTime(2020),
                      lastDate: DateTime.now().add(duration ?? Duration(seconds: 1)));
                      date = DateTime(
                        newDate.year,
                        newDate.month,
                        newDate.day,
                        date.hour,
                        date.minute);
                      onDateChange(date);
                },
                title: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                      DateFormat('yyyy-MM-dd').format(date),
                      style: Theme.of(context).textTheme.displaySmall!),
                ),
              ),
            )),
        if(timeTitle != "")
        Text(
          timeTitle,
          style: Theme.of(context)
              .textTheme
              .displaySmall!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        Expanded(
          flex: 8,
          child: Card(
            elevation: 5,
            color: Theme.of(context).cardColor,
            child: ListTile(
              onTap: () async {
                final newDate = await selectTime(
                    context,
                    TimeOfDay(
                        hour: date.hour,
                        minute: date.minute));
                    date = DateTime.parse(
                      "${DateFormat('yyyy-MM-dd').format(date)} ${newDate.hour < 10 ? "0" : ""}${newDate.hour}:${newDate.minute < 10 ? "0" : ""}${newDate.minute}");
                        onDateChange(date);
              },
              title: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                    DateFormat('hh:mm a').format(date),
                    style: Theme.of(context).textTheme.displaySmall!),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
