import 'package:preset_form_fields/src/phone_number/phone_service.dart';
import 'package:preset_form_fields/src/field.dart';

class Validate {
  static bool isValidEmail(String str) {
    RegExp _email = RegExp(
        r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$");
    return _email.hasMatch(str.toLowerCase());
  }

  // format string to use with DateTime.parse. default is dd/mm/yyyy
  static String toIsoString(String str, DateFormat format) {
    if (str.length != 10) return null;
    String dateString;
    if (format == DateFormat.us) {
      dateString = '${str[6]}'
          '${str[7]}'
          '${str[8]}'
          '${str[9]}-'
          '${str[0]}'
          '${str[1]}-'
          '${str[3]}'
          '${str[4]} '
          '00:00:00Z';
    } else {
      dateString = '${str[6]}'
          '${str[7]}'
          '${str[8]}'
          '${str[9]}-'
          '${str[3]}'
          '${str[4]}-'
          '${str[0]}'
          '${str[1]} '
          '00:00:00Z';
    }
    return dateString;
  }

  // takes a YYYY-MM-DD 00:00:00Z string and checks for the day and month values
  static String checkDateStringFormatting(String str) {
    if (str == null) return null;
    String dayString = str.substring(8, 10),
        monthString = str.substring(5, 7),
        yearString = str.substring(0, 4);
    int day = int.tryParse(dayString), month = int.tryParse(monthString);
    double year = double.tryParse(yearString);

    if (day == null || month == null || year == null) return null;
    if (day > 31) return null;
    if (month > 12) return null;
    if (year % 4 == 0 && month == 2 && day > 29) return null;
    if (year % 4 != 0 && month == 2 && day > 28) return null;
    if (day > 30 && (month == 4 || month == 6 || month == 9 || month == 11))
      return null;
    return str;
  }

  // check if string is parsable then DateTime.parse.
  static DateTime toDate(String str) {
    DateTime date;
    try {
      date = DateTime.parse(str);
    } catch (e) {
      print('error parsing date: $e');
      return null;
    }
    return date;
  }

  static Function date(DateFormat dateFormat) {
    String validator(String value) {
      String formattedForParsing = Validate.toIsoString(value, dateFormat);
      if (formattedForParsing == null)
        return "Can't convert date to ISO String";
      String dateAndMonthValuesInRange =
          Validate.checkDateStringFormatting(formattedForParsing);
      if (dateAndMonthValuesInRange == null)
        return 'Incorrect day or month value';
      DateTime date = Validate.toDate(dateAndMonthValuesInRange);
      if (date != null) return null;
      if (dateFormat == DateFormat.us) return 'Please use mm/dd/yyyy format';
      return 'Please use dd/mm/yyyy format';
    }

    return validator;
  }

  static String name(String value) {
    if (value == null || value == '') return 'Please enter name';
    if (value[0] == '-') return 'Please enter valid name';
    if (value.length < 2) return 'Please enter valid name';
    return null;
  }

  static String email(String value) {
    bool isValid = isValidEmail(value);
    if (isValid) return null;
    return 'please enter valid email';
  }

  static String zipCode(String value) {
    if (int.tryParse(value) != null) return value;
    return 'please use digits only';
  }

  static Function makePhoneValidator(String countryCode, String errorMsg) {
    Future<String> phoneValidator(String value) async {
      bool isValid = await PhoneService.parsePhoneNumber(value, countryCode);
      print("received async data");
      if (!isValid) return errorMsg;
      print("valid number");
      return null;
    }

    return phoneValidator;
  }
}
