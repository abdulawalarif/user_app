import 'package:flutter/material.dart';
import 'package:user_app/ui/utils/my_border.dart';

class ReusableTextField extends StatelessWidget {
  final TextEditingController? controller;
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
  final void Function(String?)? onSaved;

  const ReusableTextField({
    super.key,
     this.controller,
    required this.focusNode,
    required this.valueKey,
    this.textCapitalization = TextCapitalization.words,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.onSaved,
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
        onSaved: onSaved,
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




class PasswordTextField extends StatefulWidget {
  final FocusNode? focusNode;
  final String label;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final VoidCallback? onEditingComplete;

  const PasswordTextField({
    super.key,
    this.focusNode,
    required this.label,
    this.validator,
    this.onSaved,
    this.onEditingComplete,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _passwordIsVisible = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0),
      child: TextFormField(
        focusNode: widget.focusNode,
        validator: widget.validator,
        onSaved: widget.onSaved,
        onEditingComplete: widget.onEditingComplete,
        obscureText: !_passwordIsVisible,
        maxLines: 1,
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          labelText: widget.label,
          border: const OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
          filled: true,
          fillColor: Theme.of(context).cardColor,
          suffix: SizedBox(
            height: 32,
            width: 28,
            child: IconButton(
              onPressed: () {
                setState(() {
                  _passwordIsVisible = !_passwordIsVisible;
                });
              },
              splashRadius: 18,
              iconSize: 18,
              icon: Icon(
                _passwordIsVisible
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
