import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:treasure_hunt/components/create_account_form.dart';

class CreateAccountScreen extends HookWidget {
  static const routeName = "createAccount";
  const CreateAccountScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text("Create Account"),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text("Let's get you an account",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            ),
            CreateAccountForm()
          ],
        ),
      ),
    );
  }
}
