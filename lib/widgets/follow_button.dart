import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';

class FollowButton extends StatelessWidget {
  final Function()? function;
  final Color backgroundColor;
  final Color borderColor;
  final String text;

  const FollowButton({
    Key? key,
    this.function,
    required this.borderColor,
    required this.backgroundColor,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const  EdgeInsets.only(top: 12),
      child: TextButton(
        onPressed: function,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(5),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: const TextStyle(
              letterSpacing: 0.4,
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          width: 220,
          height: 30,
        ),
      ),
    );
  }
}
