import 'package:flutter/material.dart';
import 'dart:async';

class InputField extends StatefulWidget {
  InputField({Key key, this.label, this.onChanged, this.validator}) : super(key: key);

  final String label;
  final void Function(String) onChanged;
  final String Function(String) validator;

  @override
  _InputFieldState createState() => _InputFieldState(
    label: label);
}

class _InputFieldState extends State<InputField> {

  String label;
  final TextEditingController controller = TextEditingController();

  _InputFieldState({
    this.label
  });

  void onChange() {
    String text = controller.text;
    widget.onChanged(text);
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(onChange);
  }

  @override
  void dispose() {
    controller.removeListener(onChange);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (s) {
        if (widget.validator != null) {
          return widget.validator(s);
        }

        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: controller.text.isEmpty ? null : 
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () async {
            await Future.delayed(Duration(milliseconds: 10));
            setState(() {
             controller.text = ''; 
            });
          },
        ),
        errorStyle: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}