import 'package:flutter/material.dart';
import 'package:user_app/ui/utils/my_border.dart';

class TextFieldForAddress extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String valueKey;
  final TextCapitalization textCapitalization;
  final String? Function(String?)? validator;
  final int maxLines;
  final String labelText;
  final String hintText;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final VoidCallback? onEditingComplete;

  const TextFieldForAddress({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.valueKey,
    this.textCapitalization = TextCapitalization.words,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.maxLines = 1,
    required this.labelText,
    required this.hintText,
    this.onEditingComplete,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        key: ValueKey(valueKey),
        textCapitalization: textCapitalization,
        validator: validator,
        maxLines: maxLines,
        textInputAction: textInputAction,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          contentPadding: const EdgeInsets.all(12),
          border: const OutlineInputBorder(),
          enabledBorder: MyBorder.outlineInputBorder(context),
          filled: true,
          fillColor: Theme.of(context).cardColor,
        ),
        onEditingComplete: onEditingComplete,
      ),
    );
  }
}
