import 'package:flutter/material.dart' show Alignment, AlignmentGeometry, Axis, BorderSide, BoxBorder, BoxConstraints, BoxDecoration, Clip, Color, Colors, Container, CrossAxisAlignment, Decoration, EdgeInsetsGeometry, Flex, FontWeight, InputDecoration, MainAxisAlignment, MainAxisSize, Matrix4, StatelessWidget, TextBaseline, TextDirection, TextEditingController, TextFormField, TextStyle, UnderlineInputBorder, VerticalDirection, Widget;

/// General layout component to avoid too much boilerplate
class Box extends StatelessWidget {

  const Box({super.key, this.backgroundColor, this.direction, this.mainAxisAlignment, this.crossAxisAlignment, this.mainAxisDirection, this.mainAxisSize, this.clipBehavior, this.textDirection, this.textBaseline, this.child, this.children, this.border, this.constraints, this.padding, this.width, this.height, this.alignment, this.margin, this.transform, this.transformAlignment, this.foregroundDecoration});

  final double? width;

  final double? height;

  final Alignment? alignment;

  final Matrix4? transform;

  final AlignmentGeometry? transformAlignment;

  final Color? backgroundColor;

  final BoxBorder? border;

  final EdgeInsetsGeometry? padding;

  final EdgeInsetsGeometry? margin;

  final Decoration? foregroundDecoration;

  final BoxConstraints? constraints;

  final Axis? direction;

  final MainAxisAlignment? mainAxisAlignment;

  final CrossAxisAlignment? crossAxisAlignment;

  final VerticalDirection? mainAxisDirection;

  final MainAxisSize? mainAxisSize;

  final Clip? clipBehavior;

  final TextDirection? textDirection;

  final TextBaseline? textBaseline;

  final Widget? child;

  final List<Widget>? children;

  @override
  build(context) {
    if (this.child != null && this.children != null) {
      throw Exception('Both child and children cannot be specified. Use only one of them.');
    }

    return Container(
      width: width,
      height: height,

      alignment: alignment,
      constraints: constraints,

      decoration: BoxDecoration(
        color: this.backgroundColor,
        border: border,
      ),

      padding: padding,
      margin: margin,

      transform: transform,
      transformAlignment: transformAlignment,

      foregroundDecoration: foregroundDecoration,

      clipBehavior: clipBehavior ?? Clip.none,

      child: Flex(
        direction: this.direction ?? Axis.vertical,
        verticalDirection: mainAxisDirection ?? VerticalDirection.down,

        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
        crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
        mainAxisSize: mainAxisSize ?? MainAxisSize.max,

        textBaseline: textBaseline,
        textDirection: textDirection,

        children: child != null ? [child!] : (children ?? []),
      ),
    );
  }

}

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
  build(context) {
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
