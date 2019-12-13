import 'package:flutter/material.dart';
import 'package:preset_form_fields/preset_form_fields.dart';

class FullForm extends StatefulWidget {
  @override
  _FullFormState createState() => _FullFormState();
}

class _FullFormState extends State<FullForm> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // Use Form to validate several fields at once
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Field.firstName(
            decoration: InputDecoration(labelText: 'First Name'),
            controller: TextEditingController(),
            onSaved: (value) {
              print(value);
            },
          ),
          Field.lastName(
            decoration: InputDecoration(labelText: 'Last Name'),
            controller: TextEditingController(),
            onSaved: (value) {
              print(value);
            },
          ),
          Field.email(
            decoration: InputDecoration(labelText: 'Email'),
            controller: TextEditingController(),
            onSaved: (value) {
              print(value);
            },
            onChanged: (value) {
              print(value);
            },
          ),
          Field.companyName(
            controller: TextEditingController(),
            decoration: InputDecoration(labelText: 'Company'),
            onSaved: (value) {
              print(value);
            },
          ),
          Field.date(
            decoration: InputDecoration(labelText: 'Date of birth'),
            controller: TextEditingController(),
            onSaved: (value) {
              print(value);
            },
          ),
          PhoneFormField(
            onSaved: (value) {
              print(value);
            },
          ),
          RaisedButton(
            child: Text('Submit'),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                print('form is valid');
                _formKey.currentState.save();
              }
            },
          )
        ],
      ),
    );
  }
}
