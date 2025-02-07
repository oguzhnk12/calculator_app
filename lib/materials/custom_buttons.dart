// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';

class CalculatorButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String value;
  final Widget? icon;
  final Size buttonSize;
  final double fontSize;

  const CalculatorButton({
    super.key,
    required this.onPressed,
    required this.value,
    this.icon,
    required this.buttonSize,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    Color getBackgroundColor() {
      if (["+", "-", "×", "÷", "="].contains(value)) {
        return Color(0xffFF9F0A);
      } else if (["clear", "%", "invert_sign"].contains(value)) {
        return Color(0xff5C5C5E);
      } else {
        return Color(0xff2A2A2C);
      }
    }

    return TextButton(
      onPressed: onPressed,
      child: Center(
        child: icon ??
            Text(value,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                )),
      ),
      style: TextButton.styleFrom(
        maximumSize: buttonSize,
        shape: CircleBorder(),
        backgroundColor: getBackgroundColor(),
        foregroundColor: Colors.white,
      ),
    );
  }
}
