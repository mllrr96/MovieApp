import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDialog extends StatelessWidget {
  final ThemeMode themeMode;
  final void Function(ThemeMode?)? onChanged;

  CustomDialog({
    required this.themeMode,
    this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text("Switch Theme"),
      children: ThemeMode.values.map((e) {
        return RadioListTile(
          title: Text(toBeginningOfSentenceCase(e.name)),
          value: e,
          groupValue: themeMode,
          onChanged: onChanged,
        );
      }).toList(),
    );
  }
}
