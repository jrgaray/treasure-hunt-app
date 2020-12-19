import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:treasure_hunt/components/form_builder_text.dart';

class CreateAccountForm extends HookWidget {
  const CreateAccountForm({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasFile = useState(false);
    final key = GlobalKey<FormBuilderState>();
    ValueNotifier<PickedFile> imageFile = useState(null);

    return FormBuilder(
      key: key,
      child: Column(
        children: [
          GestureDetector(
            onTap: () async {
              if (!hasFile.value) {
                imageFile.value =
                    await ImagePicker().getImage(source: ImageSource.camera);
                if (imageFile.value != null) hasFile.value = true;
              } else {
                imageFile.value = null;
                hasFile.value = false;
              }
            },
            child: Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                        height: 200,
                        width: 200,
                        color: Colors.grey,
                        child: hasFile.value
                            ? Image.file(
                                File(imageFile.value.path),
                                fit: BoxFit.fitWidth,
                              )
                            : Icon(Icons.add_a_photo)),
                  ),
                  Visibility(
                    visible: hasFile.value,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: Container(
                          height: 40, width: 40, child: Icon(Icons.cancel)),
                    ),
                  )
                ],
              ),
            ),
          ),
          FormBuilderText(attribute: 'first_name', label: "First Name"),
          FormBuilderText(attribute: 'last_name', label: "Last Name"),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: FormBuilderDateTimePicker(
              validator: (DateTime value) {
                if (value == null) {
                  return "Cannot be empty";
                }
                if (value.isBefore(new DateTime(1900))) {
                  return 'Must be after 1990';
                }
                if (value.isAfter(DateTime.now())) {
                  return "Cannot be a future date";
                }
                return null;
              },
              name: 'birthday',
              inputType: InputType.date,
              decoration: InputDecoration(
                alignLabelWithHint: true,
                labelText: "Birthday",
                border: OutlineInputBorder(
                  borderSide: BorderSide(width: 1.0),
                ),
              ),
            ),
          ),
          FormBuilderText(attribute: 'email', label: "Email"),
          FormBuilderText(attribute: 'password', label: "Password"),
          RaisedButton(
            onPressed: () {
              print(key.currentState.validate());
            },
            child: Text("Submit"),
          )
        ],
      ),
    );
  }
}
