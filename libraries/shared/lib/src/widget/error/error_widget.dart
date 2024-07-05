import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class CustomErrorWidget extends StatelessWidget {
  final String message;

  CustomErrorWidget({
    required this.message,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: Sizes.dp12(context),
        ),
      ),
    );
  }
}
