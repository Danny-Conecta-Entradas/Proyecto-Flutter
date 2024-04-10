import 'package:flutter/material.dart' show
  TextStyle, Colors, Color, UnderlineInputBorder, BorderSide,
  FontWeight, InputDecoration, StatelessWidget, TextEditingController,
  Widget, BuildContext, TextFormField
;

createInputDecoration(Map<String, dynamic> inputDecorationSettings) {
  const baseInputDecorationSettings = {
    'labelStyle': TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 18, fontWeight: FontWeight.bold),
    'hintStyle': TextStyle(color: Color.fromARGB(255, 159, 159, 159)),
    'enabledBorder': UnderlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 149, 149, 149))),
    'focusedBorder': UnderlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 0, 255, 234))),
    'errorStyle': TextStyle(color: Colors.red, fontSize: 14),
    'errorBorder': UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
    'counterStyle': TextStyle(color: Colors.white)
  };

  final mixedInputDecorationSettigns = {
    ...baseInputDecorationSettings,
    ...inputDecorationSettings,
  }
  .map((key, value) => MapEntry(Symbol(key), value));

  final inputDecoration = Function.apply(InputDecoration.new, [], mixedInputDecorationSettigns);

  return inputDecoration;
}

class InputTextField extends StatelessWidget {

  const InputTextField({
    super.key,
    this.label = 'Unnamed Label',
    this.initialValue,
    this.controller,
    this.validator,
    this.style,
    this.onTap,
    this.readOnly = false,
  });

  final String label;

  final String? initialValue;

  final TextEditingController? controller;

  final String? Function(String?)? validator;

  final TextStyle? style;

  final void Function()? onTap;

  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: this.initialValue,
      controller: this.controller,
      readOnly: this.readOnly,
      style: this.style,
      decoration: createInputDecoration({'labelText': this.label}),

      onTap: this.onTap,

      validator: validator,
    );
  }

}
