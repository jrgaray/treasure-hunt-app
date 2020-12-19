import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:treasure_hunt/components/input.dart';
import 'package:treasure_hunt/screens/create_account_screen.dart';
import 'package:treasure_hunt/screens/root.dart';
import 'package:treasure_hunt/state/user_state.dart';
import 'package:treasure_hunt/utils/form_key.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class Login extends HookWidget {
  Login({this.title});
  static const routeName = '/';
  static const String welcomeText = 'Findr';
  final String title;

  @override
  Widget build(BuildContext context) {
    Widget header = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 70),
            child: Text(
              Login.welcomeText,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );

    Widget form = Row(
      children: [
        Expanded(
          child: FormBuilder(
            key: key,
            child: Column(
              children: [
                input(
                  label: 'Username',
                  onSaved: (value) {
                    //
                  },
                  onError: (value) => value.isEmpty ? 'Cannot be empty.' : null,
                ),
                input(
                  label: 'Password',
                  onSaved: (value) =>
                      context.read<UserState>().setPassword(value),
                  onError: (value) => value.isEmpty ? 'Cannot be empty.' : null,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: RaisedButton(
                    onPressed: () {
                      if (key.currentState.validate()) {
                        key.currentState.save();
                        Navigator.popAndPushNamed(
                            context, RootScreen.routeName);
                      }
                    },
                    child: Text('Submit'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: InkWell(
                    radius: 100,
                    highlightColor: Colors.blue,
                    onTap: () {
                      Navigator.pushNamed(
                          context, CreateAccountScreen.routeName);
                    },
                    child: Container(
                      height: 40,
                      width: 200,
                      alignment: Alignment.center,
                      child: Text("Create Account"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              header,
              form,
            ],
          ),
        ),
      ),
    );
  }
}
