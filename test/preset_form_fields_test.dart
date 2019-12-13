import 'package:flutter_test/flutter_test.dart';
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
      List<bool> result = [
        classicAddress,
        usernameWithDot,
        domainNameWithDot,
        longTld,
        randomCapitalLetters,
        numbers
      ];
      expect(result, [true, true, true, true, true, true]);
    });

    test("email with invalid input", () {
      bool missingAt = Validate.isValidEmail('devflutter');
      bool missingTld = Validate.isValidEmail('dev@company');
      bool missingTldWithDot = Validate.isValidEmail('dev@company.');
      bool invalidCharacters = Validate.isValidEmail(
          'dev&!+()[]{}|=/:;,\$?*``><#@#/.:;?,*\$)(~~=+}{[]!&');
      // should this return true?
      bool accentsAndUmlauts = Validate.isValidEmail('dév@cömpany.ùñiquè.com');
      bool twoAt = Validate.isValidEmail('dev@company@flutter.com');
      bool justNumbers = Validate.isValidEmail('12347809978');
      List<bool> result = [
        missingAt,
        missingTld,
        missingTldWithDot,
        invalidCharacters,
        accentsAndUmlauts,
        twoAt,
        justNumbers
      ];
      expect(result, [false, false, false, false, false, false, false]);
    });
  });
}
