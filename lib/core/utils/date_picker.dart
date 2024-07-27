import 'package:flutter/material.dart';


Future<DateTime> selectDate({required BuildContext context,required DateTime firesDate,required DateTime lastDate}) async {
  try {
    DateTime selectedDate = DateTime.now();
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: firesDate,
      lastDate: lastDate,
      initialDatePickerMode: DatePickerMode.year,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );
    if (selected != null && selected != selectedDate) {
      selectedDate = selected;
    }
    return selectedDate;
  } catch (e) {
    return DateTime.now();
  }
}

