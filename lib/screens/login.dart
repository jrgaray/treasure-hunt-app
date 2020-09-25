import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:treasure_hunt/components/input.dart';
import 'package:treasure_hunt/screens/root.dart';
import 'package:treasure_hunt/state/user_state.dart';
import 'package:treasure_hunt/utils/form_key.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class Login extends HookWidget {
  Login({this.title});
  static const routeName = '/';
  static const String welcomeText = 'Welcome to Treasure Hunt';
  final String title;

  @override
  Widget build(BuildContext context) {
    Widget header = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            Login.welcomeText,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 40.0),
          ),
        ),
      ],
    );

    Widget form = Row(
      children: [
        Expanded(
          child: FormBuilder(
            key: key,
            // autovalidate: true,
            child: Column(
              children: [
                input(
                  label: 'Username',
                  onSaved: (value) {
                    context.read<UserState>().setUsername(value);
                  },
                  onError: (value) => value.isEmpty ? 'Cannot be empty.' : null,
                ),
                input(
                  label: 'Password',
                  onSaved: (value) =>
                      context.read<UserState>().setPassword(value),
                  onError: (value) => value.isEmpty ? 'Cannot be empty.' : null,
                ),
                RaisedButton(
                  onPressed: () {
                    if (key.currentState.validate()) {
                      key.currentState.save();
                      Navigator.popAndPushNamed(context, RootScreen.routeName);
                    }
                  },
                  child: Text('Submit'),
                )
              ],
            ),
          ),
        )
      ],
    );

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            header,
            form,
          ],
        ),
      ),
    );
  }
}
