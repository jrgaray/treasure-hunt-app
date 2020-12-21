import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:treasure_hunt/firebase/auth.dart';

class SubmitButton extends HookWidget {
  const SubmitButton({Key key, this.formKey}) : super(key: key);
  final GlobalKey<FormBuilderState> formKey;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () async {
        try {
          if (formKey.currentState.validate()) {
            final fields = formKey.currentState.fields;
            await signIn(fields["email"].value, fields["password"].value);
          }
        } catch (error) {
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text(error.message)));
        }
      },
      child: Text('Submit'),
    );
  }
}
