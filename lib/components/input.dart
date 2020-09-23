import 'package:flutter/material.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';

part 'input.g.dart';

@swidget
Widget input(BuildContext context,
        {String label, Function onSaved, Function onError}) =>
    Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: TextFormField(
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
