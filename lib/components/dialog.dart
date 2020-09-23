import 'dart:core';
import 'package:flutter/material.dart';
import 'dart:async';

Future<void> dialog(context, {List<Widget> dialogOptions, String title}) async {
  switch (await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(title),
          children: dialogOptions,
        );
      })) {
    default:
      break;
  }
}
