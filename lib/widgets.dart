import 'package:flutter/material.dart' show Alignment, AlignmentGeometry, Axis, BlendMode, BorderRadius, BorderSide, BoxBorder, BoxConstraints, BoxDecoration, BoxShadow, BoxShape, Clip, Color, Colors, Container, CrossAxisAlignment, Decoration, DecorationImage, EdgeInsetsGeometry, Expanded, Flex, FontWeight, FractionallySizedBox, Gradient, InputDecoration, MainAxisAlignment, MainAxisSize, Matrix4, SizedBox, StatelessWidget, TextBaseline, TextDirection, TextEditingController, TextFormField, TextStyle, UnderlineInputBorder, VerticalDirection, Widget;

class Empty extends StatelessWidget {

  const Empty({super.key});

  @override
  build(context) {
    return const SizedBox();
  }

}

/// General layout component to avoid too much boilerplate
class Box extends StatelessWidget {

  const Box({
    super.key,
    this.backgroundColor,
    this.direction,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
    this.mainAxisDirection,
    this.mainAxisSize,
    this.clipBehavior,
    this.textDirection,
    this.textBaseline,
    this.child,
    this.children,
    this.border,
    this.constraints,
    this.padding,
    this.width,
    this.height,
    this.widthFactor,
    this.heightFactor,
    this.alignment,
    this.margin,
    this.transform,
    this.transformAlignment,
    this.foregroundDecoration,
    this.expandChild = false,
    this.borderRadius,
    this.backgroundBlendMode,
    this.boxShadow,
    this.gradient,
    this.image,
    this.shape = BoxShape.rectangle,
    this.horizontalGap,
    this.verticalGap,
    this.childGap,
  });

  final double? width;

  final double? height;

  final double? widthFactor;

  final double? heightFactor;

  /// Wrap the [Widget] passed to [child] named parameter
  /// in a [Expanded] Widget for those widgets that need to fit the available space
  /// and avoid render errors like overflowing the internal [Flex] parent.
  final bool expandChild;

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

  final double? horizontalGap;

  final double? verticalGap;

  final Widget? childGap;

  final Clip? clipBehavior;

  final TextDirection? textDirection;

  final TextBaseline? textBaseline;

  final BorderRadius? borderRadius;

  final BlendMode? backgroundBlendMode;

  final List<BoxShadow>? boxShadow;

  final Gradient? gradient;

  final DecorationImage? image;

  final BoxShape shape;

  final Widget? child;

  final List<Widget>? children;

  @override
  build(context) {
    if (this.child != null && this.children != null) {
      throw Exception('Both child and children cannot be specified. Use only one of them.');
    }

    var children = this.children ?? [];

    if (this.horizontalGap != null || this.verticalGap != null || this.childGap != null) {
      // https://github.com/flutter/flutter/issues/16957#issuecomment-488153375
      children = children.expand((child) sync* {
        yield SizedBox(width: this.horizontalGap, height: this.verticalGap, child: this.childGap);
        yield child;
      }).skip(1).toList();
    }

    final container = Container(
      width: width,
      height: height,

      alignment: alignment,
      constraints: constraints,

      decoration: BoxDecoration(
        color: this.backgroundColor,
        border: border,
        borderRadius: this.borderRadius,
        backgroundBlendMode: this.backgroundBlendMode,
        boxShadow: this.boxShadow,
        gradient: this.gradient,
        image: this.image,
        shape: this.shape,
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

        children: this.child != null
          ? [this.expandChild ? Expanded(child: this.child!) : this.child!]
          : children
        ,
      ),
    );

    if (width != null && widthFactor != null) {
      throw Exception('Both width and widthFactor cannot be specified. Use only one of them.');
    }

    if (height != null && heightFactor != null) {
      throw Exception('Both height and heightFactor cannot be specified. Use only one of them.');
    }

    if (widthFactor != null || heightFactor != null) {
      return FractionallySizedBox(
        widthFactor: this.widthFactor,
        heightFactor: this.heightFactor,

        child: container,
      );
    }

    return container;
  }

}

InputDecoration createInputDecoration(Map<String, dynamic> inputDecorationSettings) {
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

  final inputDecoration = Function.apply(InputDecoration.new, [], mixedInputDecorationSettigns) as InputDecoration;

  return inputDecoration;
}

class InputTextField extends StatelessWidget {

  const InputTextField({
    super.key,
    this.readOnly = false,
    this.label = 'Unnamed Label',
    this.placeholder = '',
    this.initialValue,
    this.controller,
    this.validator,
    this.style,
    this.onTap,
    this.onChange,
    this.canRequestFocus = true,
  });

  final String label;

  final String placeholder;

  final String? initialValue;

  final TextEditingController? controller;

  final String? Function(String?)? validator;

  final bool canRequestFocus;

  final TextStyle? style;

  final void Function()? onTap;

  final void Function(String)? onChange;

  final bool readOnly;

  @override
  build(context) {
    return TextFormField(
      initialValue: this.initialValue,
      controller: this.controller,
      readOnly: this.readOnly,
      canRequestFocus: this.canRequestFocus,

      style: this.style,
      decoration: createInputDecoration({'labelText': this.label, 'hintText': this.placeholder}),

      onTap: this.onTap,
      onChanged: this.onChange,

      validator: validator,
    );
  }

}
