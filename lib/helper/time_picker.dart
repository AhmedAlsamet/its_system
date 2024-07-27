import 'package:flutter/material.dart';

Future<TimeOfDay> selectTime(BuildContext context,TimeOfDay selectedTime ) async {
  try {
    final TimeOfDay? selected = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        initialEntryMode: TimePickerEntryMode.inputOnly);
    if (selected != null && selected != selectedTime) {
      selectedTime = selected;
    }
    return selectedTime;
  } catch (e) {
    return TimeOfDay.now();
  }
}