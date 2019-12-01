import 'package:flutter/material.dart';
import 'package:preset_form_fields/preset_form_fields.dart';
import 'package:preset_form_fields/src/validate.dart';

class Custom {
  // Allow users to use built-in validator with custom messages and format(EUR vs US)
  static Function dateValidator(DateFormat dateFormat,
      {@required String dateNotInRangeErrorMsg,
      @required String dateErrorMsg}) {
    String customDateValidator(String value) {
      String formattedForParsing = Validate.toIsoString(value, dateFormat);
      if (formattedForParsing == null) return dateErrorMsg;
      String dateAndMonthValuesInRange =
          Validate.checkDateStringFormatting(formattedForParsing);
      if (dateAndMonthValuesInRange == null) return dateNotInRangeErrorMsg;
      DateTime date = Validate.toDate(dateAndMonthValuesInRange);
      if (date != null) return null;

      return dateErrorMsg;
    }

    return customDateValidator;
  }
}
