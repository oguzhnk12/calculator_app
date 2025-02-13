// ignore_for_file: library_private_types_in_public_api

import 'package:calculator_app/cubits/input_cubit.dart';
import 'package:calculator_app/cubits/is_calculated_cubit.dart';
import 'package:calculator_app/cubits/output_cubit.dart';
import 'package:calculator_app/materials/custom_buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(426.6, 952.0),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) {
        return MaterialApp(
          title: 'Calculator',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.grey,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
            ),
            textTheme: TextTheme(
              bodyLarge: TextStyle(color: Colors.white),
              bodyMedium: TextStyle(color: Colors.white),
            ),
          ),
          home: MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => InputCubit()),
              BlocProvider(create: (_) => IsCalculatedCubit()),
              BlocProvider(create: (_) => OutputCubit()),
            ],
            child: CalculatorScreen(),
          ),
        );
      },
    );
  }
}

class CalculatorScreen extends StatelessWidget {
  CalculatorScreen({super.key});

  final Map<String, IconData?> buttons = {
    "": CupertinoIcons.line_horizontal_3,
    "0": null,
    ",": null,
    "=": null,
    "7": null,
    "8": null,
    "9": null,
    "×": CupertinoIcons.multiply,
    "4": null,
    "5": null,
    "6": null,
    "-": Icons.remove,
    "1": null,
    "2": null,
    "3": null,
    "+": CupertinoIcons.add,
    "clear": CupertinoIcons.delete_left,
    "invert_sign": CupertinoIcons.minus_slash_plus,
    "%": CupertinoIcons.percent,
    "÷": null,
  };

  void clearButtonPressed(BuildContext context) {
    context.read<InputCubit>().clearInput();
    context.read<OutputCubit>().clearOutput();
    context.read<IsCalculatedCubit>().setIsCalculated(false);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            BlocBuilder<InputCubit, String>(builder: (context, input) {
              return BlocBuilder<IsCalculatedCubit, bool>(
                  builder: (context, isCalculated) {
                return _buildDisplay(
                    isCalculated ? input : "", Color(0xff8D8C91), 32.0.sp);
              });
            }),
            BlocBuilder<InputCubit, String>(builder: (context, input) {
              return BlocBuilder<IsCalculatedCubit, bool>(
                  builder: (context, isCalculated) {
                return BlocBuilder<OutputCubit, String>(
                    builder: (context, output) {
                  return _buildDisplay(
                      isCalculated ? output : input, Colors.white, 52.0.sp);
                });
              });
            }),
            _buildButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDisplay(String text, Color color, double fontSize) {
    return Expanded(
      flex: 4,
      child: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: EdgeInsets.only(right: 32.0.sp),
          child: Text(
            text,
            style: TextStyle(
                fontSize: fontSize, color: color, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Expanded(
      flex: 13,
      child: SizedBox(
        child: GridView.count(
          crossAxisCount: 4,
          reverse: true,
          children: List.generate(buttons.length, (index) {
            String key = buttons.keys.toList()[index];
            return CalculatorButton(
              onPressed: () => _handleButtonPress(context, key),
              value: key,
              icon: _getButtonIcon(context, key),
              fontSize: 64.0.sp,
            );
          }),
        ),
      ),
    );
  }

  Widget? _getButtonIcon(BuildContext context, String key) {
    if (key == "clear" && context.read<IsCalculatedCubit>().state) {
      return Text(
        "AC",
        style: TextStyle(
          fontSize: 38.0.sp,
          fontWeight: FontWeight.w500,
        ),
      );
    }
    return buttons[key] != null
        ? Icon(buttons[key], size: 38.0.sp, color: Colors.white)
        : null;
  }

  void _handleButtonPress(BuildContext context, String key) {
    final inputCubit = context.read<InputCubit>();
    final outputCubit = context.read<OutputCubit>();
    final isCalculateCubit = context.read<IsCalculatedCubit>();

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
