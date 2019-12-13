import 'package:preset_form_fields/src/utils/helpers.dart';
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

  NameInputFormatterHelpers helpers;
  List<String> exceptions;

  final _partialParticleMatches =
      NameInputFormatterHelpers.partialParticleMatches;

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
      String upperCaseFirstLetter =
          FormatterHelpers.firstLetterToUpperCase(input);
      return TextEditingValue(text: upperCaseFirstLetter);
    }

    // TODO pass char list i.o hard code chars
    String formattedName = input;
    if (input.contains('-'))
      formattedName = FormatterHelpers.uppercaseAfterSpecialChar(
          formattedName, '-',
          exceptions: exceptions);
    if (input.contains("’"))
      formattedName = FormatterHelpers.uppercaseAfterSpecialChar(
          formattedName, "’",
          exceptions: exceptions);
    if (input.contains(' '))
      formattedName = FormatterHelpers.uppercaseAfterSpecialChar(
          formattedName, ' ',
          exceptions: exceptions);
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
          FormatterHelpers.firstLetterToUpperCase(input);
      return TextEditingValue(text: upperCaseFirstLetter);
    }

    String formattedName = input;
    if (input.contains(' '))
      formattedName =
          FormatterHelpers.uppercaseAfterSpecialChar(formattedName, ' ');
    return TextEditingValue(text: formattedName);
  }
}
