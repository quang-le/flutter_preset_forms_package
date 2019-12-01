import 'package:preset_form_fields/src/field.dart';
import 'package:preset_form_fields/src/utils/helpers.dart';
import 'package:preset_form_fields/src/utils/sanitize.dart';
import 'package:preset_form_fields/src/validate.dart';
import 'package:flutter/material.dart';

class Generate {
  static Function onChanged(TextEditingController controller,
      [Function onChanged(String value)]) {
    void change(String value) {
      if (onChanged != null) onChanged(value);
      TextHelpers.placeCursorAtEndOfText(value, controller);
    }

    return change;
  }

  static Function onSaved(TextEditingController controller,
      [Function customOnSaved(String value)]) {
    void save(String value) {
      String sanitizedValue = Sanitize.htmlChars(value);
      customOnSaved(sanitizedValue);
    }

    return save;
  }

  static Function onSavedDate(
      TextEditingController controller, DateFormat dateFormat,
      [Function customOnSaved(String value)]) {
    void save(String value) {
      String toIsoString = Validate.toIsoString(value, dateFormat);
      customOnSaved(toIsoString);
    }

    return save;
  }
}
