import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:treasure_hunt/components/form_builder_text.dart';
import 'package:treasure_hunt/components/submit_button.dart';
import 'package:treasure_hunt/firebase/auth.dart';
import 'package:treasure_hunt/screens/create_account_screen.dart';
import 'package:treasure_hunt/screens/root.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class Login extends HookWidget {
  Login({this.title});
  static const routeName = '/';
  static const String welcomeText = 'Findr';
  final String title;

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User>();
    final key = GlobalKey<FormBuilderState>();
    useEffect(() {
      if (user != null)
        Future.microtask(() {
          Navigator.popUntil(context, ModalRoute.withName(routeName));
          Navigator.popAndPushNamed(context, RootScreen.routeName);
        });
      return;
    }, [user]);
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
                FormBuilderText(attribute: "email", label: "Email"),
                FormBuilderText(attribute: "password", label: "Password"),
                Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: SubmitButton(
                      formKey: key,
                    )),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: InkWell(
                    radius: 100,
                    highlightColor: Colors.blue,
                    onTap: () async {
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
    final Widget loading = Center(child: Text("Loading"));
    final Widget main = SingleChildScrollView(
      child: Column(
        children: [
          header,
          form,
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(),
      body: Container(child: auth.currentUser != null ? loading : main),
    );
  }
}
