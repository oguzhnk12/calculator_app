import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_expressions/math_expressions.dart';

class OutputCubit extends Cubit<String> {
  OutputCubit() : super("");
  Parser p = Parser();
  void calculateOutput(String input) {
    if (input == "" || RegExp(r"%÷|%×|%\+|%-").hasMatch(input)) {
      emit("Mathematical Error.");
      return;
    } else if ("+-×÷%".contains(input[input.length - 1])) {
      return;
    }
    try {
      emit(p
          .parse(input
              .replaceAll("÷", "/")
              .replaceAll("×", "*")
              .replaceAll(",", "."))
          .evaluate(EvaluationType.REAL, ContextModel())
          .toString()
          .replaceAll(RegExp(r"(\.0)+$"), "")
          .replaceAll(".", ","));
    } catch (e) {
      emit("Mathematical Error.");
    }
  }

  void clearOutput() {
    emit("");
  }
}
