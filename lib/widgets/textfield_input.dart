import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  const TextFieldInput({Key? key, required this.textInputType, required this.textEditingController, this.isPass = false,required this.hintText }) : super(key: key);
  final isPass;
  final TextEditingController textEditingController;
  final String hintText;
  final TextInputType textInputType;

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
        borderSide: Divider.createBorderSide(context)
    );
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4)
        ),
        enabledBorder: inputBorder,
        focusedBorder: inputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(8)
      ),
      keyboardType: textInputType,
      obscureText: isPass,
    );
  }
}
