import 'package:flutter/material.dart';

Widget input(
        {String label,
        String type,
        Function onSaved,
        Function onError,
        String initialValue}) =>
    Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
      child: TextFormField(
        keyboardType: TextInputType.text,
        onChanged: (value) => null,
        initialValue: initialValue == null ? '' : initialValue,
        focusNode: FocusNode(skipTraversal: true),
        maxLines: type == 'clue' ? 5 : null,
        onTap: () => null,
        onSaved: onSaved,
        validator: onError,
        decoration: InputDecoration(
          alignLabelWithHint: true,
          labelText: label,
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1.0),
          ),
        ),
      ),
    );
