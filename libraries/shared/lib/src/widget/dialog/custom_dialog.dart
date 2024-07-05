import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class CustomDialog extends StatelessWidget {
  final bool groupValue;
  final void Function(bool?)? onChanged;

  CustomDialog({
    required this.groupValue,
    this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text("Switch Theme"),
      children: <Widget>[
        RadioListTile(
          value: true,
          groupValue: groupValue,
          onChanged: onChanged,
          title: Text('Dark'),
        ),
        SizedBox(
          height: Sizes.dp10(context),
        ),
        RadioListTile(
          value: false,
          groupValue: groupValue,
          onChanged: onChanged,
          title: Text('Light'),
        ),
        SizedBox(
          height: Sizes.dp10(context),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Close'),
        ),
      ],
    );
  }
}
