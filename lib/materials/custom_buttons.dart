// ignore_for_file: sort_child_properties_last
import 'package:flutter/material.dart';

class CalculatorButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String value;
  final Widget? icon;
  final double fontSize;

  const CalculatorButton({
    super.key,
    required this.onPressed,
    required this.value,
    this.icon,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    Color getBackgroundColor() {
      if (["+", "-", "×", "÷", "="].contains(value)) {
        return Colors.green;
      } else if (["clear", "%", "invert_sign"].contains(value)) {
        return Colors.blue;
      } else {
        return Color(0xff2A2A2C);
      }
    }

    return TextButton(
      onPressed: onPressed,
      child: icon ??
          Text(value,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
              )),
      style: TextButton.styleFrom(
        backgroundColor: getBackgroundColor(),
      ),
    );
  }
}
