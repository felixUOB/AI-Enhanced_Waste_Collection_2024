import 'package:ewc/theme/theme_constants.dart';
import 'package:flutter/material.dart';

/// This file manages the login textfield widget.
///
/// Functions:
/// - `build()`: Builds the login textfield component.

class EmailTextfield extends StatelessWidget {
  final dynamic controller;
  final String hintText;

  // ignore: prefer_const_constructors_in_immutables
  EmailTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    // required dynamic key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Theme(
        data: ThemeData.light(),
        child: TextFormField(
            // check that it is a valid email

            validator: (value) {
              // checks that the email is in the correct form i.e. [any characters]@[any chacters].[any characters]
              // [a-z0-9!#$%&'*+/=?^_`{|}~-]+ -> matches the part before the @
              // (?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)* -> allows dot-separated part before the @ e.g. k.p@
              // @ -> matches the @
              // (?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+ -> ensures the domain starts with an alphanumerical character and ends with a dot e.g. iCloud.
              // [a-z0-9](?:[a-z0-9-]*[a-z0-9])? -> ensures it starts with an alphanumerical character, matches the final part of the domain e.g. .com
              final bool emailValid = 
                RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                  .hasMatch(value.toString());
              if (value == null || value.isEmpty){
                return 'Please enter some text';
              } else if (!emailValid){
                return 'Please enter a valid email';
              }
              return null;
            },
            controller: controller,
            decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
              fillColor: const Color.fromARGB(250, 240, 240, 240),
              filled: true,
              hintText: hintText,
              hintStyle: AppTheme().hiddenTextStyleMedium,
            )),
      ),
    );
  }
}
