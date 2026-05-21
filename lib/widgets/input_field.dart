import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final String placeholder;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final int maxLines;

  const InputField({
    Key? key,
    required this.placeholder,
    required this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late bool _obscureText;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        setState(() => _isFocused = hasFocus);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: _isFocused
              ? [
                  BoxShadow(
                    color: const Color(0xFF84cc16).withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 0,
                  ),
                ]
              : [],
        ),
        child: TextField(
          controller: widget.controller,
          obscureText: _obscureText,
          keyboardType: widget.keyboardType,
          maxLines: widget.isPassword ? 1 : widget.maxLines,
          decoration: InputDecoration(
            hintText: widget.placeholder,
            hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: Colors.white.withOpacity(0.1),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: Colors.white.withOpacity(0.1),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Color(0xFF84cc16),
                width: 2,
              ),
            ),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),
            suffixIcon: widget.isPassword
                ? GestureDetector(
                    onTap: () {
                      setState(() => _obscureText = !_obscureText);
                    },
                    child: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: const Color(0xFF84cc16),
                      size: 22,
                    ),
                  )
                : null,
          ),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          cursorColor: const Color(0xFF84cc16),
        ),
      ),
    );
  }
}
