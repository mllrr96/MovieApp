import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class NoInternetWidget extends StatelessWidget {
  final String message;
  final void Function() onPressed;

  NoInternetWidget({
    required this.message,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          message,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: Sizes.dp12(context),
          ),
        ),
        SizedBox(height: Sizes.dp10(context)),
        ElevatedButton.icon(
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(Sizes.dp10(context)),
          // ),
          icon: Icon(Icons.wifi),
          onPressed: onPressed,
          label: Text('Reload'),
        ),
      ],
    );
  }
}
