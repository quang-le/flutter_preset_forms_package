import 'dart:async';
import 'dart:convert';
import 'package:preset_form_fields/src/field.dart';
import 'package:preset_form_fields/src/validate.dart';
import 'package:preset_form_fields/src/country/country.dart';
import 'package:preset_form_fields/src/phone_number/phone_service.dart';
import 'package:flutter/material.dart';
import 'package:preset_form_fields/src/utils/custom_dropdown.dart' as custom;

class PhoneFormField extends StatefulWidget {
  final Function(String phoneNumber) onSaved;
  final String initialPhoneNumber;
  final String initialSelection;
  final String errorText;
  final String hintText;
  final TextStyle errorStyle;
  final TextStyle hintStyle;
  final int errorMaxLines;
  final double dropDownListHeight;

  PhoneFormField(
      {this.initialPhoneNumber,
      this.onSaved,
      this.initialSelection,
      this.errorText,
      this.hintText,
      this.errorStyle,
      this.hintStyle,
      this.errorMaxLines,
      this.dropDownListHeight = 250.0});

  // this func for test purposes
  static Future<String> internationalizeNumber(String number, String iso) {
    return PhoneService.getNormalizedPhoneNumber(number, iso);
  }

  @override
  _PhoneFormFieldState createState() => _PhoneFormFieldState();
}

class _PhoneFormFieldState extends State<PhoneFormField> {
  Country selectedItem;
  List<Country> itemList = [];

  String errorText;
  String hintText;

  TextStyle errorStyle;
  TextStyle hintStyle;

  int errorMaxLines;

  bool hasError = false;

  _PhoneFormFieldState();

  final phoneTextController = TextEditingController();

  @override
  void initState() {
    phoneTextController.text = widget.initialPhoneNumber;

    _fetchCountryData().then((list) {
      Country preSelectedItem;

      // TODO enforce input type of selected country
      if (widget.initialSelection != null) {
        preSelectedItem = list.firstWhere(
            (e) =>
                (e.code.toUpperCase() ==
                    widget.initialSelection.toUpperCase()) ||
                (e.dialCode == widget.initialSelection.toString()),
            orElse: () => list[0]);
      } else {
        preSelectedItem = list[0];
      }
      setState(() {
        itemList = list;
        selectedItem = preSelectedItem;
      });
    });
    super.initState();
  }

  Future<List<Country>> _fetchCountryData() async {
    var list = await DefaultAssetBundle.of(context)
        .loadString('packages/preset_form_fields/assets/countries.json');
    var jsonList = json.decode(list);
    List<Country> elements = [];
    jsonList.forEach((s) {
      Map elem = Map.from(s);
      elements.add(Country(
          name: elem['en_short_name'],
          code: elem['alpha_2_code'],
          dialCode: elem['dial_code'],
          flagUri:
              'packages/preset_form_fields/assets/flags/${elem['alpha_2_code'].toLowerCase()}.png'));
    });
    return elements;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: ButtonTheme(
              alignedDropdown: true,
              child: custom.DropdownButtonFormField<Country>(
                height: widget.dropDownListHeight,
                value: selectedItem,
                onChanged: (Country newValue) {
                  setState(() {
                    selectedItem = newValue;
                  });
                },
                items: itemList
                    .map<custom.DropdownMenuItem<Country>>((Country value) {
                  return custom.DropdownMenuItem<Country>(
                    value: value,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Image(
                              image: AssetImage(
                                value.flagUri,
                              ),
                              //TODO Adjust height dynamically
                              width: 25.0,
                              height: 15.0),
                          SizedBox(width: 15),
                          Text(value.dialCode)
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Field.phone(
              controller: phoneTextController,
              decoration: InputDecoration(
                labelText: 'Phone',
                hintText: widget.hintText ?? 'ex: 47512345',
                //errorText: hasError ? errorText : null,
                hintStyle: widget.hintStyle,
                errorStyle: widget.errorStyle,
                errorMaxLines: widget.errorMaxLines ?? 3,
              ),
              validator: Validate.makePhoneValidator(selectedItem?.code,
                  widget.errorText ?? 'invalid phone number'),
              onSaved: (value) {
                String valueToSave = selectedItem.dialCode + value;
                widget.onSaved(valueToSave);
              },
            ),
          )
        ],
      ),
    );
  }
}
