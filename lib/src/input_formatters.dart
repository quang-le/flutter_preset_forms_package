import 'package:preset_form_fields/src/utils/sanitize.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// TODO note in README how to handle belgian vs dutch tussenvoegsels and other ambiguous words
class NameInputFormatter extends TextInputFormatter {
  final List<String> keepLowerCase;

  NameInputFormatter({
    this.keepLowerCase = const [],
  }) {
    exceptions = _partialParticleMatches(keepLowerCase);
  }

  List<String> exceptions;

  List<String> _partialParticleMatches(List<String> keepLowerCase) {
    List<String> partialMatches = [];

    keepLowerCase.forEach((particle) {
      List<String> particleSubstrings = _generateParticleSubstrings(particle);
      partialMatches.addAll(particleSubstrings);
    });
    return partialMatches;
  }

  List<String> _generateParticleSubstrings(String particle) {
    List<String> particleSubstrings = [];
    List<String> particleLetters = particle.split('');
    for (int i = particleLetters.length; i >= 1; i--) {
      String substring = particleLetters.sublist(0, i).join();
      particleSubstrings.add(substring);
    }
    return particleSubstrings;
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

  static String firstLetterToUpperCase(String input) {
    if (input == null || input.length == 0) return input;
    String firstLetter = input[0].toUpperCase();
    String upperCaseFirstLetter = input.replaceRange(0, 1, firstLetter);
    return upperCaseFirstLetter;
  }

  @override
  //TODO make authorize special char programmable via authorized list

  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String input = newValue.text.trimLeft();

    if (input.length == 0) return TextEditingValue(text: input);

    if (!input.contains(' ') &&
        !input.contains('-') &&
        !input.contains("’") &&
        !exceptions.contains(input)) {
      String upperCaseFirstLetter = firstLetterToUpperCase(input);
      return TextEditingValue(text: upperCaseFirstLetter);
    }

    // TODO pass char list i.o hard code chars
    String formattedName = input;
    if (input.contains('-'))
      formattedName =
          uppercaseAfterSpecialChar(formattedName, '-', exceptions: exceptions);
    if (input.contains("’"))
      formattedName =
          uppercaseAfterSpecialChar(formattedName, "’", exceptions: exceptions);
    if (input.contains(' '))
      formattedName =
          uppercaseAfterSpecialChar(formattedName, ' ', exceptions: exceptions);
    return TextEditingValue(text: formattedName);
  }
}

class EmailInputFormatter extends TextInputFormatter with Sanitize {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String trimmed = newValue.text.trim();
    String sanitized = htmlCharsDelete(trimmed);
    return TextEditingValue(text: sanitized);
  }
}

// To be used with TextFormField's inputFormatters field
//use 'eur or us to differentiate date formats'
class DateInputFormatter extends TextInputFormatter {
  final String format;
  DateInputFormatter({this.format = 'eur'});
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    List<String> chars = newValue.text.split('');
    List<String> filteredChars =
        chars.where((char) => (int.tryParse(char) != null)).toList();

    // keep slashes if placed at the right position
    if (chars.length == 3) if (chars.elementAt(2) == '/') {
      filteredChars.insert(2, '/');
    }
    if (chars.length == 6) if (chars.elementAt(2) == '/' &&
        chars.elementAt(5) == '/') {
      filteredChars.insert(2, '/');
      filteredChars.insert(5, '/');
    }

    int length = filteredChars.length;
    if (length < 3) {
      return TextEditingValue(text: filteredChars.join());
    } else if (length >= 3 && length < 5) {
      if (filteredChars[2] != '/' && filteredChars.length > 2)
        filteredChars.insert(2, '/');
      return TextEditingValue(text: filteredChars.join());
    } else if (length >= 5) {
      if (filteredChars[2] != '/') filteredChars.insert(2, '/');
      if (filteredChars[5] != '/' && filteredChars.length > 5)
        filteredChars.insert(5, '/');
      if (filteredChars.length > 10) {
        filteredChars = filteredChars.take(10).toList();
      }
      return TextEditingValue(text: filteredChars.join());
    }
    return null;
  }
}

class CountryInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String input = newValue.text.trimLeft();

    if (input.length == 0) return TextEditingValue(text: input);

    if (!input.contains(' ')) {
      String upperCaseFirstLetter =
          NameInputFormatter.firstLetterToUpperCase(input);
      return TextEditingValue(text: upperCaseFirstLetter);
    }

    String formattedName = input;
    if (input.contains(' '))
      formattedName =
          NameInputFormatter.uppercaseAfterSpecialChar(formattedName, ' ');
    return TextEditingValue(text: formattedName);
  }
}
