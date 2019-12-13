import 'package:flutter/material.dart';
import 'package:preset_form_fields_example/forms/full_form.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'test examples',
      home: Scaffold(
        body: SafeArea(child: FullForm()),
      ),
    );
  }
}
