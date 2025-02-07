import 'package:flutter_bloc/flutter_bloc.dart';

class InputCubit extends Cubit<String> {
  InputCubit() : super('0');

  void addValue(String value, bool isCalculated, String output) {
    if (state.length > 25 ||
        (state.endsWith(")") && !"+-×÷%".contains(value))) {
      return;
    }

    if (state == "0" && !"+-×÷%".contains(value)) {
      emit(value);
    } else if (state.endsWith("-") &&
        (state[state.length - 2] == "×" || state[state.length - 2] == "÷") &&
        ("+×÷".contains(value))) {
      emit(state.substring(0, state.length - 2) + value);
    } else if (((state.endsWith("-") || state.endsWith("+")) &&
            "+-×÷%".contains(value)) ||
        (((state.endsWith("×") || state.endsWith("÷")) &&
            "+×÷%".contains(value)))) {
      emit(state.substring(0, state.length - 1) + value);
    } else if (isCalculated) {
      if (!"+-×÷%".contains(value)) {
        emit(value);
      } else {
        if (output.contains("e")) {
          emit("0");
        } else {
          emit(output + value);
        }
      }
    } else {
      emit(state + value);
    }
  }

  void clearInput() {
    emit("0");
  }

  void invertSign(bool isCalculated, String output) {
    if (!isCalculated) {
      if ("+-×÷%".contains(state[state.length - 1]) || state == "0") {
        return;
      }

      List<String> parts = state.split(RegExp(r"[\+\-\×\÷\%]"));
      String lastPart = parts.last;

      if (parts.length == 1) {
        if (state.startsWith("-")) {
          emit(state.substring(1));
        } else {
          emit("(-$state)");
        }
        return;
      }

      if (state.endsWith(")")) {
        emit(state.substring(0, state.length - lastPart.length - 2) +
            lastPart.substring(0, lastPart.length - 1));
      } else if (state[state.length - lastPart.length - 1] == "-") {
        emit(
            "${state.substring(0, state.length - lastPart.length - 1)}+$lastPart");
      } else {
        emit(
            "${state.substring(0, state.length - lastPart.length)}(-$lastPart)");
      }
    } else {
      emit(output.startsWith("-") ? output.substring(1) : "(-$output)");
    }
  }

  void backscape() {
    if (state.length > 1) {
      emit(state.substring(0, state.length - 1));
    } else {
      emit("0");
    }
  }
}
