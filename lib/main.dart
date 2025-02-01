// ignore_for_file: library_private_types_in_public_api

import 'package:calculator_app/materials/custom_buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String input = "0";
  String output = "";
  bool isCalculated = false;
  bool isError = false;
  Parser p = Parser();
  // Butonlar ve butonlara karşılık gelen iconlar
  Map<String, Icon?> buttons = {
    "clear": Icon(
      CupertinoIcons.delete_left,
      size: 38.0,
      color: Colors.white,
    ),
    "invert_sign": Icon(
      CupertinoIcons.minus_slash_plus,
      size: 38.0,
      color: Colors.white,
    ),
    "%": Icon(
      CupertinoIcons.percent,
      size: 38.0,
      color: Colors.white,
    ),
    "÷": null,
    "7": null,
    "8": null,
    "9": null,
    "×": Icon(
      CupertinoIcons.multiply,
      size: 38.0,
      color: Colors.white,
    ),
    "4": null,
    "5": null,
    "6": null,
    "-": Icon(
      Icons.remove,
      size: 38.0,
      color: Colors.white,
    ),
    "1": null,
    "2": null,
    "3": null,
    "+": Icon(
      CupertinoIcons.add,
      size: 38.0,
      color: Colors.white,
    ),
    "": Icon(
      CupertinoIcons.line_horizontal_3,
      size: 38.0,
      color: Colors.white,
    ),
    "0": null,
    ",": null,
    "=": null,
  };
// Hata kontrolü fonksiyonu
  void errorCheck() {
    if (isError) {
      input = "0";
      isError = false;
    }
  }

// Hesaplama fonksiyonu
  void calc() {
    try {
      output = p
          .parse(input
              .replaceAll("÷", "/")
              .replaceAll("×", "*")
              .replaceAll(",", "."))
          .evaluate(EvaluationType.REAL, ContextModel())
          .toString()
          .replaceAll(RegExp(r"(\.0)+$"), "")
          .replaceAll(".", ",");
    } catch (e) {
      output = "Mathematical Error.";
      isError = true;
    }
  }

// Butonlara basıldığında yapılacak işlemler
  void buttonPressed(String value) {
    errorCheck(); // Hata kontrolü yapılır
    setState(() {
      // State güncellenir
      // Eğer input 25 karakteri geçerse ya da input sonu ")" olup value geçerli bir işlem operatörü değilse, işlemi durdur
      if (input.length > 25 ||
          (input.endsWith(")") && !"+-×÷%".contains(value))) {
        return;
      }

      // Eğer input "0" ise ve value geçerli bir işlem operatörü değilse, input yeni value ile değiştirilir
      if (input == "0" && !"+-×÷%".contains(value)) {
        input = value;
      }
      // Eğer input "-" ile bitiyorsa ve önceki karakter "×" veya "÷" ise ve value geçerli operatörlerden biriyse,
      // input'dan son iki karakter silinir ve yeni value eklenir
      else if (input.endsWith("-") &&
          (input[input.length - 2] == "×" || input[input.length - 2] == "÷") &&
          ("+×÷".contains(value))) {
        input = input.substring(0, input.length - 2); // Son iki karakteri sil
        input += value; // Yeni value ekle
      }
      // Eğer input "+" veya "-" ile bitiyorsa ve value geçerli bir işlem operatörü içeriyorsa,
      // input'dan son karakter silinir ve yeni value eklenir
      else if (((input.endsWith("-") || input.endsWith("+")) &&
              "+-×÷%".contains(value)) ||
          (((input.endsWith("×") || input.endsWith("÷")) &&
              "+×÷%".contains(value)))) {
        input = input.substring(0, input.length - 1); // Son karakteri sil
        input += value; // Yeni value ekle
      }
      // Eğer hesaplama tamamlandıysa (isCalculated), value'ya göre input güncellenir
      else if (isCalculated) {
        if (!"+-×÷%".contains(value)) {
          input = value; // Yeni value atanır
          output = ""; // Output sıfırlanır
        } else {
          if (output.contains("e")) {
            input =
                "0"; // Eğer çıktı "e" içeriyorsa(yani büyük bir sayıysa) çıktı sıfırlanır,
          } else {
            input = output +
                value; // Eğer çıktı "e" içermiyorsa, çıktı input'a atanır ve value eklenir
            output = ""; // Çıktı sıfırlanır
          }
        }
      } else {
        input += value; // Yeni value ekle
      }
      isCalculated = false; // hesaplama tamamlandı mı kontrolü sıfırlanır
    });
  }

