import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class FormatterHelpers {
  static String firstLetterToUpperCase(String input) {
    if (input == null || input.length == 0) return input;
    String firstLetter = input[0].toUpperCase();
    String upperCaseFirstLetter = input.replaceRange(0, 1, firstLetter);
    return upperCaseFirstLetter;
  }

  static String uppercaseAfterSpecialChar(String input, String specialChar,
      {List<String> exceptions = const []}) {
    if (input == null || input.length == 0) return input;
    if (!input.contains(specialChar)) return input;

    List<String> parts = input.split(specialChar);
    List<String> transformed = List<String>.from(parts.map((part) {
      if (part.length >= 2) {
        if (!exceptions.contains(part) && part[1] != "’")
          return firstLetterToUpperCase(part);
      } else if (!exceptions.contains(part)) {
        return firstLetterToUpperCase(part);
      }
      return part;
    }));
    String result = transformed.join(specialChar);
    return result;
  }
}

class NameInputFormatterHelpers {
  static List<String> partialParticleMatches(List<String> keepLowerCase) {
    List<String> partialMatches = [];

    keepLowerCase.forEach((particle) {
      List<String> particleSubstrings = generateParticleSubstrings(particle);
      partialMatches.addAll(particleSubstrings);
    });
    return partialMatches;
  }

  static List<String> generateParticleSubstrings(String particle) {
    List<String> particleSubstrings = [];
    List<String> particleLetters = particle.split('');
    for (int i = particleLetters.length; i >= 1; i--) {
      String substring = particleLetters.sublist(0, i).join();
      particleSubstrings.add(substring);
    }
    return particleSubstrings;
  }
}

class Convert {
  // returns null if empty/null input or parse not possible
  double toDouble(String str) {
    str = str?.trim();
    if (str != null) return double.tryParse(str);
    return null;
  }

  // returns null if empty/null input or parse not possible
  int toInt(String str) {
    str = str?.trim();
    if (str != null) return int.tryParse(str);
    return null;
  }
}

///TEST: at widget level
class TextHelpers {
  // use with onChanged to keep cursor at end of text
  static void placeCursorAtEndOfText(
      String value, TextEditingController controller) {
    controller
      ..text = value
      ..selection = TextSelection.collapsed(offset: controller.text.length);
    return;
  }

  static RegExp namesRegExp() {
    return RegExp(
        r'[0-9"&(§!)°_$*€^¨%£`\/\\;\.,?@#<>≤=+≠÷…∞}ø¡«¶{‘“•®†ºµ¬ﬁ‡‹≈©◊~|´„”\[»\]™ª∏¥‰≥›√ı¿±:]+');
  }

  static RegExp numbersAndLetters() {
    return RegExp(r'[a-z0-9]*/gi');
  }

  static RegExp letters() {
    return RegExp(r'[a-z]*/gi');
  }

  static RegExp numbers() {
    return RegExp(r'[0-9]*');
  }

  static List<String> nameParticles() {
    List<String> list = [
      //french
      "de",
      "du",
      "des",
      "d’",
      //spanish
      "del",
      "la",
      "los",
      "las",
      "y",
      //portuguese
      "a",
      "da",
      "das",
      "do",
      "dos",
      //dutch
      "den",
      "op",
      "t’",
      "’t",
      "ten",
      "ter",
      "te",
      "van",
      "vanden",
      "den",
      "vander",
      //german
      "von",
      "aus",
      "der",
      "am",
      "an",
      "auf",
      "im",
      "zu",
      "zum",
      "zur",
      //english
      "of",
      //scandinavian languages
      "af",
      "av",
    ];
    return list;
  }
}
