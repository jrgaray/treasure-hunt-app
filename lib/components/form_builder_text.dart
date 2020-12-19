import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class FormBuilderText extends StatelessWidget {
  const FormBuilderText({Key key, this.attribute, this.label})
      : super(key: key);
  final String label;
  final String attribute;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: FormBuilderTextField(
        autovalidateMode: AutovalidateMode.always,
        name: attribute,
        keyboardType: TextInputType.text,
        focusNode: FocusNode(skipTraversal: true),
        onTap: () => null,
        validator: (String value) {
          if (value.isEmpty) {
            return 'Field cannot be empty';
          }
        },
        // onSaved: onSaved,
        decoration: InputDecoration(
          alignLabelWithHint: true,
          labelText: label,
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1.0),
          ),
        ),
      ),
    );
  }
}
