import 'package:flutter_test/flutter_test.dart';
import 'package:preset_form_fields/preset_form_fields.dart';
import 'package:preset_form_fields/src/validate.dart';

void main() {
  group("validate email string", () {
    test("email with valid input", () {
      bool classicAddress = Validate.isValidEmail('developer@company.com');
      bool usernameWithDot = Validate.isValidEmail('dev.flutter@company.com');
      bool domainNameWithDot = Validate.isValidEmail('dev@start.up.com');
      bool longTld = Validate.isValidEmail('dev@flutter.ninja');
      bool randomCapitalLetters =
          Validate.isValidEmail('deV.Flutter@ComPanNY.coM');
      bool numbers = Validate.isValidEmail('dev1@company2.com');
      // should this return true?
      bool accentsAndUmlauts = Validate.isValidEmail('dév@cömpany.ùñiquè.com');
      List<bool> result = [
        classicAddress,
        usernameWithDot,
        domainNameWithDot,
        longTld,
        randomCapitalLetters,
        numbers,
        accentsAndUmlauts
      ];
      expect(result, [true, true, true, true, true, true, true]);
    });

    test("email with invalid input", () {
      bool missingAt = Validate.isValidEmail('devflutter');
      bool missingTld = Validate.isValidEmail('dev@company');
      bool missingTldWithDot = Validate.isValidEmail('dev@company.');
      bool invalidCharacters = Validate.isValidEmail(
          'dev&!+()[]{}|=/:;,\$?*``><#@#/.:;?,*\$)(~~=+}{[]!&');

      bool twoAt = Validate.isValidEmail('dev@company@flutter.com');
      bool justNumbers = Validate.isValidEmail('12347809978');
      List<bool> result = [
        missingAt,
        missingTld,
        missingTldWithDot,
        invalidCharacters,
        twoAt,
        justNumbers
      ];
      expect(result, [false, false, false, false, false, false]);
    });
  });

  group('Date validation', () {
    String eurDate = '09/11/1989';
    String usDate = '11/09/1989';
    String wrongValueDateEur = '32/14/4500';
    String wrongValueDateUs = '14/32/4500';
    String tooLongUs = '11/09/19899';
    String tooLongEur = '09/11/198999';
    String tooShortUs = '11/09';
    String tooShortEur = '09/11';
    String randomChars = '&é/:;?%@#<';
    String letters = 'is this OK';
    String numbers = '1234567890';
    String wrongFormat = '09/111/989';
    String correctIsoString = '1989-11-09 00:00:00Z';
    String wrongValueDateIsoString = '4500-14-32 00:00:00Z';
    String randomIsoString = '&é:;-?%-#< 00:00:00Z';
    String lettersIsoString = 's OK-th-is 00:00:00Z';
    String leapYearIsoString = '2000-02-29 00:00:00Z';
    String feb29IsoString = '2001-02-29 00:00:00Z';
    String feb30LeapIsoString = '2000-02-30 00:00:00Z';
    String april31IsoString = '2001-04-31 00:00:00Z';

    test(': convert user input to ISO string', () {
      List<String> result = [];
      result.add(Validate.toIsoString(eurDate, DateFormat.eur));
      result.add(Validate.toIsoString(usDate, DateFormat.us));
      result.add(Validate.toIsoString(wrongValueDateEur, DateFormat.eur));
      result.add(Validate.toIsoString(wrongValueDateUs, DateFormat.us));

      expect(result, [
        correctIsoString,
        correctIsoString,
        wrongValueDateIsoString,
        wrongValueDateIsoString
      ]);
    });
    test(': ISO String conversion returns null on incorrect input length', () {
      List<String> result = [];
      result.add(Validate.toIsoString(tooLongUs, DateFormat.us));
      result.add(Validate.toIsoString(tooLongEur, DateFormat.eur));
      result.add(Validate.toIsoString(tooShortUs, DateFormat.us));
      result.add(Validate.toIsoString(tooShortEur, DateFormat.eur));

      expect(result, [null, null, null, null]);
    });
    test(': return string if input length = 10, regardless of input', () {
      List<bool> result = [];
      result.add(Validate.toIsoString(randomChars, DateFormat.us) is String);
      result.add(Validate.toIsoString(letters, DateFormat.us) is String);
      result.add(Validate.toIsoString(numbers, DateFormat.us) is String);
      result.add(Validate.toIsoString(wrongFormat, DateFormat.us) is String);
      expect(result, [true, true, true, true]);
    });
    test(': check ISO string date is a real date', () {
      List<String> result = [];
      result.add(Validate.checkDateStringFormatting(correctIsoString));
      result.add(Validate.checkDateStringFormatting(leapYearIsoString));
      result.add(Validate.checkDateStringFormatting(wrongValueDateIsoString));
      result.add(Validate.checkDateStringFormatting(randomIsoString));
      result.add(Validate.checkDateStringFormatting(lettersIsoString));
      result.add(Validate.checkDateStringFormatting(feb29IsoString));
      result.add(Validate.checkDateStringFormatting(feb30LeapIsoString));
      result.add(Validate.checkDateStringFormatting(april31IsoString));

      expect(result, [
        correctIsoString,
        leapYearIsoString,
        null,
        null,
        null,
        null,
        null,
        null
      ]);
    });
    test(': parse ISO string to DateTime object', () {
      ///DO WE NEED THIS TEST? SUCCESS CONDITIONS ARE THE SAME AS
      ///ISO STRING CONVERSION

      //DateTime.parse doesn't check the validity of the date
      //just the correct formatting of the string
      List result = [];
      result.add(Validate.toDate(correctIsoString) is DateTime);
      result.add(Validate.toDate(leapYearIsoString) is DateTime);
      result.add(Validate.toDate(feb29IsoString) is DateTime);
      result.add(Validate.toDate(feb30LeapIsoString) is DateTime);
      result.add(Validate.toDate(april31IsoString) is DateTime);
      result.add(Validate.toDate(wrongValueDateIsoString) is DateTime);
      result.add(Validate.toDate(randomIsoString) is DateTime);
      result.add(Validate.toDate(lettersIsoString) is DateTime);
      expect(result, [true, true, true, true, true, true, false, false]);
    });
    test(': validator', () {
      List<String> result = [];
      result.add(Validate.date(DateFormat.eur)(eurDate));
      result.add(Validate.date(DateFormat.us)(usDate));
      result.add(Validate.date(DateFormat.eur)('29/02/2000'));
      result.add(Validate.date(DateFormat.eur)(wrongValueDateEur));
      result.add(Validate.date(DateFormat.us)(wrongValueDateUs));
      result.add(Validate.date(DateFormat.eur)(tooShortEur));
      result.add(Validate.date(DateFormat.us)(tooShortUs));
      result.add(Validate.date(DateFormat.eur)(wrongFormat));
      result.add(Validate.date(DateFormat.eur)(letters));
      result.add(Validate.date(DateFormat.eur)(numbers));
      result.add(Validate.date(DateFormat.eur)(randomChars));
      result.add(Validate.date(DateFormat.eur)('30/02/2000'));
      result.add(Validate.date(DateFormat.eur)('29/02/2001'));
      expect(result, [
        null,
        null,
        null,
        'Date not in range',
        'Date not in range',
        'Formatting Error',
        'Formatting Error',
        'Date not in range',
        'Date not in range',
        'Date not in range',
        'Date not in range',
        'Date not in range',
        'Date not in range',
      ]);
    });
  });
}