// Hesaplama yapılması için butona basıldığında yapılacak işlemler
  void calculateButtonPressed() {
    errorCheck(); // Hata kontrolü yapılır
    setState(() {
      //  State güncellenir
      if (input == "" || RegExp(r"%÷|%×|%\+|%-").hasMatch(input)) {
        // Eğer input boş ise ya da inputta geçersiz bir işlem varsa
        input = "Mathematical Error."; // inputa hata mesajı atanır
        isError = true; // isError true yapılır
        return; // işlemi durdur
      } else if ("+-×÷%".contains(input[input.length - 1])) {
        // Eğer inputun son karakteri bir işlem operatörü ise
        return; // işlemi durdur
      }
      calc(); // Hesaplama yapılır
      isCalculated = true; // Hesaplama tamamlandı mı kontrolü true yapılır
    });
  }

// İşaret değiştirme butonuna basıldığında yapılacak işlemler
  void invertSignButtonPressed() {
    errorCheck(); // Hata kontrolü yapılır
    setState(() {
      if (!isCalculated) {
        // Eğer hesaplama tamamlanmadıysa
        if ("+-×÷%0".contains(input[input.length - 1])) {
          return; // Eğer input son karakteri geçerli bir işlem operatörü veya "0" ise işlemi durdur
        }

        List<String> parts = input.split(RegExp(
            r"[\+\-\×\÷\%]")); // Inputu işlem operatörlerine göre böl ve parçaları listeye ata
        String lastPart = parts.last; // Listenin son parçasını al

        if (input.endsWith(")")) {
          // Eğer input ")" ile bitiyorsa
          input = input.substring(
                  0,
                  input.length -
                      lastPart.length -
                      2) + // Inputun son kısmını kes
              lastPart.substring(
                  0, lastPart.length - 1); // Son parçanın son karakterini kes
        } else if (input[input.length - lastPart.length - 1] == "-") {
          // Eğer inputun son parçasından önceki karakter "-" ise
          input =
              "${input.substring(0, input.length - lastPart.length - 1)}+$lastPart"; // "-" işaretini "+" ile değiştir
        } else {
          // Diğer durumlarda
          input =
              "${input.substring(0, input.length - lastPart.length)}(-$lastPart)"; // Son parçayı parantez içine al ve "-" işareti ekle
        }
      } else {
        // Eğer hesaplama tamamlandıysa
        input = output.startsWith("-")
            ? output.substring(1)
            : "(-$output)"; // Çıktının başında "-" varsa kes, yoksa parantez içine al ve "-" ekle
        isCalculated = false; // Hesaplama tamamlandı mı kontrolünü sıfırla
      }
    });
  }

// Temizleme butonuna basıldığında yapılacak işlemler
  void clearButtonPressed() {
    errorCheck();
    setState(() {
      output = "";
      input = "0";
      isCalculated = false;
    });
  }

// Geri butonuna basıldığında yapılacak işlemler
  void backscapeButtonPressed() {
    errorCheck();
    setState(() {
      if (input.length > 1) {
        input = input.substring(0, input.length - 1);
      } else {
        input = "0";
      }
    });
  }

// Widget oluşturma
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildDisplay(isCalculated ? input : "", Color(0xff8D8C91)),
            _buildDisplay(isCalculated ? output : input, Colors.white),
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildDisplay(String text, Color color) {
    return Expanded(
      flex: 3,
      child: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Text(
            text,
            style: TextStyle(
                fontSize: 52.0, color: color, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  Widget _buildButtons() {
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
                onPressed: () => _handleButtonPress(key),
                value: key,
                icon: key == "clear" && isCalculated
                    ? Icon(Icons.undo, size: 38.0, color: Colors.white)
                    : buttons[key],
              );
            }),
          );
        }),
      ),
    );
  }

  void _handleButtonPress(String key) {
    if (key == "clear") {
      isCalculated ? clearButtonPressed() : backscapeButtonPressed();
    } else if (key == "=") {
      calculateButtonPressed();
    } else if (key == "invert_sign") {
      invertSignButtonPressed();
    } else {
      buttonPressed(key);
    }
  }
}
