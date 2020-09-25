import 'package:flutter/material.dart';
// import 'package:functional_widget_annotation/functional_widget_annotation.dart';

// part 'input.g.dart';

// @swidget
Widget input(
        {String label,
        Function onSaved,
        Function onError,
        String initialValue}) =>
    Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: TextFormField(
        keyboardType: TextInputType.text,
        onChanged: (value) => null,
        initialValue: initialValue == null ? '' : initialValue,
        focusNode: FocusNode(skipTraversal: true),
        onTap: () => null,
        onSaved: onSaved,
        validator: onError,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1.0),
          ),
        ),
      ),
    );
