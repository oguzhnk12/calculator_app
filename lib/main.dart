// ignore_for_file: library_private_types_in_public_api
import 'dart:math';
import 'package:calculator_app/cubits/input_cubit.dart';
import 'package:calculator_app/cubits/is_calculate_cubit.dart';
import 'package:calculator_app/cubits/output_cubit.dart';
import 'package:calculator_app/materials/custom_buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => InputCubit()),
          BlocProvider(create: (_) => IsCalculateCubit()),
          BlocProvider(create: (_) => OutputCubit()),
        ],
        child: CalculatorScreen(),
      ),
    );
  }
}

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  final Map<String, Icon?> buttons = const {
    "clear": Icon(CupertinoIcons.delete_left, size: 38.0, color: Colors.white),
    "invert_sign":
        Icon(CupertinoIcons.minus_slash_plus, size: 38.0, color: Colors.white),
    "%": Icon(CupertinoIcons.percent, size: 38.0, color: Colors.white),
    "÷": null,
    "7": null,
    "8": null,
    "9": null,
    "×": Icon(CupertinoIcons.multiply, size: 38.0, color: Colors.white),
    "4": null,
    "5": null,
    "6": null,
    "-": Icon(Icons.remove, size: 38.0, color: Colors.white),
    "1": null,
    "2": null,
    "3": null,
    "+": Icon(CupertinoIcons.add, size: 38.0, color: Colors.white),
    "": Icon(CupertinoIcons.line_horizontal_3, size: 38.0, color: Colors.white),
    "0": null,
    ",": null,
    "=": null,
  };
  void clearButtonPressed(BuildContext context) {
    context.read<InputCubit>().clearInput();
    context.read<OutputCubit>().clearOutput();
    context.read<IsCalculateCubit>().setIsCalculated(false);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double hipotenuse = sqrt(pow(width, 2) + pow(height, 2));

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            BlocBuilder<InputCubit, String>(builder: (context, input) {
              return BlocBuilder<IsCalculateCubit, bool>(
                  builder: (context, isCalculated) {
                return _buildDisplay(isCalculated ? input : "",
                    Color(0xff8D8C91), 32.0, hipotenuse * 0.015);
              });
            }),
            BlocBuilder<InputCubit, String>(builder: (context, input) {
              return BlocBuilder<IsCalculateCubit, bool>(
                  builder: (context, isCalculated) {
                return BlocBuilder<OutputCubit, String>(
                    builder: (context, output) {
                  return _buildDisplay(isCalculated ? output : input,
                      Colors.white, 52.0, hipotenuse * 0.015);
                });
              });
            }),
            _buildButtons(
                context, width * 0.22, height * 0.11, hipotenuse * 0.04),
          ],
        ),
      ),
    );
  }

  Widget _buildDisplay(
      String text, Color color, double fontSize, double paddingValue) {
    return Expanded(
      flex: 3,
      child: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: EdgeInsets.only(right: paddingValue),
          child: Text(
            text,
            style: TextStyle(
                fontSize: fontSize, color: color, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  Widget _buildButtons(
      BuildContext context, double width, double height, double fontSize) {
    return Expanded(
      flex: 12,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: List.generate((buttons.length / 4).toInt(), (index) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(4, (i) {
              String key = buttons.keys.toList()[index * 4 + i];
              return CalculatorButton(
                onPressed: () => _handleButtonPress(context, key),
                value: key,
                icon: _getButtonIcon(context, key),
                buttonSize: Size(width, height),
                fontSize: fontSize,
              );
            }),
          );
        }),
      ),
    );
  }

  Widget? _getButtonIcon(BuildContext context, String key) {
    if (key == "clear" && context.read<IsCalculateCubit>().state) {
      return Text(
        "AC",
        style: TextStyle(
          fontSize: 38.0,
          fontWeight: FontWeight.w500,
        ),
      );
    }
    return buttons[key];
  }

  void _handleButtonPress(BuildContext context, String key) {
    final inputCubit = context.read<InputCubit>();
    final outputCubit = context.read<OutputCubit>();
    final isCalculateCubit = context.read<IsCalculateCubit>();

    if (outputCubit.state == "Mathematical Error.") {
      clearButtonPressed(context);
    } else if (key == "clear") {
      isCalculateCubit.state
          ? clearButtonPressed(context)
          : inputCubit.backscape();
    } else if (key == "=") {
      outputCubit.calculateOutput(inputCubit.state);
      isCalculateCubit.setIsCalculated(true);
    } else if (key == "invert_sign") {
      inputCubit.invertSign(isCalculateCubit.state, outputCubit.state);
      isCalculateCubit.setIsCalculated(false);
    } else {
      inputCubit.addValue(key, isCalculateCubit.state, outputCubit.state);
      isCalculateCubit.setIsCalculated(false);
    }
  }
}
